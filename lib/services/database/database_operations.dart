import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:linker/UI/profile/profile_view.dart';
import 'package:linker/core/link_model.dart';
import 'package:linker/core/user_model.dart';

class DatabaseOperations {
  static dynamic users = FirebaseFirestore.instance.collection('users');

  static Future<bool> isNickExist(String nick) async {
    final QuerySnapshot result =
        await users.where('nick', isEqualTo: nick).limit(1).get();

    final List<DocumentSnapshot> documents = result.docs;

    return documents.length == 1;
  }

  static Future insertUser(UserModel user) async {
    users.doc(user.userDocId).set({
      "name": user.name,
      "nick": user.userDocId,
      "pass": user.pass,
      "email": user.email
    }).then((value) {
      print("kullanıcı eklendi");
      return true;
    }).catchError((onError) {
      print("kullanıcı eklenemedi");
      return false;
    });
  }

  static Future createUserLinkDocs(UserModel user) async {
    await FirebaseFirestore.instance
        .collection('users/${user.userDocId}/links')
        .add({
      "platform": "mail",
      "nick": user.email,
      "izinliler": ["genel"]
    }).then((value) {
      print("link klasörü oluşturuldu");
      return true;
    }).catchError((onError) {
      print("link klasörü oluşturulmadı");
      return false;
    });
  }

  static Future createUserBiokDocs(UserModel user) async {
    await FirebaseFirestore.instance
        .collection('users/${user.userDocId}/profile')
        .doc('bio')
        .set({"bio": "rgdgdgdg"}).then((value) {
      print("link klasörü oluşturuldu");
      return true;
    }).catchError((onError) {
      print("link klasörü oluşturulmadı");
      return false;
    });
  }

  static Future createGroupsPath(UserModel userModel) async {
    await FirebaseFirestore.instance
        .collection('users/${userModel.userDocId}/topluluklar')
        .doc('groups')
        .set({
      "groups": ["genel"]
    }).then((value) {
      print("link klasörü oluşturuldu");
      return true;
    }).catchError((onError) {
      print("link klasörü oluşturulmadı");
      return false;
    });
  }

  static getUser(String inputNick) async {
    late String email;
    await users
        .doc(inputNick)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> querySnapshot) {
      email = querySnapshot.data()!['email'];
    });
    return email;
  }

  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static Future<String> getBio(UserModel userModel) async {
    String bio = "";
    await users
        .doc("${userModel.userDocId}/profile/bio")
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> querySnapshot) {
      bio = querySnapshot.data()!['bio'];
    });
    return bio;
  }

  static Future<List<LinkModel>> getLinksFull(UserModel userModel) async {
    List<LinkModel> items = [];
    await FirebaseFirestore.instance
        .collection('users/${Profile.currentuser.userDocId}/links')
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        items.add(LinkModel.fromJson(doc.data(), doc.id));
      });
    });
    return items;
  }

  static Future<void> deleteOneLink(LinkModel link) async {
    await FirebaseFirestore.instance
        .collection('users/${Profile.currentuser.userDocId}/links')
        .doc(link.docId)
        .delete()
        .then((val) {
      print("bi link vardı ya hani artık yok .(");
    });
  }

  static Future<dynamic> getAllGroups(UserModel userModel) async {
    dynamic items = [];
    await users
        .doc('${Profile.currentuser.userDocId}/topluluklar/groups')
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
      items = documentSnapshot.data()!['groups'];
      print("dfasfdfsa");
      print(items);
    });
    return items;
  }

  static Future<void> setNewLink(
      UserModel userModel, LinkModel linkModel) async {
    //''
    await FirebaseFirestore.instance
        .collection('users/${Profile.currentuser.userDocId}/links')
        .add(linkModel.toJson())
        .then((value) {
      print(value);
    });
  }

  static Future<void> setBio(UserModel userModel, String bio) async {
    await users
        .doc("${userModel.userDocId}/profile/bio")
        .set({"bio": bio}).then((val) {
      print("no problem");
    });
  }
}
