import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatModel {
  final List<String> friends;
  ChatModel({
    required this.friends,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'friends': friends,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      friends: List<String>.from(map['friends'] ?? const []) ,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) => ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
