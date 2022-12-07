import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technicservice/states/edit_profile_teachnic.dart';
import 'package:technicservice/utility/app_constant.dart';
import 'package:technicservice/utility/app_controller.dart';
import 'package:technicservice/widgets/widget_button.dart';
import 'package:technicservice/widgets/widget_google_map.dart';
import 'package:technicservice/widgets/widget_show_head.dart';
import 'package:technicservice/widgets/widget_show_profile.dart';
import 'package:technicservice/widgets/widget_text.dart';

class ProfileTeachnic extends StatefulWidget {
  const ProfileTeachnic({super.key});

  @override
  State<ProfileTeachnic> createState() => _ProfileTeachnicState();
}

class _ProfileTeachnicState extends State<ProfileTeachnic> {
  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('userModles ==> ${appController.userModels}');
          return ListView(
            children: [
              imageProfile(appController),
              const WidgetShowHead(head: 'ข้อมูลทั่วไป :'),
              showTitle(
                  head: 'ชื่อ :', value: appController.userModels[0].name),
              showTitle(
                  head: 'ที่อยู่ :',
                  value: appController.userModels[0].address),
              showTitle(
                  head: 'เบอร์โทร :', value: appController.userModels[0].phone),
              const WidgetShowHead(head: 'Skill Technic :'),
              listSkill(appController),
              const WidgetShowHead(head: 'แผนที่ร้าน :'),
              showMap(appController),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 30, bottom: 30),
                    width: 250,
                    child: WidgetButton(
                      label: 'Edit Profile',
                      pressFunc: () {
                        Get.to(const EditProfileTechnic());
                      },
                    ),
                  ),
                ],
              ),
            ],
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

  Row listSkill(AppController appController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 250,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: appController.userModels[0].skillTechnic!.length,
            itemBuilder: (context, index) => WidgetText(
                text: appController.userModels[0].skillTechnic![index]),
          ),
        ),
      ],
    );
  }

  

  Padding showTitle({required String head, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: WidgetText(
              text: head,
              textStyle: AppConstant().h2Style(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: WidgetText(
              text: value,
              textStyle:
                  AppConstant().h2Style(fontWeight: FontWeight.w500, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Row imageProfile(AppController appController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetShowProfile(
          urlImage: appController.userModels[0].urlProfile!.isEmpty
              ? AppConstant.urlFreeProfile
              : appController.userModels[0].urlProfile!,
          radius: 100,
        ),
      ],
    );
  }
}
