import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technicservice/models/chat_model.dart';
import 'package:technicservice/states/chat_page.dart';
import 'package:technicservice/utility/app_controller.dart';
import 'package:technicservice/widgets/widget_menu.dart';
import 'package:technicservice/widgets/widget_text.dart';

class MessageUser extends StatefulWidget {
  const MessageUser({super.key});

  @override
  State<MessageUser> createState() => _MessageUserState();
}

class _MessageUserState extends State<MessageUser> {
  AppController controller = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    controller.readChatModelForUser();
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('##30jan chatModles ---> ${appController.chatModels}');
          return (appController.chatModels.isEmpty) ||
                  (appController.nameFriends.isEmpty)
              ? const SizedBox()
              : ListView.builder(
                  itemCount: appController.chatModels.length,
                  itemBuilder: (context, index) => WidgetMenu(
                    leadWidget: Icon(Icons.chat),
                    title: appController.nameFriends[index],
                    tapFunc: () {
                      Get.to(ChatPage(
                          userModelTechnic:
                              appController.userModelTechnicForUsers[index]));
                    },
                  ),
                );
        });
  }
}
