import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:technicservice/models/typetechnic_model.dart';
import 'package:technicservice/models/user_model.dart';
import 'package:technicservice/utility/app_constant.dart';
import 'package:technicservice/utility/app_dialog.dart';
import 'package:technicservice/utility/app_service.dart';
import 'package:technicservice/widgets/widget_button.dart';
import 'package:technicservice/widgets/widget_form.dart';
import 'package:technicservice/widgets/widget_google_map.dart';
import 'package:technicservice/widgets/widget_icon_button.dart';
import 'package:technicservice/widgets/widget_image.dart';
import 'package:technicservice/widgets/widget_menu.dart';
import 'package:technicservice/widgets/widget_progress.dart';
import 'package:technicservice/widgets/widget_text.dart';

class CreateAccountTeachnic extends StatefulWidget {
  const CreateAccountTeachnic({super.key});

  @override
  State<CreateAccountTeachnic> createState() => _CreateAccountTeachnicState();
}

class _CreateAccountTeachnicState extends State<CreateAccountTeachnic> {
  Position? position;
  var typeTeachnicModels = <TypeTechnicModel>[];
  var chooseTypeTechnics = <bool>[];

  String? name, surName, address, phone, email, password;

  @override
  void initState() {
    super.initState();
    findPosition();
    readAllTypeTechnic();
  }

  Future<void> readAllTypeTechnic() async {
    await FirebaseFirestore.instance
        .collection('typeteachnic')
        .get()
        .then((value) {
      for (var element in value.docs) {
        TypeTechnicModel model = TypeTechnicModel.fromMap(element.data());
        typeTeachnicModels.add(model);
        chooseTypeTechnics.add(false);
      }
      setState(() {});
    });
  }

  Future<void> findPosition() async {
    await AppService().processFindPosition(context: context).then((value) {
      position = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
          return Container(
            decoration:
                AppConstant().imageBox(path: 'images/bg1.jpg', opacity: 0.6),
            width: boxConstraints.maxWidth,
            height: boxConstraints.maxHeight,
            child: Stack(
              children: [
                WidgetMenu(
                    leadWidget: WidgetIconButton(
                      iconColor: AppConstant.dark,
                      iconData: Icons.arrow_back,
                      pressFunc: () {
                        Get.back();
                      },
                    ),
                    title: AppConstant.typeUserShows[1]),
                Positioned(
                  top: boxConstraints.maxWidth * 0.1,
                  right: boxConstraints.maxWidth * 0.1,
                  child: WidgetImage(
                    size: boxConstraints.maxWidth * 0.2,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 32, top: 32, right: 32),
                    decoration: AppConstant().curveBox(),
                    width: boxConstraints.maxWidth,
                    height: boxConstraints.maxHeight -
                        boxConstraints.maxWidth * 0.4,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          WidgetText(
                            text: 'ข้อมูลช่าง :',
                            textStyle: AppConstant().h2Style(),
                          ),
                          WidgetForm(
                            labelWidget: const WidgetText(text: 'ชื่อ'),
                            changeFunc: (p0) {
                              name = p0.trim();
                            },
                          ),
                          WidgetForm(
                            labelWidget: const WidgetText(text: 'นามสกุล'),
                            changeFunc: (p0) {
                              surName = p0.trim();
                            },
                          ),
                          WidgetForm(
                            labelWidget: const WidgetText(text: 'ที่อยู่'),
                            changeFunc: (p0) {
                              address = p0.trim();
                            },
                          ),
                          WidgetForm(
                            textInputType: TextInputType.phone,
                            labelWidget: const WidgetText(text: 'เบอร์โทรศัพย์'),
                            changeFunc: (p0) {
                              phone = p0.trim();
                            },
                          ),
                          WidgetForm(
                            textInputType: TextInputType.emailAddress,
                            labelWidget: const WidgetText(text: 'Email'),
                            changeFunc: (p0) {
                              email = p0.trim();
                            },
                          ),
                          WidgetForm(
                            labelWidget: const WidgetText(text: 'Password'),
                            changeFunc: (p0) {
                              password = p0.trim();
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 16),
                            child: WidgetText(
                              text: 'ชนิดของช่าง :',
                              textStyle: AppConstant().h2Style(),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: AppConstant().borderCurveBox(),
                            width: boxConstraints.maxWidth,
                            child: typeTeachnicModels.isEmpty
                                ? const WidgetProgress()
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemCount: typeTeachnicModels.length,
                                    itemBuilder: (context, index) {
                                      return CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        value: chooseTypeTechnics[index],
                                        onChanged: (value) {
                                          chooseTypeTechnics[index] = value!;
                                          setState(() {});
                                        },
                                        title: WidgetText(
                                            text: typeTeachnicModels[index].name),
                                      );
                                    },
                                  ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 16),
                            child: WidgetText(
                              text: 'พิกัด :',
                              textStyle: AppConstant().h2Style(),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: AppConstant().borderCurveBox(),
                            width: boxConstraints.maxWidth * 0.8,
                            height: boxConstraints.maxWidth * 0.6,
                            child: position == null
                                ? const WidgetProgress()
                                : WidgetGoogleMap(
                                    lat: position!.latitude,
                                    lng: position!.longitude),
                          ),
                          WidgetButton(
                            label: 'ยืนยัน',
                            pressFunc: () {
                              print('name = $name, surname = $surName');
                      
                                // AppDialog(context: context).materialDialog();
                      
                              if ((name?.isEmpty ?? true) ||
                                  (surName?.isEmpty ?? true) ||
                                  (address?.isEmpty ?? true) ||
                                  (phone?.isEmpty ?? true) ||
                                  (email?.isEmpty ?? true) ||
                                  (password?.isEmpty ?? true)) {
                                AppDialog(context: context).normalDialog(
                                    title: 'มีช่องว่าง ?',
                                    detail: 'กรุณากรอกให้ ครบทุกช่อง ครับ');
                               
                              } else if (AppService().checkChooseTypeTechnic(
                                  listChooses: chooseTypeTechnics)) {
                                AppDialog(context: context).normalDialog(
                                    title: 'ยังไม่ได้เลือก ชนิดช่าง',
                                    detail: 'กรุณาเลือก ชนิกของช่าง');
                              } else {
                                print(
                                    'chooseTypeTechnic ---> $chooseTypeTechnics');
                      
                                var skillTechnics = <String>[];
                      
                                for (var i = 0;
                                    i < chooseTypeTechnics.length;
                                    i++) {
                                  if (chooseTypeTechnics[i]) {
                                    skillTechnics.add(typeTeachnicModels[i].name);
                                  }
                                }
                                print('skillTechnics --> $skillTechnics');
                      
                                UserModel userModel = UserModel(
                                  name: name!,
                                  surName: surName!,
                                  address: address!,
                                  phone: phone!,
                                  email: email!,
                                  password: password!,
                                  typeUser: AppConstant.typeUsers[1],
                                  geoPoint: GeoPoint(
                                      position!.latitude, position!.longitude),
                                  skillTechnic: skillTechnics,
                                );
                      
                                AppService()
                                    .processCreateNewAccount(
                                        email: email!,
                                        password: password!,
                                        context: context,
                                        userModel: userModel)
                                    .then((value) {
                                 
                                });
                              }
                            }, // onpresss
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
