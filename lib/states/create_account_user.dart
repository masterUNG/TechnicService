import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:technicservice/models/user_model.dart';
import 'package:technicservice/states/main_home.dart';
import 'package:technicservice/utility/app_constant.dart';
import 'package:technicservice/utility/app_controller.dart';
import 'package:technicservice/utility/app_dialog.dart';
import 'package:technicservice/utility/app_service.dart';
import 'package:technicservice/widgets/widget_button.dart';
import 'package:technicservice/widgets/widget_form.dart';
import 'package:technicservice/widgets/widget_google_map.dart';
import 'package:technicservice/widgets/widget_icon_button.dart';
import 'package:technicservice/widgets/widget_image.dart';
import 'package:technicservice/widgets/widget_menu.dart';
import 'package:technicservice/widgets/widget_progress.dart';
import 'package:technicservice/widgets/widget_text.dart';

class CreateAccountUser extends StatefulWidget {
  const CreateAccountUser({super.key});

  @override
  State<CreateAccountUser> createState() => _CreateAccountUserState();
}

class _CreateAccountUserState extends State<CreateAccountUser> {
  Position? position;
  String? name, surName, address, phone, email, password;

  @override
  void initState() {
    super.initState();
    findPosition();
  }

  Future<void> findPosition() async {
    await AppService().processFindPosition(context: context).then((value) {
      position = value;
      print('position = ${position.toString()}');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints boxConstraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () =>
                  FocusScope.of(context).requestFocus(FocusScopeNode()),
              child: Container(
                decoration: AppConstant()
                    .imageBox(path: 'images/bg2.jpg', opacity: 0.6),
                width: boxConstraints.maxWidth,
                height: boxConstraints.maxHeight,
                child: Stack(
                  children: [
                    WidgetMenu(
                        leadWidget: WidgetIconButton(
                          iconColor: AppConstant.dark,
                          iconData: Icons.arrow_back,
                          pressFunc: () {
                            Get.back();
                          },
                        ),
                        title: AppConstant.typeUserShows[0]),
                    Positioned(
                      right: boxConstraints.maxWidth * 0.1,
                      top: boxConstraints.maxWidth * 0.1,
                      child: WidgetImage(
                        size: boxConstraints.maxWidth * 0.2,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding:
                            const EdgeInsets.only(left: 32, right: 32, top: 32),
                        width: boxConstraints.maxWidth,
                        height: boxConstraints.maxHeight -
                            boxConstraints.maxWidth * 0.4,
                        decoration: AppConstant().curveBox(),
                        child: ListView(
                          children: [
                            WidgetText(
                              text: 'ข้อมูลสมาชิก :',
                              textStyle: AppConstant().h2Style(),
                            ),
                            WidgetForm(
                              labelWidget: const WidgetText(text: 'ชื่อ'),
                              changeFunc: (p0) {
                                name = p0.trim();
                              },
                            ),
                            WidgetForm(
                              labelWidget: const WidgetText(text: 'นามสกุล'),
                              changeFunc: (p0) {
                                surName = p0.trim();
                              },
                            ),
                            WidgetForm(
                              labelWidget: const WidgetText(text: 'ที่อยู่'),
                              changeFunc: (p0) {
                                address = p0.trim();
                              },
                            ),
                            WidgetForm(
                              textInputType: TextInputType.phone,
                              labelWidget:
                                  const WidgetText(text: 'เบอร์โทรศัพย์'),
                              changeFunc: (p0) {
                                phone = p0.trim();
                              },
                            ),
                            WidgetForm(
                              textInputType: TextInputType.emailAddress,
                              labelWidget: const WidgetText(text: 'Email'),
                              changeFunc: (p0) {
                                email = p0.trim();
                              },
                            ),
                            WidgetForm(
                              labelWidget: const WidgetText(text: 'Password'),
                              changeFunc: (p0) {
                                password = p0.trim();
                              },
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: WidgetText(
                                text: 'พิกัด :',
                                textStyle: AppConstant().h2Style(),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: AppConstant().borderCurveBox(),
                              width: 200,
                              height: 180,
                              child: position == null
                                  ? const WidgetProgress()
                                  : WidgetGoogleMap(
                                      lat: position!.latitude,
                                      lng: position!.longitude),
                            ),
                            WidgetButton(
                              label: 'ยืนยัน',
                              pressFunc: () async {
                                if ((name?.isEmpty ?? true) ||
                                    (surName?.isEmpty ?? true) ||
                                    (address?.isEmpty ?? true) ||
                                    (phone?.isEmpty ?? true) ||
                                    (email?.isEmpty ?? true) ||
                                    (password?.isEmpty ?? true)) {
                                  AppDialog(context: context).normalDialog(
                                      title: 'มีช่องว่าง ?',
                                      detail: 'กรุณากรอก ข้อมูล ทุกช่อง คะ');
                                } else {
                                  UserModel userModel = UserModel(
                                      name: name!,
                                      surName: surName!,
                                      address: address!,
                                      phone: phone!,
                                      email: email!,
                                      password: password!,
                                      typeUser: AppConstant.typeUsers[0],
                                      geoPoint: GeoPoint(position!.latitude,
                                          position!.longitude));

                                  print('userModel = ${userModel.toMap()}');

                                  await AppService()
                                      .processCreateNewAccount(
                                          email: email!,
                                          password: password!,
                                          context: context,
                                          userModel: userModel)
                                      .then((value) {
                                    print('Create Account success');
                                    Get.offAll(const MainHome());
                                  });
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
