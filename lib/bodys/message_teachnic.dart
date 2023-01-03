import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technicservice/utility/app_constant.dart';
import 'package:technicservice/utility/app_controller.dart';
import 'package:technicservice/widgets/widget_menu.dart';
import 'package:technicservice/widgets/widget_text.dart';

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
          print(
              '##3jan readDocIdCahtUserTechnic ==> ${appController.docIdChatUserTechnics}');
          return appController.nameUserOrTechnics.isEmpty
              ? const SizedBox()
              : ListView.builder(
                  itemCount: appController.chatModelUserTechnic.length,
                  itemBuilder: (context, index) => WidgetMenu(
                      leadWidget: const Icon(Icons.message),
                      title: appController.nameUserOrTechnics[index], subTitle: WidgetText(text: 'Last Message'),),
                );
        });
  }
}
