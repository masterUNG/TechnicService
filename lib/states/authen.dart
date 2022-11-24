import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technicservice/states/choose_type.dart';
import 'package:technicservice/utility/app_controller.dart';
import 'package:technicservice/widgets/widget_button.dart';
import 'package:technicservice/widgets/widget_form.dart';
import 'package:technicservice/widgets/widget_icon_button.dart';
import 'package:technicservice/widgets/widget_logo.dart';
import 'package:technicservice/widgets/widget_text.dart';
import 'package:technicservice/widgets/widget_text_button.dart';

class Authen extends StatelessWidget {
  const Authen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GetX(
            init: AppController(),
            builder: (AppController appController) {
              return SafeArea(
                child: Stack(
                  children: [
                    ListView(
                      children: [
                        WidgetLogo(
                          sizeLogo: boxConstraints.maxWidth * 0.35,
                        ),
                        formEmail(),
                        formPassword(appController),
                        buttonLogin()
                      ],
                    ),
                    buttonCreateAccount(),
                    WidgetIconButton(
                      iconData: Icons.arrow_back,
                      pressFunc: () {
                        Get.back();
                      },
                    )
                  ],
                ),
              );
            });
      }),
    );
  }

  Column buttonCreateAccount() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const WidgetText(text: 'ยังไม่มีบัญชี ? '),
            WidgetTextButton(
              label: 'สมัครใช้งาน',
              pressFunc: () {
                Get.to(const ChooseType());
              },
            )
          ],
        ),
      ],
    );
  }

  Row buttonLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetButton(
          width: 250,
          label: 'Login',
          pressFunc: () {},
        ),
      ],
    );
  }

  Row formPassword(AppController appController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetForm(
          obscecu: appController.redEye.value,
          hint: 'Password :',
          changeFunc: (p0) {},
          suffixWidget: WidgetIconButton(
            iconData: appController.redEye.value
                ? Icons.remove_red_eye
                : Icons.remove_red_eye_outlined,
            pressFunc: () {
              appController.redEye.value = !appController.redEye.value;
            },
          ),
        ),
      ],
    );
  }

  Row formEmail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetForm(
          hint: 'Email :',
          changeFunc: (p0) {},
        ),
      ],
    );
  }
}
