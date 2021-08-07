import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:linker/UI/profile/profile_view.dart';
import 'package:linker/core/link_model.dart';
import 'package:linker/core/notification_model.dart';
import 'package:linker/core/user_model.dart';

import '../../main.dart';

class DatabaseOperations {
  static dynamic users = FirebaseFirestore.instance.collection('users');

  static Future<bool> isNickExist(String nick) async {
    final QuerySnapshot result =
        await users.where('nick', isEqualTo: nick).limit(1).get();

    final List<DocumentSnapshot> documents = result.docs;

    return documents.length == 1;
  }

  static Future<String> getImage(String id) async {
    String imageUrl = await FirebaseStorage.instance
        .ref()
        .child('users/${id}.png')
        .getDownloadURL()
        .onError((error, stackTrace) async {
      print(await error);
      return 'https://i.pinimg.com/474x/d5/f3/dd/d5f3dd9c7b7939da57995d505fca511f.jpg';
    });
    return imageUrl;
  }

  static Future<List<String>> searchUser(String searchKey) async {
    List<String>? searchResults = [];
    final QuerySnapshot result = await users
        .where('nick', isGreaterThanOrEqualTo: searchKey)
        .where('nick', isLessThan: searchKey + 'z')
        .limit(10)
        .get();
    result.docs.forEach((doc) => searchResults.add(doc.id));
    print(searchResults);
    return searchResults;
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

  static Future setToken(Future<UserModel> userF, String? token) async {
    UserModel user = await userF;

    users.doc(user.userDocId).update({
      "token": token,
    }).then((value) {
      print("token yenilendi");
      return true;
    }).catchError((onError) {
      print("token yenilendi");
      return false;
    });
  }

  static Future createUserLinkDocs(UserModel user) async {
    await FirebaseFirestore.instance
        .collection('users/${user.userDocId}/links')
        .add(
      {
        "platform": "mail",
        "nick": user.email,
        "izinliler": ["özel"],
        "info":
            "Bu linki sadece özel kategorisindeki takipçilerin görebilir. takipçilerine bu rolü vererek görmelerine izin verebilirsin"
      },
    ).then((value) {
      print("link klasörü oluşturuldu");
      return true;
    }).catchError((onError) {
      print("link klasörü oluşturulmadı");
      return false;
    });

    await FirebaseFirestore.instance
        .collection('users/${user.userDocId}/links')
        .add(
      {
        "platform": "linker",
        "nick": user.userDocId,
        "izinliler": ["herkes"],
        "info":
            "bu linki herkes görebilir. İstersen linki profil sayfandan sola kaydırarak silebilirsin. Herkes kategorisini seni takip etmeyen insanlar da görebilir"
      },
    ).then((value) {
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

  static Future createUserNotificationkDoc(
    UserModel user,
  ) async {
    await FirebaseFirestore.instance
        .collection('users/${user.userDocId}/notifications')
        .doc()
        .set({
      "notification": "linker' a hoş geldin",
      'onToch': "onurvcn"
    }).then((value) {
      print("link klasörü oluşturuldu");
      return true;
    }).catchError((onError) {
      print("link klasörü oluşturulmadı");
      return false;
    });
  }

  static Future createUserFollowersAndFollowingkDocs(UserModel user) async {
    await FirebaseFirestore.instance
        .collection('users/${user.userDocId}/following')
        .doc()
        .set({"nick": "Officiallinker"}).then((value) {
      print("link klasörü oluşturuldu");
      return true;
    }).catchError((onError) {
      print("link klasörü oluşturulmadı");
      return false;
    });
    await FirebaseFirestore.instance
        .collection('users/${user.userDocId}/followers')
        .doc()
        .set({
      "nick": "Officiallinker",
      "permissions": ["herkes"]
    }).then((value) {
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
      "groups": ["genel", "özel"]
    }).then((value) {
      print("link klasörü oluşturuldu");
      return true;
    }).catchError((onError) {
      print("link klasörü oluşturulmadı");
      return false;
    });
  }

  static Future<bool> isFollowing(UserModel me, UserModel it) async {
    bool returnVal = false;
    await FirebaseFirestore.instance
        .collection('users/${me.userDocId}/following')
        .where('nick', isEqualTo: it.userDocId)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      if (querySnapshot.docs.first.exists) {
        returnVal = true;
        return returnVal;
      } else {
        returnVal = false;
        return returnVal;
      }
    }).catchError((onError) {
      print(onError.toString());
      returnVal = false;
      return returnVal;
    });
    return returnVal;
  }

  static Future updateGroups(UserModel userModel, dynamic liste) async {
    await FirebaseFirestore.instance
        .collection('users/${userModel.userDocId}/topluluklar')
        .doc('groups')
        .set({"groups": liste}).then((value) {
      print("link klasörü oluşturuldu");
      return true;
    }).catchError((onError) {
      print("link klasörü oluşturulmadı");
      return false;
    });
  }

  static Future<UserModel?> getUser({required String inputNick}) async {
    UserModel? userModel;

    await users
        .doc(inputNick)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> querySnapshot) {
      userModel = UserModel.fromJson(querySnapshot.data()!, inputNick);
      print(querySnapshot.data()!.runtimeType);
    }).catchError((onError) {
      print(onError);
    });
    print("object");
    return userModel;
  }

  static Future<List<UserModel>> getUsers(
      {required List<String?> inputNicks}) async {
    List<UserModel> userModels = [];
    inputNicks.forEach((element) async {
      await users
          .doc(element)
          .get()
          .then((DocumentSnapshot<Map<String, dynamic>> querySnapshot) {
        userModels.add(UserModel.fromJson(querySnapshot.data()!, element!));
        print(querySnapshot.data()!.runtimeType);
      }).catchError((onError) {
        print(onError);
      });
      print("object");
    });

    return userModels;
  }

  static Future<String> nickToEmail(String inputNick) async {
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

  static Future<String> getFcm(String userDocId) async {
    String token = "";
    print("object");
    await users
        .doc("${userDocId}")
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> querySnapshot) {
      token = querySnapshot.data()!['token'];
    });
    return token;
  }

  static Future<List<LinkModel>> getLinksFull(UserModel userModel) async {
    List<LinkModel> items = [];
    await FirebaseFirestore.instance
        .collection('users/${MyApp.currentuser.userDocId}/links')
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        items.add(LinkModel.fromJson(doc.data(), doc.id));
      });
    });
    return items;
  }

  static Future<List<dynamic>> getPermissionMyFollower(
      UserModel userModel) async {
    List<dynamic> items = [];
    await FirebaseFirestore.instance
        .collection('users/${MyApp.currentuser.userDocId}/followers')
        .doc(userModel.userDocId)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> querySnapshot) {
      items = querySnapshot.data()!["permissions"];
    });
    return items;
  }

  static Future<void> setPermissionMyFollower(
      UserModel userModel, List<String> perms) async {
    List<dynamic> items = [];
    await FirebaseFirestore.instance
        .collection('users/${MyApp.currentuser.userDocId}/followers')
        .doc(userModel.userDocId)
        .update({"permissions": perms}).then((_) {});
  }

  static Future<List<LinkModel>> getLinksOthers(
      {required UserModel me, required UserModel it}) async {
    List<LinkModel> items = [];
    List<dynamic> accesGroups = ['herkes'];
    await FirebaseFirestore.instance
        .collection('users/${it.userDocId}/followers')
        .where('nick', isEqualTo: me.userDocId)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      accesGroups = querySnapshot.docs.first['permissions'];
      print(accesGroups);
    }).catchError((onError) {
      print(onError.toString());
    });
    accesGroups.add('herkes');
    await FirebaseFirestore.instance
        .collection('users/${it.userDocId}/links')
        .where('izinliler', arrayContainsAny: accesGroups)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        items.add(LinkModel.fromJson(doc.data(), doc.id));
      });
    });

    return items;
  }

  static Future<void> addFriend(
      {required UserModel me, required UserModel it}) async {
    List<dynamic> accesGroups = ['herkes'];

    await FirebaseFirestore.instance
        .collection('users/${it.userDocId}/followers')
        .doc(me.userDocId)
        .set({'nick': me.userDocId, 'permissions': accesGroups})
        .then((val) {})
        .catchError((onError) {
          print(onError.toString());
        });

    await FirebaseFirestore.instance
        .collection('users/${me.userDocId}/following')
        .doc(it.userDocId)
        .set({'nick': it.userDocId})
        .then((val) {})
        .catchError((onError) {
          print(onError.toString());
        });
  }

  static Future<void> unFollow(
      {required UserModel me, required UserModel it}) async {
    List<dynamic> accesGroups = ['herkes'];
    await FirebaseFirestore.instance
        .collection('users/${me.userDocId}/following')
        .where("nick", isEqualTo: it.userDocId)
        .get()
        .then((snapshot) async {
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }).catchError((onError) {
      print(onError.toString());
    });
    await FirebaseFirestore.instance
        .collection('users/${it.userDocId}/followers')
        .where("nick", isEqualTo: me.userDocId)
        .get()
        .then((snapshot) async {
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  static Future<List<String>> getAllFollowers({required UserModel it}) async {
    List<String> followersId = [];
    await FirebaseFirestore.instance
        .collection('users/${it.userDocId}/followers')
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      querySnapshot.docs.forEach((element) {
        followersId.add(element.data()["nick"]);
      });
    }).catchError((onError) {
      print(onError.toString());
    });
    return followersId;
  }

  static Future<List<String>> getAllFollowing({required UserModel me}) async {
    List<String> followersId = [];
    await FirebaseFirestore.instance
        .collection('users/${me.userDocId}/following')
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      querySnapshot.docs.forEach((element) {
        followersId.add(element.data()["nick"]);
      });
    }).catchError((onError) {
      print(onError.toString());
    });
    return followersId;
  }

  static Future<void> deleteOneLink(LinkModel link) async {
    await FirebaseFirestore.instance
        .collection('users/${MyApp.currentuser.userDocId}/links')
        .doc(link.docId)
        .delete()
        .then((val) {
      print("bi link vardı ya hani artık yok .(");
    });
  }

  static Future<dynamic> getAllGroups(UserModel userModel) async {
    dynamic items = [];
    await users
        .doc('${MyApp.currentuser.userDocId}/topluluklar/groups')
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
        .collection('users/${MyApp.currentuser.userDocId}/links')
        .add(linkModel.toJson())
        .then((value) {
      print(value);
    });
  }

  static Future<void> setNewNotification(
      String userNick, NotificationModel notificationModel) async {
    //''
    await FirebaseFirestore.instance
        .collection('users/${userNick}/notifications')
        .add(notificationModel.toJson())
        .then((value) {
      print(value);
    });
  }

  static Future<List<NotificationModel>> getNotifications(UserModel me) async {
    List<NotificationModel> items = [];
    await FirebaseFirestore.instance
        .collection('users/${me.userDocId}/notifications')
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      querySnapshot.docs.forEach((element) {
        items.add(NotificationModel.fromJson(element.data()));
      });
    });
    return items;
  }

  static Future<void> setBio(UserModel userModel, String bio) async {
    await users
        .doc("${userModel.userDocId}/profile/bio")
        .set({"bio": bio}).then((val) {
      print("no problem");
    });
  }
}
