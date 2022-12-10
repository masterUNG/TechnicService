// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ReferanceModel {
  final String urlJob;
  final String nameJob;
  final String detail;
  final String uidTechnic;
  final Timestamp timestampJob;
  ReferanceModel({
    required this.urlJob,
    required this.nameJob,
    required this.detail,
    required this.uidTechnic,
    required this.timestampJob,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'urlJob': urlJob,
      'nameJob': nameJob,
      'detail': detail,
      'uidTechnic': uidTechnic,
      'timestampJob': timestampJob,
    };
  }

  factory ReferanceModel.fromMap(Map<String, dynamic> map) {
    return ReferanceModel(
      urlJob: (map['urlJob'] ?? '') as String,
      nameJob: (map['nameJob'] ?? '') as String,
      detail: (map['detail'] ?? '') as String,
      uidTechnic: (map['uidTechnic'] ?? '') as String,
      timestampJob: (map['timestampJob']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReferanceModel.fromJson(String source) => ReferanceModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
