// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technicservice/utility/app_constant.dart';
import 'package:technicservice/widgets/widget_image.dart';
import 'package:technicservice/widgets/widget_text.dart';
import 'package:technicservice/widgets/widget_text_button.dart';

class AppDialog {
  final BuildContext context;
  AppDialog({
    required this.context,
  });

  void materialDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(title: WidgetText(text: 'Materialdialog'),),
    );
  }

  void normalDialog({
    required String title,
    required String detail,
    Widget? iconWidget,
    Widget? firstBotton,
    Widget? secondBotton,
  }) {
    Get.dialog(
      AlertDialog(
        icon: Center(
          child: iconWidget ??
              const WidgetImage(
                size: 100,
              ),
        ),
        title: WidgetText(
          text: title,
          textStyle: AppConstant().h2Style(),
        ),
        content: WidgetText(text: detail),
        actions: [
          firstBotton ?? const SizedBox(),
          secondBotton ??
              WidgetTextButton(
                label: firstBotton == null ? 'OK' : 'Cancel',
                pressFunc: () {
                  Get.back();
                },
              )
        ],
      ),
    );
  }
}
