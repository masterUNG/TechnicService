import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TypeTechnicModel {
  final String name;
  TypeTechnicModel({
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }

  factory TypeTechnicModel.fromMap(Map<String, dynamic> map) {
    return TypeTechnicModel(
      name: (map['name'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TypeTechnicModel.fromJson(String source) => TypeTechnicModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
