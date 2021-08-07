import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linker/UI/home/home_model.dart';
import 'package:linker/UI/home/home_view.dart';
import 'package:linker/UI/notifications/notification_view.dart';

import 'package:linker/UI/others_profile/others_profile_views.dart';

import 'package:linker/core/user_model.dart';
import 'package:linker/services/database/database_operations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class HomeModelView {
  static Future<UserModel> getCurrent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String id = "";
    id = (prefs.getString('nick')!);
    MyApp.currentuser.userDocId = id;

    return UserModel(
        userDocId: id, email: "bilemem", pass: "pass", name: "name");
  }

  static final homeModel = HomeModel();
  static double animeWidth = 0;
  static TextEditingController myController = TextEditingController();
  static void _searchbarOpenAnime(Function setstate) {
    animeWidth = 700;
    setstate();
  }

  static void _searchbarCloseAnime(Function setstate) async {
    animeWidth = 1;
    setstate();
  }

  static Widget floatActionButtons(
      {required Widget profil, required Widget notifications}) {
    return Wrap(
      direction: Axis.horizontal, //
      children: [
        profil,
        notifications,
      ],
    );
  }

  static bool isSearch = false;

  Widget getAnimatedAppbar(
    Size deviceSize,
    double appBarheight,
    Function setsttate,
  ) {
    return Container(
      height: appBarheight,
      child: Stack(children: [
        Container(
            color: Colors.deepPurpleAccent, width: 700, height: appBarheight),
        Container(
          alignment: Alignment.centerRight,
          width: deviceSize.width,
          height: appBarheight,
          child: AnimatedContainer(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            curve: Curves.linear,
            width: animeWidth,
            height: appBarheight,
            duration: Duration(milliseconds: 400),
          ),
        ),
        AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: isSearch
              ? GestureDetector(
                  onTap: () {
                    isSearch = false;
                    _searchbarCloseAnime(setsttate);
                  },
                  child: Icon(Icons.arrow_back))
              : Icon(Icons.menu),
          title: isSearch
              ? TextFormField(
                  controller: HomeModelView.myController,
                  onChanged: (s) {
                    print(myController.text);
                    setsttate();
                  },
                  cursorWidth: 1.2,
                  cursorRadius: Radius.circular(10),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  cursorColor: Colors.white,
                  cursorHeight: appBarheight * 0.45,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'kullanıcı adı girin',
                    hintStyle: TextStyle(color: Colors.blueGrey[300]),
                  ))
              : Container(alignment: Alignment.topRight, child: Text("Linker")),
          actions: [
            GestureDetector(
              onTap: () {
                if (isSearch == false) {
                  isSearch = true;

                  _searchbarOpenAnime(setsttate);
                }
              },
              child: Icon(Icons.search),
            )
          ],
        ),
      ]),
    );
  }

  static Widget FloatButtonNotification(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        child: FloatingActionButton(
            heroTag: "btn2",
            backgroundColor: Colors.deepOrangeAccent,
            onPressed: () async {
              NotificationView.items =
                  await DatabaseOperations.getNotifications(MyApp.currentuser);
              Navigator.pushNamed(context, NotificationView.routeName);
            },
            child: Icon(
              Icons.notifications_active_outlined,
            )));
  }

  static Widget users(double deviceHeight, double appbarHeight) {
    homeModel.updateUsers();
    return Container(
      height: deviceHeight - appbarHeight,
      width: double.infinity,
      child: Observer(builder: (context) {
        return ListView.builder(
            itemCount: HomeModelView.homeModel.usermodelRelease.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pushNamed(context, OthersProfileViews.routeName,
                      arguments: ScreenArguments(
                          userModel:
                              HomeModelView.homeModel.usermodelRelease[index]));
                },
                child: Container(
                  child: HomeModelView.items(
                      HomeModelView.homeModel.usermodelRelease[index]),
                ),
              );
            });
      }),
    );
  }

  static Widget searchResultCard(String userDocId) {
    return FutureBuilder(
        future: DatabaseOperations.getUser(inputNick: userDocId),
        builder: (BuildContext context,
            AsyncSnapshot<UserModel?> snapshotUserModel) {
          if (snapshotUserModel.hasData) {
            return GestureDetector(
              onTap: () {
                print(userDocId + "  " + MyApp.currentuser.userDocId);
                if (userDocId == MyApp.currentuser.userDocId) {
                  Navigator.pushNamed(context, '/profile');
                } else {
                  Navigator.pushNamed(context, OthersProfileViews.routeName,
                      arguments:
                          ScreenArguments(userModel: snapshotUserModel.data!));
                }
              },
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 50,
                        width: double.infinity,
                        child: Row(children: [
                          FutureBuilder(
                              future: DatabaseOperations.getImage(
                                  snapshotUserModel.data!.userDocId),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshotImageUrl) {
                                if (snapshotImageUrl.hasData) {
                                  return CircleAvatar(
                                    foregroundImage:
                                        NetworkImage(snapshotImageUrl.data!),
                                  );
                                } else {
                                  return Text("image not found");
                                }
                              }),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 50,
                            width: 100,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    snapshotUserModel.data!.userDocId,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w900),
                                  ),
                                  Text(snapshotUserModel.data!.name)
                                ]),
                          ),
                        ])),
                    Divider()
                  ]),
            );
          } else {
            return Container(
              width: 100,
              height: 50,
            );
          }
        });
  }

  static Widget FloatButtonProfile(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        child: FloatingActionButton(
            heroTag: "btn1",
            backgroundColor: Colors.deepPurpleAccent,
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: Icon(Icons.person_outline_outlined)));
  }

  static Widget items(UserModel userModel) {
    return Column(children: [
      Container(
          margin: EdgeInsets.all(5),
          height: 50,
          width: double.infinity,
          child: Row(
            children: [
              FutureBuilder(
                  future: DatabaseOperations.getImage(userModel.userDocId),
                  builder: (context, AsyncSnapshot<String> imageurl) {
                    if (imageurl.hasData) {
                      return Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(imageurl.data!),
                          ),
                        ),
                      );
                    } else {
                      return CircleAvatar(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userModel.name,
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      userModel.userDocId,
                      overflow: TextOverflow.fade,
                    )
                  ]),
            ],
          )),
      Divider(
        height: 3,
        thickness: 2,
        indent: 20,
        endIndent: 20,
      ),
    ]);
  }

  Widget userSearchResult(UserModel userModel) {
    return Container(
      child: Text(userModel.userDocId),
    );
  }
}

class ScreenArguments {
  final UserModel userModel;

  ScreenArguments({required this.userModel});
}
