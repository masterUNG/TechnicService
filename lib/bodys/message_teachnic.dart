import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technicservice/states/payment_page.dart';
import 'package:technicservice/utility/app_constant.dart';
import 'package:technicservice/utility/app_controller.dart';
import 'package:technicservice/utility/app_dialog.dart';
import 'package:technicservice/widgets/widget_menu.dart';
import 'package:technicservice/widgets/widget_text.dart';
import 'package:technicservice/widgets/widget_text_button.dart';

class MessageTeachnic extends StatefulWidget {
  const MessageTeachnic({super.key});

  @override
  State<MessageTeachnic> createState() => _MessageTeachnicState();
}

class _MessageTeachnicState extends State<MessageTeachnic> {
  AppController controller = Get.put(AppController());

  var nameUsers = <String>[];

  @override
  void initState() {
    super.initState();
    controller.readDocIdChatUserTechnics(uid: controller.uidLogins.last);
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('##3jan lastMessage ==> ${appController.lastMessages}');
          return (appController.nameUserOrTechnics.isEmpty) ||
                  (appController.lastMessages.isEmpty)
              ? const SizedBox()
              : ListView.builder(
                  itemCount: appController.chatModelUserTechnic.length,
                  itemBuilder: (context, index) => WidgetMenu(
                    leadWidget: const Icon(Icons.message),
                    title: appController.nameUserOrTechnics[index],
                    subTitle: WidgetText(text: appController.lastMessages.last),
                    tapFunc: () {
                      var docIdChats =
                          appController.userModelLogins.last.docIdChats;
                      print('##3jan docIdChats --> $docIdChats');

                      if (docIdChats!.isEmpty) {
                        AppDialog(context: context).normalDialog(
                          title: 'ยังไม่มีสิทธ์ Chat',
                          detail: 'กรุณา เปิดสิทธ์ เข้าใช้งาน',
                          firstBotton: WidgetTextButton(
                            label: 'เปิดสิทธ์ใช้งาน',
                            pressFunc: () {
                              Get.back();
                              Get.to(const PaymentPage());
                            },
                          ),
                        );
                      } else {}
                    },
                  ),
                );
        });
  }
}
