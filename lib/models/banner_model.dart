// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  final String image;
  final String link;
  final Timestamp timeadd;
  BannerModel({
    required this.image,
    required this.link,
    required this.timeadd,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
      'link': link,
      'timeadd': timeadd,
    };
  }

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      image: (map['image'] ?? '') as String,
      link: (map['link'] ?? '') as String,
      timeadd: (map['timeadd']),
    );
  }

  String toJson() => json.encode(toMap());

  factory BannerModel.fromJson(String source) =>
      BannerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
