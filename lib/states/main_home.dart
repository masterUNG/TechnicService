import 'package:flutter/material.dart';
import 'package:technicservice/utility/app_constant.dart';
import 'package:technicservice/widgets/widget_text.dart';

class MainHome extends StatelessWidget {
  const MainHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetText(
          text: 'Main Home',
          textStyle: AppConstant().h2Style(),
        ),
      ),
    );
  }
}
