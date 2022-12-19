import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technicservice/bodys/main_center.dart';
import 'package:technicservice/bodys/message_teachnic.dart';
import 'package:technicservice/bodys/message_user.dart';
import 'package:technicservice/bodys/profile_teachnic.dart';
import 'package:technicservice/bodys/referance_teachnic.dart';
import 'package:technicservice/utility/app_constant.dart';
import 'package:technicservice/utility/app_controller.dart';
import 'package:technicservice/utility/app_dialog.dart';
import 'package:technicservice/widgets/widget_image.dart';
import 'package:technicservice/widgets/widget_menu.dart';
import 'package:technicservice/widgets/widget_progress.dart';
import 'package:technicservice/widgets/widget_text.dart';
import 'package:technicservice/widgets/widget_text_button.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  bool? statusLogin; // true => Login, false => LogOut
  bool load = true;

  AppController controller = Get.put(AppController());

  var bodys = <Widget>[
    const MainCenter(),
    const MessageTeachnic(),
    const ProfileTeachnic(),
    const ReferanceTeachnic(),
    const MessageUser(),
  ];

  var titles = <String>[
    'หน้าหลัก',
    'ข่าวสาร',
    'Profile',
    'Referance',
    'ข่าวสาร',
  ];

  @override
  void initState() {
    super.initState();
    checkLogin();
    controller.readAllTypeUser();
    controller.readAllReferance();
  }

  Future<void> checkLogin() async {
    print('userModelLogins --> ${controller.userModelLogins}');
    await controller.findUserModelLogins().then((value) =>
        print('userModelLogins last --> ${controller.userModelLogins}'));

    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event == null) {
        statusLogin = false;
      } else {
        statusLogin = true;
        controller.findUserModel(uid: event.uid);
      }

      load = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('current userModel ===> ${appController.userModelLogins}');
          return Scaffold(backgroundColor: AppConstant.bgColor,
            appBar: AppBar(
              title: WidgetText(
                text: titles[appController.indexBody.value],
                textStyle: AppConstant().h2Style(),
              ),
            ),
            drawer: load
                ? const WidgetProgress()
                : Drawer(
                    child: Column(
                      children: [
                        headDrawer(appController),
                        WidgetMenu(
                          leadWidget: const WidgetImage(
                            path: 'images/home.png',
                            size: 36,
                          ),
                          title: 'หน้าหลัก',
                          tapFunc: () {
                            appController.indexBody.value = 0;
                            Get.back();
                          },
                        ),
                        statusLogin!
                            ? appController.userModelLogins[0].typeUser ==
                                    AppConstant.typeUsers[1]
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      WidgetMenu(
                                        leadWidget: const WidgetImage(
                                          path: 'images/message.png',
                                          size: 36,
                                        ),
                                        title: 'ข่าวสาร',
                                        subTitle: const WidgetText(
                                            text: 'ข่าวสารสำหร้บ ช่าง'),
                                        tapFunc: () {
                                          appController.indexBody.value = 1;
                                          Get.back();
                                        },
                                      ),
                                      WidgetMenu(
                                        leadWidget: const WidgetImage(
                                          path: 'images/profile.png',
                                          size: 36,
                                        ),
                                        title: 'Profile',
                                        tapFunc: () {
                                          appController.indexBody.value = 2;
                                          Get.back();
                                        },
                                      ),
                                      WidgetMenu(
                                        leadWidget: const WidgetImage(
                                          path: 'images/referance.png',
                                          size: 36,
                                        ),
                                        title: 'Referance',
                                        tapFunc: () {
                                          appController.indexBody.value = 3;
                                          Get.back();
                                        },
                                      ),
                                    ],
                                  )
                                : WidgetMenu(
                                    leadWidget: const WidgetImage(
                                      path: 'images/message.png',
                                      size: 36,
                                    ),
                                    title: 'ข่าวสาร',
                                    subTitle: const WidgetText(
                                        text: 'ข่าวสารสำหร้บ สมาชิก'),
                                    tapFunc: () {
                                      appController.indexBody.value = 4;
                                      Get.back();
                                    },
                                  )
                            : const SizedBox(),
                        const Spacer(),
                        Divider(
                          color: AppConstant.dark,
                        ),
                        statusLogin! ? menuSignOut() : menuAuthen(),
                      ],
                    ),
                  ),
            body: bodys[appController.indexBody.value],
          );
        });
  }

  UserAccountsDrawerHeader headDrawer(AppController appController) {
    return UserAccountsDrawerHeader(
      decoration: AppConstant().imageBox(path: 'images/bg2.jpg', opacity: 0.5),
      accountName: appController.userModelLogins.isEmpty
          ? null
          : WidgetText(
              text: appController.userModelLogins[0].name,
              textStyle: AppConstant().h2Style(),
            ),
      accountEmail: appController.userModelLogins.isEmpty
          ? null
          : WidgetText(
              text: 'Type : ${appController.userModelLogins[0].typeUser}',
              textStyle: AppConstant().h3Style(fontWeight: FontWeight.w500),
            ),
      currentAccountPicture: const WidgetImage(),
    );
  }

  WidgetMenu menuSignOut() {
    return WidgetMenu(
        tapFunc: () {
          AppDialog(context: context).normalDialog(
              title: 'ยืนยัน SignOut',
              detail: 'กรุณา ยืนยัน การ SignOut',
              firstBotton: WidgetTextButton(
                label: 'ยืนยัน SignOut',
                pressFunc: () async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    checkLogin();
                    Get.back();
                    Get.back();
                  });
                },
              ),
              secondBotton: WidgetTextButton(
                label: 'Cancel',
                pressFunc: () {
                  Get.back();
                  Get.back();
                },
              ));
        },
        leadWidget: const Icon(
          Icons.exit_to_app,
          size: 36,
        ),
        title: 'Sign Out');
  }

  WidgetMenu menuAuthen() {
    return WidgetMenu(
        tapFunc: () {
          Get.back();
          Get.toNamed(AppConstant.pageAuthen)?.then((value) {
            checkLogin();
          });
        },
        leadWidget: const Icon(
          Icons.login,
          size: 36,
        ),
        title: 'ลงชื่อเข้าใช้งาน');
  }
}
