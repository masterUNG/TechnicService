import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technicservice/states/app_referance.dart';
import 'package:technicservice/utility/app_constant.dart';
import 'package:technicservice/utility/app_controller.dart';
import 'package:technicservice/utility/app_service.dart';
import 'package:technicservice/widgets/widget_button.dart';
import 'package:technicservice/widgets/widget_false_page.dart';
import 'package:technicservice/widgets/widget_image_internet.dart';
import 'package:technicservice/widgets/widget_progress.dart';
import 'package:technicservice/widgets/widget_text.dart';

class ReferanceTeachnic extends StatefulWidget {
  const ReferanceTeachnic({super.key});

  @override
  State<ReferanceTeachnic> createState() => _ReferanceTeachnicState();
}

class _ReferanceTeachnicState extends State<ReferanceTeachnic> {
  AppController controller = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    controller.readTechnicReferance();
  }

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
                          : listReferance(appController, boxConstraints),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: WidgetButton(
                      label: 'Add Referance',
                      pressFunc: () {
                        Get.to(const AddReferance())!.then((value) {
                          controller.readTechnicReferance();
                        });
                      },
                    ),
                  )
                ],
              ),
            );
          });
    });
  }

  ListView listReferance(AppController appController, BoxConstraints boxConstraints) {
    return ListView.builder(
                            itemCount: appController.referanceModels.length,
                            itemBuilder: (context, index) => Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      width: boxConstraints.maxWidth * 0.4,
                                      height: boxConstraints.maxWidth * 0.3,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        child: WidgetImageInternet(
                                            urlPath: appController
                                                .referanceModels[index]
                                                .urlJob),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      width: boxConstraints.maxWidth * 0.6,
                                      height: boxConstraints.maxWidth * 0.3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          WidgetText(
                                            text: AppService().cutWord(word: appController
                                                .referanceModels[index]
                                                .nameJob, length: 25),
                                            textStyle: AppConstant().h3Style(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          WidgetText(
                                              text: AppService().cutWord(
                                                  word: appController
                                                      .referanceModels[index]
                                                      .detail,
                                                  length: 80)),
                                          const Spacer(),
                                          WidgetText(
                                            text: AppService()
                                                .dateTimeToString(
                                                    dateTime: appController
                                                        .referanceModels[
                                                            index]
                                                        .timestampJob
                                                        .toDate()),
                                            textStyle: AppConstant().h3Style(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: AppConstant.dark,
                                  thickness: 1,
                                ),
                              ],
                            ),
                          );
  } // end List


  
}
