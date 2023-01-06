// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CheckPaymentModel {
  final String uidPayment;
  final String urlSlip;
  final Timestamp timestamp;
  final bool approve;
  CheckPaymentModel({
    required this.uidPayment,
    required this.urlSlip,
    required this.timestamp,
    required this.approve,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uidPayment': uidPayment,
      'urlSlip': urlSlip,
      'timestamp': timestamp,
      'approve': approve,
    };
  }

  factory CheckPaymentModel.fromMap(Map<String, dynamic> map) {
    return CheckPaymentModel(
      uidPayment: (map['uidPayment'] ?? '') as String,
      urlSlip: (map['urlSlip'] ?? '') as String,
      timestamp: (map['timestamp']),
      approve: (map['approve'] ?? false) as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckPaymentModel.fromJson(String source) => CheckPaymentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
