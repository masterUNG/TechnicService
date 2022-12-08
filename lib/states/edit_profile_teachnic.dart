import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:technicservice/utility/app_constant.dart';
import 'package:technicservice/utility/app_controller.dart';
import 'package:technicservice/utility/app_service.dart';
import 'package:technicservice/widgets/widget_button.dart';
import 'package:technicservice/widgets/widget_form.dart';
import 'package:technicservice/widgets/widget_google_map.dart';
import 'package:technicservice/widgets/widget_icon_button.dart';
import 'package:technicservice/widgets/widget_progress.dart';
import 'package:technicservice/widgets/widget_show_head.dart';
import 'package:technicservice/widgets/widget_show_profile.dart';
import 'package:technicservice/widgets/widget_text.dart';

class EditProfileTechnic extends StatefulWidget {
  const EditProfileTechnic({super.key});

  @override
  State<EditProfileTechnic> createState() => _EditProfileTechnicState();
}

class _EditProfileTechnicState extends State<EditProfileTechnic> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  AppController controller = Get.put(AppController());

  String? chooseSkill;

  Map<String, dynamic> map = {};

  @override
  void initState() {
    super.initState();

    nameController.text = controller.userModels[0].name;
    addressController.text = controller.userModels[0].address;
    phoneController.text = controller.userModels[0].phone;

    for (var element in controller.userModels[0].skillTechnic!) {
      controller.typeUsers.remove(element);
    }

    map = controller.userModels[0].toMap();
    print('map Start ==> $map');
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('##8dec typeUsers ---> ${appController.typeUsers}');
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: WidgetText(
                text: 'แก้ไข โปรไฟร์',
                textStyle: AppConstant().h2Style(),
              ),
              actions: [
                WidgetIconButton(
                  iconData: Icons.save,
                  pressFunc: () {
                    uploadNewImageProfile();
                  },
                  iconColor: Theme.of(context).primaryColor,
                )
              ],
            ),
            body: appController.userModels.isEmpty
                ? const WidgetProgress()
                : ListView(
                    children: [
                      imageProfile(appController),
                      const WidgetShowHead(head: 'ข้อมูลทั้วไป :'),
                      generalForm(),
                      const WidgetShowHead(head: 'สกิวส์ช่าง :'),
                      listSkillDelete(appController),
                       dropdownAddSkill(appController),
                      const WidgetShowHead(head: 'แผนที่ร้าน :'),
                      showMap(appController),
                      bottonSave(),
                    ],
                  ),
          );
        });
  }

  Row showMap(AppController appController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: AppConstant().borderCurveBox(),
          width: 250,
          height: 200,
          child: WidgetGoogleMap(
              lat: appController.userModels[0].geoPoint.latitude,
              lng: appController.userModels[0].geoPoint.longitude),
        ),
      ],
    );
  }

  Row bottonSave() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          width: 250,
          child: WidgetButton(
            label: 'Save Profile',
            pressFunc: () {
              uploadNewImageProfile();
            },
          ),
        ),
      ],
    );
  }

  Widget dropdownAddSkill(AppController appController) {
    return appController.typeUsers.isEmpty ? const SizedBox() :   Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          child: DropdownButton(
            isExpanded: true,
            hint: WidgetText(
              text: 'เพิ่ม สกิวส์ช่าง',
              textStyle: AppConstant().h3Style(),
            ),
            value: chooseSkill,
            items: appController.typeUsers
                .map(
                  (element) => DropdownMenuItem(
                    child: WidgetText(
                      text: element,
                      textStyle: AppConstant().h3Style(),
                    ),
                    value: element,
                  ),
                )
                .toList(),
            onChanged: (value) {
              chooseSkill = value;
              setState(() {});
            },
          ),
        ),
        WidgetIconButton(
          iconData: Icons.save,
          iconColor: Colors.green,
          pressFunc: () {
            if (chooseSkill != null) {
              print('chooseSkill --> $chooseSkill');
              print(
                  'skill ก่อนเพิ่ม --> ${appController.userModels[0].skillTechnic}');
              var skills = appController.userModels[0].skillTechnic;
              skills?.add(chooseSkill!);
              print('skills --> $skills');
              map['skillTechnic'] = skills;
              processSaveProfile();
            }
          },
        )
      ],
    );
  }

  Row listSkillDelete(AppController appController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: appController.userModels[0].skillTechnic!.length,
            itemBuilder: (context, index) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WidgetText(
                    text: appController.userModels[0].skillTechnic![index]),
                WidgetIconButton(
                  iconData: Icons.delete_forever_outlined,
                  iconColor: Colors.red,
                  pressFunc: () {},
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget generalForm() {
    return SizedBox(
      width: 250,
      child: Column(
        children: [
          WidgetForm(
            labelWidget: WidgetText(
              text: 'ชื่อ :',
              textStyle: AppConstant().h3Style(),
            ),
            textEditingController: nameController,
            changeFunc: (p0) {
              String name = p0.trim();
              map['name'] = name;
            },
          ),
          WidgetForm(
            labelWidget: WidgetText(
              text: 'ที่อยู่ :',
              textStyle: AppConstant().h3Style(),
            ),
            textEditingController: addressController,
            changeFunc: (p0) {
              String address = p0.trim();
              map['address'] = address;
            },
          ),
          WidgetForm(
            textInputType: TextInputType.phone,
            labelWidget: WidgetText(
              text: 'เบอร์โทร :',
              textStyle: AppConstant().h3Style(),
            ),
            textEditingController: phoneController,
            changeFunc: (p0) {
              String phone = p0.trim();
              map['phone'] = phone;
            },
          ),
        ],
      ),
    );
  }

  Widget imageProfile(AppController appController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            children: [
              appController.files.isEmpty
                  ? WidgetShowProfile(
                      radius: 100,
                      urlImage: appController.userModels[0].urlProfile!.isEmpty
                          ? AppConstant.urlFreeProfile
                          : appController.userModels[0].urlProfile!)
                  : CircleAvatar(
                      radius: 100,
                      backgroundImage: FileImage(appController.files[0]),
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
                    File? file = await AppService()
                        .processTakePhoto(source: ImageSource.camera);
                    appController.files.add(file!);
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
                    File? file = await AppService()
                        .processTakePhoto(source: ImageSource.gallery);
                    appController.files.add(file!);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> uploadNewImageProfile() async {
    if (controller.files.isNotEmpty) {
      //มีการ เปลี่ยนภาพ
      String nameFile =
          '${controller.uidLogins[0]}${Random().nextInt(1000000)}.jpg';
      String? urlImage =
          await AppService().processUploadImage(path: 'profile/$nameFile');
      print('Have Photo $urlImage');
      map['urlProfile'] = urlImage;
      processSaveProfile();
    } else {
      //ไม่มีการเปลี่ยนภาพ
      print('No Photo');
      processSaveProfile();
    }
  }

  Future<void> processSaveProfile() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(controller.uidLogins[0])
        .update(map)
        .then((value) {
      // controller.findUserModelLogins();
      controller.findUserModel(uid: controller.uidLogins[0]);
      Get.back();
    });
  }
}
