import 'package:flutter/material.dart';
import 'package:linker/UI/profile/profil_model.dart';
import 'package:linker/UI/profile/profile_model_view.dart';
import 'package:linker/core/user_model.dart';

class Profile extends StatefulWidget {
  static final UserModel currentuser = UserModel(
      userDocId: "onurvcn", email: "bilemem", pass: "pass", name: "name");

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    ProfileModelView.profilModel.getLinks();
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text("merkez"),
      ),
      floatingActionButton: ProfileModelView.floatActionButtonAdd(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileModelView.IdentityZone(
                height: deviceSize.height * 0.25, context: context),
            ProfileModelView.profileLinksZone(),
          ],
        ),
      ),
    );
  }
}
