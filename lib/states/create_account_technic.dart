import 'package:flutter/material.dart';
import 'package:technicservice/utility/app_constant.dart';
import 'package:technicservice/widgets/widget_text.dart';

class CreateAccountTeachnic extends StatelessWidget {
  const CreateAccountTeachnic({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetText(
          text: AppConstant.typeUserShows[1],
          textStyle: AppConstant().h2Style(),
        ),
      ),
    );
  }
}
