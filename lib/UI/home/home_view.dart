import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linker/UI/others_profile/others_profile_model_view.dart';
import 'package:linker/UI/profile/profile_model_view.dart';
import 'package:linker/core/link_model.dart';
import 'package:linker/core/user_model.dart';
import 'package:linker/main.dart';
import 'package:linker/services/database/database_operations.dart';
import 'package:linker/services/database/lang_services/language_constants.dart';
import 'package:linker/services/database/lang_services/languages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'home_model.dart';
import 'home_model_view.dart';
import 'package:linker/services/database/lang_services/language_constants.dart'
    as lc;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isTurkish = true;
  bool isSearch = false;
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
    double appBarheight = AppBar().preferredSize.height + 20;
    adsf();

    return FutureBuilder(
      future: HomeModelView.getCurrent(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        return Scaffold(
            drawer: Drawer(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                      ),
                      child: Image(image: AssetImage('assets/linker.png'))),
                  FutureBuilder(
                    future: getLocale(),
                    builder:
                        (BuildContext contex, AsyncSnapshot<Locale> local) {
                      if (local.hasData) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Language.languageList().first.flag + "  ",
                              style: TextStyle(fontSize: 20),
                            ),
                            CupertinoSwitch(
                              activeColor: Colors.grey[300],
                              trackColor: Colors.grey[300],
                              value: "en" == local.data!.languageCode
                                  ? true
                                  : false,
                              onChanged: (_) async {
                                if ("tr" == local.data!.languageCode) {
                                  Locale _locale = await lc.setLocale(
                                      Language.languageList()
                                          .last
                                          .languageCode);
                                  MyApp.setLocale(context, _locale);
                                  isTurkish = false;
                                }
                                if ("en" == local.data!.languageCode) {
                                  Locale _locale = await lc.setLocale(
                                      Language.languageList()
                                          .first
                                          .languageCode);
                                  MyApp.setLocale(context, _locale);
                                  isTurkish = true;
                                }

                                setState(() {});
                              },
                            ),
                            Text(
                              "  " + Language.languageList().last.flag,
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  Container(
                      child: Column(
                    children: [
                      SizedBox(
                        height: 70,
                      ),
                      Text(
                        MyApp.lang.devleperContactInfo,
                        style: GoogleFonts.alice(
                            fontSize: 15,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      otherProfileModelView.linkItem(
                          LinkModel(
                              nick: "onurcan",
                              izinliler: [],
                              platform: "linker",
                              docId: "sa",
                              info:
                                  "diger iletişim bilgilerime linker dan ulaşabilirsiniz ;)"),
                          context,
                          deviceSize.width * 0.7,
                          deviceSize.height),
                      otherProfileModelView.linkItem(
                          LinkModel(
                              nick: "onurcankurum",
                              izinliler: [],
                              platform: "linkedin",
                              docId: "sa",
                              info:
                                  "bu uygulamanın geliştirilmesine destek olmak için veya özel teklifler için bana buradan ulaşabilirsiniz"),
                          context,
                          deviceSize.width * 0.7,
                          deviceSize.height)
                    ],
                  ))
                ],
              ),
            ),
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
