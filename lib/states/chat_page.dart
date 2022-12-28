// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:technicservice/models/user_model.dart';
import 'package:technicservice/utility/app_constant.dart';
import 'package:technicservice/utility/app_controller.dart';
import 'package:technicservice/utility/app_dialog.dart';
import 'package:technicservice/utility/app_service.dart';
import 'package:technicservice/widgets/widget_button.dart';
import 'package:technicservice/widgets/widget_form.dart';
import 'package:technicservice/widgets/widget_text.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.userModelTechnic,
  }) : super(key: key);

  final UserModel userModelTechnic;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  UserModel? userModelTeachnic;
  TextEditingController textEditingController = TextEditingController();

  AppController controller = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    userModelTeachnic = widget.userModelTechnic;
    processReadChat();
  }

  Future<void> processReadChat() async {
    await AppService()
        .findDocIdUserWhereEmail(email: userModelTeachnic!.email)
        .then((value) {
      String uidTechnic = value.last;
      print('##28dec uidTechnic ---> $uidTechnic');

      controller.findDocIdChats(
          uidLogin: controller.uidLogins.last, uidFriend: uidTechnic);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(
        title: WidgetText(
          text: AppService().cutWord(word: userModelTeachnic!.name, length: 20),
          textStyle: AppConstant().h2Style(),
        ),
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GetX(
            init: AppController(),
            builder: (AppController appController) {
              print('##28dec docIdChats --> ${appController.docIdChats}');
              return SizedBox(
                width: boxConstraints.maxWidth,
                height: boxConstraints.maxHeight,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () =>
                      FocusScope.of(context).requestFocus(FocusScopeNode()),
                  child: Stack(
                    children: [
                      contentForm(
                          boxConstraints: boxConstraints,
                          appController: appController),
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }

  Widget contentForm(
      {required BoxConstraints boxConstraints,
      required AppController appController}) {
    return Positioned(
      bottom: 0,
      child: SizedBox(
        width: boxConstraints.maxWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            WidgetForm(
              marginTop: 0,
              hint: 'ข้อความ',
              changeFunc: (p0) {},
              textEditingController: textEditingController,
            ),
            WidgetButton(
              label: 'ส่งข้อความ',
              pressFunc: () {
                if (textEditingController.text.isEmpty) {
                  AppDialog(context: context).normalDialog(
                      title: 'ยังไม่มี ข้อความ',
                      detail: 'กรุณากรอก ข้อความด้วย คะ');
                } else {
                  if (appController.userModelLogins.last.typeUser == AppConstant.typeUsers[0]) {
                    //for user
                  } else {
                    //for Technic
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
