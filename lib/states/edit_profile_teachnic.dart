import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technicservice/utility/app_controller.dart';

class EditProfileTechnic extends StatefulWidget {
  const EditProfileTechnic({super.key});

  @override
  State<EditProfileTechnic> createState() => _EditProfileTechnicState();
}

class _EditProfileTechnicState extends State<EditProfileTechnic> {
  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('userModels --> ${appController.userModels}');
          return Scaffold(
            appBar: AppBar(),
          );
        });
  }
}
