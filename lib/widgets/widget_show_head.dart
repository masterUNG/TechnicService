// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:technicservice/utility/app_constant.dart';
import 'package:technicservice/widgets/widget_text.dart';

class WidgetShowHead extends StatelessWidget {
  const WidgetShowHead({
    Key? key,
    required this.head,
  }) : super(key: key);

  final String head;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: WidgetText(
        text: head,
        textStyle: AppConstant().h2Style(),
      ),
    );
  }
}
