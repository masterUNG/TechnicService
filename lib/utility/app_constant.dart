import 'package:flutter/material.dart';

class AppConstant {

  static String urlFreeProfile = 'https://firebasestorage.googleapis.com/v0/b/teachnicservice.appspot.com/o/profile%2F3605332_construction_engineer_hard_hat_helmet_icon.png?alt=media&token=18de348d-309c-4ed1-a003-bd6d9a70342e';

  static var typeUsers = <String>[
    'user',
    'teachnic',
  ];
  static var typeUserShows = <String>[
    'สมาชิกทั่วไป',
    'ช่างเทคนิก',
  ];

  static String pageAuthen = '/authen';
  static String pageAccountUser = '/accountUser';
  static String pageAccountTeachnic = '/accountTeachnic';
  static String pageMainHome = '/mainHome';

  static Color dark = Colors.black;
  static Color bgColor = Colors.white;
  static Color cardColor = Color.fromARGB(255, 231, 235, 170);

  BoxDecoration borderCurveBox() {
    return BoxDecoration(
        border: Border.all(), borderRadius: BorderRadius.circular(10));
  }

  BoxDecoration curveBox() {
    return BoxDecoration(
      color: bgColor,
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(60), topRight: Radius.circular(60)),
    );
  }

  BoxDecoration imageBox({required String path, double? opacity}) {
    return BoxDecoration(
      image: DecorationImage(
        opacity: opacity ?? 1,
        image: AssetImage(path),
        fit: BoxFit.cover,
      ),
    );
  }

  TextStyle h1Style({Color? color}) {
    return TextStyle(
      fontSize: 36,
      color: color ?? dark,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle h2Style({Color? color, FontWeight? fontWeight, double? size}) {
    return TextStyle(
      fontSize: size ?? 20,
      color: color ?? dark,
      fontWeight: fontWeight ?? FontWeight.w700,
    );
  }

  TextStyle h3Style({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 14,
      color: color ?? dark,
      fontWeight: fontWeight ?? FontWeight.normal,
    );
  }
}
