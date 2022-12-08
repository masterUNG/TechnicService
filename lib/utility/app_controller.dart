import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:technicservice/models/typetechnic_model.dart';
import 'package:technicservice/models/user_model.dart';

class AppController extends GetxController {
  RxBool redEye = true.obs;
  RxInt indexTypeUser = 0.obs;
  RxInt indexBody = 0.obs;

  RxList<UserModel> userModelLogins = <UserModel>[].obs;
  RxList<String> uidLogins = <String>[].obs;
  RxList<UserModel> userModels = <UserModel>[].obs;
  RxList<File> files = <File>[].obs;
  RxList<String> typeUsers = <String>[].obs;

  Future<void> readAllTypeUser() async {
    await FirebaseFirestore.instance
        .collection('typeteachnic')
        .get()
        .then((value) {
      for (var element in value.docs) {
        TypeTechnicModel typeTechnicModel =
            TypeTechnicModel.fromMap(element.data());
        typeUsers.add(typeTechnicModel.name);
      }
    });
  }

  Future<void> findUserModel({required String uid}) async {
    if (userModels.isNotEmpty) {
      userModels.clear();
    }

    await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .get()
        .then((value) {
      UserModel userModel = UserModel.fromMap(value.data()!);
      userModels.add(userModel);
    });
  }

  Future<void> findUserModelLogins() async {
    if (userModelLogins.isNotEmpty) {
      userModelLogins.clear();
      uidLogins.clear();
    }

    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      uidLogins.add(user.uid);
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get()
          .then((value) {
        UserModel userModel = UserModel.fromMap(value.data()!);
        print('userModel -----> ${userModel.toMap()}');
        userModelLogins.add(userModel);
      });
    }
  }
}
