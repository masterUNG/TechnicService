// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technicservice/models/message_model.dart';

import 'package:technicservice/utility/app_constant.dart';
import 'package:technicservice/utility/app_controller.dart';
import 'package:technicservice/utility/app_dialog.dart';
import 'package:technicservice/utility/app_service.dart';
import 'package:technicservice/widgets/widget_button.dart';
import 'package:technicservice/widgets/widget_form.dart';
import 'package:technicservice/widgets/widget_text.dart';

class ChatPageTechnic extends StatefulWidget {
  const ChatPageTechnic({
    Key? key,
    required this.docIdChat,
    required this.nameUser,
  }) : super(key: key);

  final String docIdChat;
  final String nameUser;

  @override
  State<ChatPageTechnic> createState() => _ChatPageTechnicState();
}

class _ChatPageTechnicState extends State<ChatPageTechnic> {
  AppController controller = Get.put(AppController());
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.docIdChats.add(widget.docIdChat);
    controller.readMessageModels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetText(
          text: widget.nameUser,
          textStyle: AppConstant().h2Style(),
        ),
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GetX(
            init: AppController(),
            builder: (AppController appController) {
              print('##7jan docIdChat --> ${appController.docIdChats}');
              print(
                  '##7jan messageModels ---> ${appController.messageModels.length}');
              return appController.messageModels.isEmpty
                  ? const SizedBox()
                  : SizedBox(
                      width: boxConstraints.maxWidth,
                      height: boxConstraints.maxHeight,
                      child: Stack(
                        children: [
                          SizedBox(
                            height: boxConstraints.maxHeight - 60,
                            child: listMessageChat(appController),
                          ),
                          Positioned(
                            bottom: 0,
                            child: SizedBox(
                              width: boxConstraints.maxWidth,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  WidgetForm(
                                    textEditingController:
                                        textEditingController,
                                    hint: 'ข้อความ',
                                    marginTop: 0,
                                    changeFunc: (p0) {},
                                  ),
                                  WidgetButton(
                                    label: 'ส่งข้อความ',
                                    pressFunc: () {
                                      print(
                                          '##7jan text --> ${textEditingController.text}');

                                      if (textEditingController.text.isEmpty) {
                                        AppDialog(context: context)
                                            .normalDialog(
                                                title: 'ไม่มีข้อความ',
                                                detail: 'กรุณากรอกข้อความด้วย');
                                      } else {
                                        MessageModel messageModel =
                                            MessageModel(
                                                message:
                                                    textEditingController.text,
                                                uidPost: appController
                                                    .uidLogins.last,
                                                timestamp: Timestamp.fromDate(
                                                    DateTime.now()));

                                        AppService()
                                            .insertMessage(
                                                messageModel: messageModel)
                                            .then((value) {
                                          textEditingController.text = '';
                                        });
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
            });
      }),
    );
  }

  ListView listMessageChat(AppController appController) {
    return ListView.builder(
      itemCount: appController.messageModels.length,
      itemBuilder: (context, index) => Row(
        mainAxisAlignment: appController.uidLogins.last ==
                appController.messageModels[index].uidPost
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: AppConstant().chatLiftBox(context: context),
            child: Column(
              children: [
                WidgetText(text: appController.messageModels[index].message),
                WidgetText(
                  text: AppService().dateTimeToString(
                      dateTime:
                          appController.messageModels[index].timestamp.toDate(),
                      format: 'dd/MM/yy HH:mm'),
                  textStyle: AppConstant()
                      .h3Style(size: 10, color: AppConstant.chatColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
