// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:technicservice/widgets/widget_image.dart';

class WidgetLogo extends StatelessWidget {
  const WidgetLogo({
    Key? key,
    required this.sizeLogo,
  }) : super(key: key);

  final double sizeLogo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 100, bottom: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WidgetImage(
            size: sizeLogo,
          ),
        ],
      ),
    );
  }
}
