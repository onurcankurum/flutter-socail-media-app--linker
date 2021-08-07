import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:linker/UI/home/home_model_view.dart';
import 'package:linker/UI/others_profile/others_profile_model_view.dart';
import 'package:linker/UI/profile/profile_view.dart';
import 'package:linker/core/user_model.dart';

class OthersProfileViews extends StatefulWidget {
  static String routeName = 'others-profile';
  OthersProfileViews({Key? key}) : super(key: key);

  @override
  _OthersProfileViewsState createState() => _OthersProfileViewsState();
}

class _OthersProfileViewsState extends State<OthersProfileViews> {
  void setstatte() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            otherProfileModelView.IdentityZone(
              setstate: setstatte,
              userModel: args.userModel,
              height: deviceSize.height * 0.25,
              width: deviceSize.width,
              context: context,
            ),
            otherProfileModelView.profileLinksZone(
              args.userModel,
              deviceSize.width,
              deviceSize.height,
            )
          ],
        ));
  }
}
