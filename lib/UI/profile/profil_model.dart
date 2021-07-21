import 'dart:async';
import 'dart:core';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:linker/UI/profile/profile_view.dart';
import 'package:linker/UI/profile/profile_model_view.dart';
import 'package:linker/core/link_model.dart';
import 'package:linker/services/database/database_operations.dart';
import 'package:mobx/mobx.dart';

part 'profil_model.g.dart';

// This is the class used by rest of your codebase
class ProfilModel = _ProfilModel with _$ProfilModel;

abstract class _ProfilModel with Store {
  static final ref = FirebaseStorage.instance
      .ref()
      .child('users/${Profile.currentuser.userDocId}.png');
  @observable
  String imageUrl = "https://image.flaticon.com/icons/png/512/1077/1077012.png";
  @observable
  String bio = "";
  @observable
  List<LinkModel> links = [];
  @action
  Future<void> getImage() async {
    print(ref);
    try {
      imageUrl = await ref.getDownloadURL();
    } on Error {
      print("profil resmi yüklenmedi");
    }
  }

  Future<void> myBio() async {
    bio = await DatabaseOperations.getBio(Profile.currentuser);
  }

  Future<void> getLinks() async {
    links = await DatabaseOperations.getLinksFull(Profile.currentuser);
  }
}
