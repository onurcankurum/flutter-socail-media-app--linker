import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linker/UI/profile/profil_model.dart';
import 'package:linker/UI/profile/profile_model_view.dart';
import 'package:linker/core/user_model.dart';
import 'package:linker/services/database/auth.dart';
import 'package:linker/services/database/database_operations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class Profile extends StatefulWidget {
  static final UserModel currentuser =
      UserModel(userDocId: "", email: "bilemem", pass: "pass", name: "name");

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> getCurrent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String id = "";
    id = (prefs.getString('nick')!);
    MyApp.currentuser.userDocId = id;

    UserModel(userDocId: id, email: "bilemem", pass: "pass", name: "name");
    print(MyApp.currentuser.userDocId);
  }

  void yenile() {
    setState(() {
      print("state yenilendi");
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getCurrent(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          print("fututreBuilderdayim");
          return Scaffold(
            appBar: AppBar(
                toolbarHeight: 50,
                title: Text(MyApp.currentuser.userDocId),
                actions: [
                  InkWell(
                    onTap: () async {
                      try {
                        Navigator.pop(context);
                        await FirebaseAuth.instance.signOut();
                      } on Error {
                        print('hata bölgesi');
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('çıkış başarılıbaşarısız')));
                      }

                      ProfileModelView.profilModel.bio = "";
                      ProfileModelView.profilModel.imageUrl =
                          "https://image.flaticon.com/icons/png/512/1077/1077012.png";
                      ProfileModelView.profilModel.links = [];

/* 
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('çıkış başarılı'))); */
                    },
                    child: Icon(Icons.logout_outlined, color: Colors.red[400]),
                  ),
                ]),
            floatingActionButton:
                ProfileModelView.floatActionButtonAdd(context),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ProfileModelView.IdentityZone(
                      width: deviceSize.width,
                      height: deviceSize.height * 0.25,
                      context: context,
                      setstate: yenile),
                  ProfileModelView.profileLinksZone(
                      deviceSize.width, deviceSize.height),
                ],
              ),
            ),
          );
        });
  }
}
