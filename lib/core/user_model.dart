import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userDocId;
  late final CollectionReference user;
  String name;
  String email;
  final String pass;
  late List<String> closeUsers;

  UserModel(
      {required this.userDocId,
      required this.email,
      required this.pass,
      required this.name});
  /*  Future<void> getemail() {
    print("sd");
  } */
}
