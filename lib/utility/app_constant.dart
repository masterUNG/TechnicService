import 'package:flutter/material.dart';

class AppConstant {
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


  static Color dark = Colors.black;
  static Color bgColor = Colors.white;

  TextStyle h1Style({Color? color}) {
    return TextStyle(
      fontSize: 36,
      color: color ?? dark,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle h2Style({Color? color}) {
    return TextStyle(
      fontSize: 20,
      color: color ?? dark,
      fontWeight: FontWeight.w700,
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
