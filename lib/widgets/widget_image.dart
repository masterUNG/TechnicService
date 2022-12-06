// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetImage extends StatelessWidget {
  const WidgetImage({
    Key? key,
    this.size,
    this.path,
  }) : super(key: key);

  final double? size;
  final String? path;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path ?? 'images/logo.png',
      width: size,
    );
  }
}
