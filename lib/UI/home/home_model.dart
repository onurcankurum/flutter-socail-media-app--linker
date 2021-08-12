import 'dart:async';
import 'dart:core';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:linker/UI/home/home_model_view.dart';

import 'package:linker/core/user_model.dart';
import 'package:linker/services/database/database_operations.dart';
import 'package:mobx/mobx.dart';

import '../../main.dart';
import 'home_view.dart';

part 'home_model.g.dart';

// This is the class used by rest of your codebase
class HomeModel = _HomeModel with _$HomeModel;

abstract class _HomeModel with Store {
  List<String> userIds = [];
  List<UserModel> userModels = [];
  List<Widget> usermodelWidget = [];

  @observable
  List<UserModel> usermodelRelease = [];

  Future<void> updateUsers() async {
    if (MyApp.currentuser.userDocId == "") {
      await HomeModelView.getCurrent();
    }
    userIds = await DatabaseOperations.getAllFollowing(me: MyApp.currentuser);

    await DatabaseOperations.getUsers(inputNicks: userIds).then((val) async {
      await Future.delayed(Duration(seconds: 1));
      val.sort((a, b) {
        return a.userDocId.toLowerCase().compareTo(b.userDocId.toLowerCase());
      });
      usermodelRelease = val;
    });
    print(usermodelRelease.toString());
  }
}
