import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String name;
  final String surName;
  final String address;
  final String phone;
  final String email;
  final String password;
  final String typeUser;
  final List<String>? skillTechnic;
  final GeoPoint geoPoint;
  final String? urlProfile;
  final String? token;

  UserModel({
    required this.name,
    required this.surName,
    required this.address,
    required this.phone,
    required this.email,
    required this.password,
    required this.typeUser,
    this.skillTechnic,
    required this.geoPoint,
    this.urlProfile,
    this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'surName': surName,
      'address': address,
      'phone': phone,
      'email': email,
      'password': password,
      'typeUser': typeUser,
      'skillTechnic': skillTechnic,
      'geoPoint': geoPoint,
      'urlProfile': urlProfile,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: (map['name'] ?? '') as String,
      surName: (map['surName'] ?? '') as String,
      address: (map['address'] ?? '') as String,
      phone: (map['phone'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      password: (map['password'] ?? '') as String,
      typeUser: (map['typeUser'] ?? '') as String,
      skillTechnic: List<String>.from(map['skillTechnic'] ?? []),
      geoPoint: (map['geoPoint'] ?? const GeoPoint(0, 0)),
      urlProfile: map['urlProfile'] ?? '',
      token: map['token'] ?? '',
    );
  }

  //skillTechnic: List<String>.from(map['skillTechnic'] ?? []),
  //geoPoint: (map['geoPoint'] ?? const GeoPoint(0, 0)),
  //urlProfile: map['urlProfile'] ?? '',
  //token: map['token'] ?? '',

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
