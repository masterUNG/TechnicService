// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:technicservice/utility/app_constant.dart';
import 'package:technicservice/widgets/widget_text.dart';

class WidgetMenu extends StatelessWidget {
  const WidgetMenu({
    Key? key,
    required this.leadWidget,
    required this.title,
    this.tapFunc,
    this.subTitle,
  }) : super(key: key);

  final Widget leadWidget;
  final String title;
  final Function()? tapFunc;
  final Widget? subTitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: tapFunc,
      leading: leadWidget,
      title: WidgetText(
        text: title,
        textStyle: AppConstant().h2Style(),
      ),
      subtitle: subTitle,
    );
  }
}
