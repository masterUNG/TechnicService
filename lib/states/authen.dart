import 'package:flutter/material.dart';
import 'package:technicservice/widgets/widget_form.dart';
import 'package:technicservice/widgets/widget_icon_button.dart';
import 'package:technicservice/widgets/widget_image.dart';
import 'package:technicservice/widgets/widget_logo.dart';

class Authen extends StatelessWidget {
  const Authen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return ListView(
          children: [
            WidgetLogo(
              sizeLogo: boxConstraints.maxWidth * 0.35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WidgetForm(
                  hint: 'Email :',
                  changeFunc: (p0) {},
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WidgetForm(
                  hint: 'Password :',
                  changeFunc: (p0) {},
                  suffixWidget: WidgetIconButton(
                    iconData: Icons.remove_red_eye,
                    pressFunc: () {},
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
