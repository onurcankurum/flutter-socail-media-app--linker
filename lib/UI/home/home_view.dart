import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linker/UI/profile/profile_model_view.dart';
import 'package:linker/core/user_model.dart';
import 'package:linker/main.dart';
import 'package:linker/services/database/database_operations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'home_model.dart';
import 'home_model_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearch = false;
  final String assetName = 'assets/ali.svg';
  @override
  List<Widget> followingList = [];
  void initState() {
    super.initState();
  }

  setstate() {
    setState(() {});
  }

  double animeWidth = 1;

  final HomeModelView homeModelViews = HomeModelView();

  Future<void> adsf() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // ignore: unused_local_variable
    String? token = await messaging.getToken(
      vapidKey: "BGpdLRs......",
    );

    DatabaseOperations.setToken(HomeModelView.getCurrent(), token);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    double appBarheight = AppBar().preferredSize.height;
    adsf();

    return FutureBuilder(
      future: HomeModelView.getCurrent(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        return Scaffold(
            floatingActionButton: !HomeModelView.isSearch
                ? HomeModelView.floatActionButtons(
                    profil: HomeModelView.FloatButtonNotification(context),
                    notifications: HomeModelView.FloatButtonProfile(context),
                  )
                : null,
            body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              homeModelViews.getAnimatedAppbar(
                  deviceSize, appBarheight, setstate),
              !HomeModelView.isSearch
                  ? HomeModelView.users(deviceSize.height, appBarheight)
                  : Container(
                      height: deviceSize.height - appBarheight,
                      child: FutureBuilder(
                          future: DatabaseOperations.searchUser(
                              HomeModelView.myController.text),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<String>> results) {
                            if (results.hasData) {
                              return ListView.builder(
                                  padding: EdgeInsets.all(40),
                                  shrinkWrap: true,
                                  itemCount: results.data!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return HomeModelView.searchResultCard(
                                        results.data![index]);
                                  });
                            } else {
                              return Text("arıyorum");
                            }
                          }),
                    ),
            ]));
      },
    );
  }
}
