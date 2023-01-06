import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:technicservice/models/check_payment_model.dart';
import 'package:technicservice/utility/app_constant.dart';
import 'package:technicservice/utility/app_controller.dart';
import 'package:technicservice/utility/app_dialog.dart';
import 'package:technicservice/utility/app_service.dart';
import 'package:technicservice/widgets/widget_button.dart';
import 'package:technicservice/widgets/widget_icon_button.dart';
import 'package:technicservice/widgets/widget_image.dart';
import 'package:technicservice/widgets/widget_image_internet.dart';
import 'package:technicservice/widgets/widget_show_head.dart';
import 'package:technicservice/widgets/widget_text.dart';
import 'package:technicservice/widgets/widget_text_button.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(
        title: WidgetText(
          text: 'Payment Page',
          textStyle: AppConstant().h2Style(),
        ),
      ),
      body: GetX(
          init: AppController(),
          builder: (AppController appController) {
            print('##3jan file --> ${appController.files}');
            return ListView(
              children: [
                const WidgetShowHead(head: 'แนะนำวิธีการชำระเงิน'),
                articalHowto(),
                const WidgetShowHead(head: '1. ชำระเงินผ่าน พร้อมเพย์'),
                imageQRpromptpay(),
                buttonDownload(),
                const WidgetShowHead(head: '2. ชำระเงินผ่าน บัญชีธนาคาร'),
                aboutBank(),
                const WidgetShowHead(head: '3. แนบสลิป'),
                imageSlip(appController),
                buttonBottom(appController)
              ],
            );
          }),
    );
  }

  Widget buttonBottom(AppController appController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 250,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              WidgetButton(
                label: 'เลือกสลิป',
                pressFunc: () async {
                  if (appController.files.isNotEmpty) {
                    appController.files.clear();
                  }

                  File? file = await AppService()
                      .processTakePhoto(source: ImageSource.gallery);

                  appController.files.add(file!);
                },
              ),
              WidgetButton(
                label: 'แนบสลิป',
                pressFunc: () async {
                  if (appController.files.isEmpty) {
                    AppDialog(context: context).normalDialog(
                        title: 'รูปสลิป ?',
                        detail: 'ยังไม่ได้เลือกรูป สลิปเลย');
                  } else {
                    String path = 'slip/slip${Random().nextInt(1000000)}.jpg';

                    await AppService()
                        .processUploadImage(path: path)
                        .then((value) {
                      String urlSlip = value ?? AppConstant.urlFreeProfile;
                      print('##6jan urlSlip ---> $urlSlip');

                      CheckPaymentModel checkPaymentModel = CheckPaymentModel(
                          uidPayment: appController.uidLogins.last,
                          urlSlip: urlSlip,
                          timestamp: Timestamp.fromDate(DateTime.now()),
                          approve: false);

                      AppService()
                          .processInsertSlip(
                              checkPaymentModel: checkPaymentModel)
                          .then((value) {
                        AppDialog(context: context).normalDialog(
                          title: 'Upload Slip Success',
                          detail: 'กรุณารอการ ตรวจสอบ สลิป จาก Admin',
                          firstBotton: WidgetTextButton(
                            label: 'รับทราบ',
                            pressFunc: () {
                              Get.back();
                              Get.back();
                            },
                          ),secondBotton: const SizedBox()
                        );
                      });
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  SizedBox imageSlip(AppController appController) {
    return SizedBox(
      width: 250,
      height: 250,
      child: appController.files.isEmpty
          ? const WidgetImage(
              path: 'images/slip.png',
            )
          : Image.file(appController.files.last),
    );
  }

  Row articalHowto() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 300,
          child: WidgetText(
              text:
                  '     Lorem Ipsum คือ เนื้อหาจำลองแบบเรียบๆ \n ที่ใช้กันในธุรกิจงานพิมพ์หรืองานเรียงพิมพ์ \n มันได้กลายมาเป็นเนื้อหาจำลองมาตรฐานของธุรกิจดังกล่าวมาตั้งแต่ศตวรรษที่ 16 เมื่อเครื่องพิมพ์โนเนมเครื่องหนึ่งนำรางตัวพิมพ์มาสลับสับตำแหน่งตัวอักษรเพื่อทำหนังสือตัวอย่าง Lorem Ipsum อยู่ยงคงกระพันมาไม่ใช่แค่เพียงห้าศตวรรษ แต่อยู่มาจนถึงยุคที่พลิกโฉมเข้าสู่งานเรียงพิมพ์ด้วยวิธีทางอิเล็กทรอนิกส์ และยังคงสภาพเดิมไว้อย่างไม่มีการเปลี่ยนแปลง มันได้รับความนิยมมากขึ้นในยุค ค.ศ. 1960'),
        ),
      ],
    );
  }

  Row aboutBank() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 300,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: WidgetText(text: 'ธนาคาร:'),
                  ),
                  Expanded(
                    flex: 2,
                    child: WidgetText(text: 'กสิกร'),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: WidgetText(text: 'บัญชี:'),
                  ),
                  Expanded(
                    flex: 2,
                    child: WidgetText(text: 'มาสเตอร์ อึ่ง'),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: WidgetText(text: 'เลขที่:'),
                  ),
                  Expanded(
                    flex: 2,
                    child: WidgetText(
                      text: '0891112233454',
                      textStyle: AppConstant().h2Style(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        WidgetIconButton(
          iconData: Icons.copy,
          pressFunc: () {},
        )
      ],
    );
  }

  Row buttonDownload() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 250,
          child: WidgetButton(
            label: 'Download for Scan',
            pressFunc: () async {
              await Permission.storage.status.then((value) async {
                if (value.isDenied) {
                  await Permission.storage.request().then((value) {
                    print('##3jan -->Permission $value');
                  });
                } else {
                  print('##3jan Permission OK');
                  processSaveSlip();
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Container imageQRpromptpay() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WidgetImageInternet(
            urlPath: AppConstant.urlPromptPay,
            width: 250,
            height: 250,
          ),
        ],
      ),
    );
  }

  Future<void> processSaveSlip() async {
    var response = await Dio().get(
      AppConstant.urlPromptPay,
      options: Options(responseType: ResponseType.bytes),
    );

    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 80,
        name: 'masterUngPromptPay');

    if (result['isSuccess']) {
      AppDialog(context: context).normalDialog(
          title: 'Download Success',
          detail: 'กรุณาใช้ แอปธนาคาร ที่ท่านมี สแกนเพื่อชำระเงิน');
    } else {
      AppDialog(context: context)
          .normalDialog(title: 'Cannot Download', detail: 'Please Try Again');
    }
  }
}
