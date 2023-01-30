// ignore_for_file: avoid_print

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technicservice/states/chat_page_technic.dart';
import 'package:technicservice/states/payment_page.dart';
import 'package:technicservice/utility/app_constant.dart';
import 'package:technicservice/utility/app_controller.dart';
import 'package:technicservice/utility/app_dialog.dart';
import 'package:technicservice/utility/app_service.dart';
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
                      print('##6jan docIdChats --> $docIdChats');

                      var money = appController.userModelLogins.last.money;

                      if (money == 0.0) {
                        dialogRequire(context);
                      } else if (docIdChats!.isEmpty) {
                        //ยังไม่่เคยคุยกับใครเลย
                        dialogPayMoney(context, money, appController, index);
                      } else {
                        //Check ว่า user เคยคุยด้วยไหม ?

                        String docIdChat =
                            appController.docIdChatUserTechnics.last;

                        if (appController.userModelLogins.last.docIdChats!
                            .contains(docIdChat)) {
                          print(
                              '##6jan Check ว่า user เคยคุยด้วยไหม เคยคุยกันแล้ว');

                          Get.to(ChatPageTechnic(
                            docIdChat: docIdChat,
                            nameUser: appController.nameUserOrTechnics[index],
                          ));
                        } else {
                          print(
                              '##6jan Check ว่า user เคยคุยด้วยไหม ไม่เคยคุยกัน');
                          dialogPayMoney(context, money, appController, index);
                        }
                      }
                    },
                  ),
                );
        });
  }

  void dialogPayMoney(BuildContext context, double? money,
      AppController appController, int index) {
    AppDialog(context: context).normalDialog(
        title: 'Require ตัดเงิน',
        detail:
            'ยอดเงินที่คุณมี $money บาท ในการคุยกับ ลูกค้่า ระบบจะตัดเงินออก 32.10 บาท',
        firstBotton: WidgetTextButton(
          label: 'ยินดี',
          pressFunc: () {
            AppService()
                .processPayMoneyForChat(
                    docIdChat: appController.docIdChatUserTechnics[index])
                .then((value) {
              Get.back();
            });
          },
        ));
  }

  void dialogRequire(BuildContext context) {
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
  }
}
