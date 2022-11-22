import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technicservice/utility/app_constant.dart';
import 'package:technicservice/utility/app_controller.dart';
import 'package:technicservice/widgets/widget_button.dart';
import 'package:technicservice/widgets/widget_logo.dart';
import 'package:technicservice/widgets/widget_text.dart';

class ChooseType extends StatefulWidget {
  const ChooseType({super.key});

  @override
  State<ChooseType> createState() => _ChooseTypeState();
}

class _ChooseTypeState extends State<ChooseType> {
  var typeUsers = AppConstant.typeUsers;
  var typeUserShows = AppConstant.typeUserShows;
  var pages = <String>[
    AppConstant.pageAccountUser,
    AppConstant.pageAccountTeachnic,
  ];

  @override
  void initState() {
    super.initState();
    print('typeUserShows = $typeUserShows');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GetX(
            init: AppController(),
            builder: (AppController appController) {
              return Column(
                children: [
                  WidgetLogo(sizeLogo: boxConstraints.maxWidth * 0.35),
                  WidgetText(
                    text: 'ชนิดของผู้ใช้งาน :',
                    textStyle: AppConstant().h2Style(),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    width: 250,
                    child: Column(
                      children: [
                        RadioListTile(
                          value: 0,
                          groupValue: appController.indexTypeUser.value,
                          onChanged: (value) {
                            appController.indexTypeUser.value = value!;
                          },
                          title: WidgetText(text: typeUserShows[0]),
                        ),
                        RadioListTile(
                          value: 1,
                          groupValue: appController.indexTypeUser.value,
                          onChanged: (value) {
                            appController.indexTypeUser.value = value!;
                          },
                          title: WidgetText(text: typeUserShows[1]),
                        ),
                      ],
                    ),
                  ),
                  WidgetButton(
                    width: 100,
                    label: 'ยืนยัน',
                    pressFunc: () {
                      Get.toNamed(pages[appController.indexTypeUser.value]);
                    },
                  )
                ],
              );
            });
      }),
    );
  }
}
