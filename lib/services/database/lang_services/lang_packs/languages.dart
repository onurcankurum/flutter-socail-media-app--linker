import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

abstract class Languages {
  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

//-------------login screen------------------------

  String get nickName;

  String get password;

  String get personalName;
  String get register;

  String get login;

  String get loginScreen;
  String get registerScreen;
  //------loginScreen errors (sign in)
  String get noUserFoundForThatMail;

  String get wrongPassword;

  String get somethingWentWrong;

  String get thisNickDoesntExist;
  String get succesfullLogin;

  //------loginScreen errors (register))
  String get succesfullRegister;

  String get weakPassword;

  String get emailAlreadyInUser;

  //-----------login s screen inputFields
  String get thisNickBelgsSomeOneElse;

  String get nick;

  String get InvalisCharacters;
  String get passwordRules;
  String get invalidForNow;
  String get e_mail;
  String get thisNameNotRealName;
  String get typeNickName;
  // profile pages Strings
  String get editProfile;
  String get saveProfile;
  String get biography;
  // others profile -
  String get unfollow;
  String get startedFollowU;
  String get someOneFollowSomeone;
  String get follow;
  String get addSpecialGroup;
  String get doesNotFollowU;
  String get info;
  String get addCat;
  String get notifications;
  String get devleperContactInfo;

  //-------------login screen-------------------------

}
