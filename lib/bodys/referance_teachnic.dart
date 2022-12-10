import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technicservice/states/app_referance.dart';
import 'package:technicservice/utility/app_controller.dart';
import 'package:technicservice/widgets/widget_button.dart';
import 'package:technicservice/widgets/widget_false_page.dart';
import 'package:technicservice/widgets/widget_progress.dart';
import 'package:technicservice/widgets/widget_text.dart';

class ReferanceTeachnic extends StatefulWidget {
  const ReferanceTeachnic({super.key});

  @override
  State<ReferanceTeachnic> createState() => _ReferanceTeachnicState();
}

class _ReferanceTeachnicState extends State<ReferanceTeachnic> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
      return GetX(
          init: AppController(),
          builder: (AppController appController) {
            print(
                '##8dec referanceModels --> ${appController.referanceModels}');
            print('##8dec loadReferance--> ${appController.loadRecerance}');
            return SizedBox(
              width: boxConstraints.maxWidth,
              height: boxConstraints.maxHeight,
              child: Stack(
                children: [
                  appController.loadRecerance.value
                      ? const WidgetProgress()
                      : appController.referanceModels.isEmpty
                          ? const WidgetFalsePage(label: 'No Referance')
                          : WidgetText(text: 'have referance'),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: WidgetButton(
                      label: 'Add Referance',
                      pressFunc: () {
                        Get.to(const AddReferance());
                      },
                    ),
                  )
                ],
              ),
            );
          });
    });
  }
}
