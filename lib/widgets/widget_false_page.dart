// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:technicservice/utility/app_constant.dart';

import 'package:technicservice/widgets/widget_image.dart';
import 'package:technicservice/widgets/widget_text.dart';

class WidgetFalsePage extends StatelessWidget {
  const WidgetFalsePage({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const WidgetImage(
            path: 'images/teachnic.png',
            size: 200,
          ),
          WidgetText(
            text: label,
            textStyle: AppConstant().h1Style(),
          )
        ],
      ),
    );
  }
}
