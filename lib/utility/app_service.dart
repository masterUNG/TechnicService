import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:technicservice/models/user_model.dart';
import 'package:technicservice/utility/app_constant.dart';
import 'package:technicservice/utility/app_controller.dart';
import 'package:technicservice/utility/app_dialog.dart';
import 'package:technicservice/widgets/widget_text_button.dart';

class AppService {
  String dateTimeToString({required DateTime dateTime}) {
    DateFormat dateFormat = DateFormat('dd MMM yyyy');
    return dateFormat.format(dateTime);
  }

  Future<String?> processUploadImage({required String path}) async {
    AppController appController = Get.put(AppController());
    String? urlImage;

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child(path);
    UploadTask uploadTask = reference.putFile(appController.files[0]);
    await uploadTask.whenComplete(() async {
      await reference.getDownloadURL().then((value) {
        urlImage = value.toString();
        appController.files.clear();
      });
    });
    return urlImage;
  }

  Future<File?> processTakePhoto({required ImageSource source}) async {
    File? file;
    var result = await ImagePicker()
        .pickImage(source: source, maxWidth: 800, maxHeight: 800);
    if (result != null) {
      file = File(result.path);
    }
    return file;
  }

  bool checkChooseTypeTechnic({required List<bool> listChooses}) {
    bool result = true; // true ไม่เลือกอะไร ? เลย

    for (var element in listChooses) {
      if (result) {
        if (element) {
          result = false;
        }
      }
    }

    return result;
  }

  Future<void> processCreateNewAccount({
    required String email,
    required String password,
    required BuildContext context,
    required UserModel userModel,
  }) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      String uid = value.user!.uid;
      print('uid = $uid');
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .set(userModel.toMap())
          .then((value) {
        Get.offAllNamed(AppConstant.pageMainHome);
      });
    }).catchError((onError) {
      AppDialog(context: context)
          .normalDialog(title: onError.code, detail: onError.message);
    });
  }

  Future<Position?> processFindPosition({required BuildContext context}) async {
    Position? position;
    bool locationServiceEnable = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission;

    if (locationServiceEnable) {
      //Open Service

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        //ไม่อนุญาติเลย
        dialogOpenPermission(context);
      } else {
        if (permission == LocationPermission.denied) {
          //ยังไม่รู้
          permission = await Geolocator.requestPermission();
          if ((permission != LocationPermission.whileInUse) &&
              (permission != LocationPermission.always)) {
            //Denied Forver
            dialogOpenPermission(context);
          } else {
            position = await Geolocator.getCurrentPosition();
          }
        } else {
          position = await Geolocator.getCurrentPosition();
        }
      }
    } else {
      // Off Service
      AppDialog(context: context).normalDialog(
          title: 'Off Location ?',
          detail: 'กรุณาเปิด Location Service ด้วยครับ',
          secondBotton: WidgetTextButton(
            label: 'เปิด Location',
            pressFunc: () {
              Geolocator.openLocationSettings();
              exit(0);
            },
          ));
    }

    return position;
  }

  void dialogOpenPermission(BuildContext context) {
    AppDialog(context: context).normalDialog(
        title: 'ไม่อนุญาติ แชร์ พิกัด ?',
        detail: 'กรุณา อนุญาติ แชร์พิกัดด้วย',
        secondBotton: WidgetTextButton(
          label: 'อนุญาติ แชร์พิกัด',
          pressFunc: () {
            Geolocator.openAppSettings();
            exit(0);
          },
        ));
  }
}
