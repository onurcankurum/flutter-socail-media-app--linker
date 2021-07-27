import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userDocId;
  String name;
  String? bio;
  String email;
  final String pass;
  late List<String> closeUsers;

  UserModel(
      {required this.userDocId,
      required this.email,
      required this.pass,
      required this.name,
      this.bio});

  factory UserModel.fromJson(Map<String, dynamic> json, String docId) {
    return UserModel(
        name: json['name'],
        userDocId: json['nick'],
        pass: json['pass'],
        bio: json['bio'],
        email: json['email']);
  }
}
