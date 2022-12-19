import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:technicservice/models/referance_model.dart';
import 'package:technicservice/utility/app_constant.dart';
import 'package:technicservice/utility/app_controller.dart';
import 'package:technicservice/utility/app_dialog.dart';
import 'package:technicservice/utility/app_service.dart';
import 'package:technicservice/widgets/widget_button.dart';
import 'package:technicservice/widgets/widget_form.dart';
import 'package:technicservice/widgets/widget_icon_button.dart';
import 'package:technicservice/widgets/widget_image.dart';
import 'package:technicservice/widgets/widget_show_head.dart';
import 'package:technicservice/widgets/widget_text.dart';

class AddReferance extends StatefulWidget {
  const AddReferance({super.key});

  @override
  State<AddReferance> createState() => _AddReferanceState();
}

class _AddReferanceState extends State<AddReferance> {
  String showDate = 'dd/MMM/yyyy';
  AppController controller = Get.put(AppController());

  String? name, detail;
  Timestamp? timestamp;

  @override
  void initState() {
    super.initState();
    if (controller.files.isNotEmpty) {
      controller.files.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(
        title: WidgetText(
          text: 'Add Referance',
          textStyle: AppConstant().h2Style(),
        ),
        actions: [
          WidgetIconButton(
            iconData: Icons.save,
            pressFunc: () {
              processSave();
            },
            iconColor: Theme.of(context).primaryColor,
          )
        ],
      ),
      body: GetX(
          init: AppController(),
          builder: (AppController appController) {
            print('##8dec files--> ${appController.files}');
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () =>
                  FocusScope.of(context).requestFocus(FocusScopeNode()),
              child: ListView(
                children: [
                  const WidgetShowHead(head: 'รูปภาพของงาน :'),
                  imageBuilding(appController: appController),
                  const WidgetShowHead(head: 'ข้อมูลทัวไป :'),
                  nameForm(),
                  detailForm(),
                  const WidgetShowHead(head: 'วันที่งานสำเร็จ'),
                  showDateJob(),
                  buttonSave(),
                ],
              ),
            );
          }),
    );
  }

  Row buttonSave() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetButton(
          label: 'Save Referance',
          pressFunc: () {
            processSave();
          },
          width: 250,
        ),
      ],
    );
  }

  Row showDateJob() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          width: 250,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WidgetText(
                text: showDate,
                textStyle: AppConstant().h3Style(fontWeight: FontWeight.bold),
              ),
              WidgetIconButton(
                iconData: Icons.calculate,
                pressFunc: () async {
                  DateTime dateTime = DateTime.now();

                  await showDatePicker(
                    context: context,
                    initialDate: dateTime,
                    firstDate: DateTime(dateTime.year - 3),
                    lastDate: dateTime,
                  ).then((value) {
                    DateTime? chooseDateTime = value;
                    if (chooseDateTime != null) {
                      timestamp = Timestamp.fromDate(chooseDateTime);

                      showDate = AppService()
                          .dateTimeToString(dateTime: chooseDateTime);
                      setState(() {});
                    }
                  });
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Row detailForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetForm(
          labelWidget: WidgetText(
            text: 'รายละเอียดของงาน :',
            textStyle: AppConstant().h3Style(),
          ),
          changeFunc: (p0) {
            detail = p0.trim();
          },
        ),
      ],
    );
  }

  Row nameForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetForm(
          labelWidget: WidgetText(
            text: 'ชื่อของงาน :',
            textStyle: AppConstant().h3Style(),
          ),
          changeFunc: (p0) {
            name = p0.trim();
          },
        ),
      ],
    );
  }

  Row imageBuilding({required AppController appController}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(36.0),
              child: appController.files.isNotEmpty
                  ? SizedBox(
                      width: 250,
                      height: 250,
                      child: Image.file(
                        appController.files[0],
                        fit: BoxFit.cover,
                      ),
                    )
                  : const WidgetImage(
                      path: 'images/build.png',
                      size: 250,
                    ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: WidgetIconButton(
                iconData: Icons.add_a_photo,
                pressFunc: () async {
                  if (appController.files.isNotEmpty) {
                    appController.files.clear();
                  }
                  await AppService()
                      .processTakePhoto(source: ImageSource.camera)
                      .then((value) {
                    appController.files.add(value!);
                  });
                },
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: WidgetIconButton(
                iconData: Icons.add_photo_alternate,
                pressFunc: () async {
                  if (appController.files.isNotEmpty) {
                    appController.files.clear();
                  }
                  await AppService()
                      .processTakePhoto(source: ImageSource.gallery)
                      .then((value) {
                    appController.files.add(value!);
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> processSave() async {
    if (controller.files.isEmpty) {
      AppDialog(context: context).normalDialog(
          title: 'No Image ?', detail: 'กรุณา ใส่ภาพผลงาน ด้วยคะ');
    } else if ((name?.isEmpty ?? true) || (detail?.isEmpty ?? true)) {
      AppDialog(context: context).normalDialog(
          title: 'กรอกไม่ครบ', detail: 'กรุณา กรอกข้อมูลทั่วไปให้ครบ');
    } else if (timestamp == null) {
      AppDialog(context: context).normalDialog(
          title: 'วันที่งานสำเร็จ ?',
          detail: 'กรุณาเลือก วันที่งานสำเร็จด้วย คะ');
    } else {
      String path =
          'referance/${controller.uidLogins[0]}${Random().nextInt(1000000)}.jpg';
      print('path --> $path');

      String? urlImage = await AppService().processUploadImage(path: path);
      print('urlImage --> $urlImage');

      ReferanceModel referanceModel = ReferanceModel(
          urlJob: urlImage!,
          nameJob: name!,
          detail: detail!,
          uidTechnic: controller.uidLogins[0],
          timestampJob: timestamp!,
          timestampUpdate: Timestamp.fromDate(DateTime.now()));

      await FirebaseFirestore.instance
          .collection('referance')
          .doc()
          .set(referanceModel.toMap())
          .then((value) {
        Get.back();
      });
    }
  }
}
