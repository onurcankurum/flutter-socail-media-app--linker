import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linker/UI/edit_bottom_sheet/bottom_view.dart';
import 'package:linker/UI/home/home_model_view.dart';
import 'package:linker/UI/others_profile/follower_categorizer_bottom_sheet.dart';
import 'package:linker/UI/others_profile/others_profile_views.dart';
import 'package:linker/UI/profile/profile_model_view.dart';
import 'package:linker/UI/profile/profile_view.dart';
import 'package:linker/core/link_model.dart';
import 'package:linker/core/notification_model.dart';
import 'package:linker/core/user_model.dart';
import 'package:linker/main.dart';
import 'package:linker/services/database/database_operations.dart';
import 'package:url_launcher/url_launcher.dart';

class otherProfileModelView {
  static bool isbuttonBusy = false;
  static Widget IdentityZone({
    required Function setstate,
    required UserModel userModel,
    required double height,
    required double width,
    required BuildContext context,
  }) {
    return Container(
        height: height,
        width: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(top: height * 0.05, left: height * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // resimDownloader(height),
                  profilAvatar(userModel.userDocId, height, context, width),
                  Container(
                    width: width * 0.7,
                    height: height * 0.50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "biyografi",
                          style: GoogleFonts.meriendaOne(
                              fontSize: 15, fontStyle: FontStyle.normal),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Padding(
                          padding: EdgeInsets.all(2),

                          //newly added
                          child: Container(
                              child: FutureBuilder(
                                  future: DatabaseOperations.getBio(userModel),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(snapshot.data!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(),
                                          softWrap: true);
                                    } else {
                                      return Container();
                                    }
                                  })),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(height * 0.03),
                child: Text(userModel.name),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Container(
                    width: width * 0.45,
                    child: FutureBuilder(
                        future: DatabaseOperations.isFollowing(
                            MyApp.currentuser, userModel),
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> isFollow) {
                          if (isFollow.hasData) {
                            if (isFollow.data == true) {
                              return OutlinedButton(
                                onPressed: () async {
                                  setstate();
                                  await DatabaseOperations.unFollow(
                                      me: MyApp.currentuser, it: userModel);
                                  setstate();
                                  HomeModelView.homeModel.updateUsers();
                                },
                                child: Text("${MyApp.lang.unfollow}"),
                              );
                            } else {
                              return OutlinedButton(
                                onPressed: () async {
                                  setstate();

                                  await FirebaseFunctions.instance
                                      .httpsCallable("bildirimSend")
                                      .call(<String, dynamic>{
                                    "data": {
                                      "token": await DatabaseOperations.getFcm(
                                          userModel.userDocId),
                                      "title":
                                          "${MyApp.currentuser.userDocId} ${MyApp.lang.startedFollowU}",
                                      "body": "${MyApp.lang.addSpecialGroup}"
                                    }
                                  }).then((val) async {
                                    setstate();
                                    await DatabaseOperations.addFriend(
                                            me: MyApp.currentuser,
                                            it: userModel)
                                        .then((value) {
                                      DatabaseOperations.setNewNotification(
                                          userModel.userDocId,
                                          NotificationModel(
                                            date: DateTime.now().toString(),
                                            who:
                                                "${MyApp.currentuser.userDocId}",
                                            notification:
                                                "${MyApp.lang.startedFollowU}",
                                          ));
                                      setstate;
                                      DatabaseOperations.getAllFollowers(
                                              it: MyApp.currentuser)
                                          .then((value) async {
                                        value.forEach((element) async {
                                          DatabaseOperations.setNewNotification(
                                              element,
                                              NotificationModel(
                                                date: DateTime.now().toString(),
                                                who:
                                                    "${MyApp.currentuser.userDocId}",
                                                whom: "${userModel.userDocId}",
                                                notification:
                                                    "${MyApp.lang.someOneFollowSomeone}",
                                              ));
                                          await DatabaseOperations.getFcm(
                                              element);
                                          await FirebaseFunctions.instance
                                              .httpsCallable("bildirimSend")
                                              .call(<String, dynamic>{
                                                "data": {
                                                  "token":
                                                      await DatabaseOperations
                                                          .getFcm(element),
                                                  "title": MyApp.lang.follow ==
                                                          "follow"
                                                      ? "${MyApp.lang.someOneFollowSomeone} ${MyApp.currentuser.userDocId}, ${userModel.userDocId}"
                                                      : "${MyApp.currentuser.userDocId}, ${userModel.userDocId}'${MyApp.lang.someOneFollowSomeone}",
                                                  "body":
                                                      "bildirimleri g??rmek i??in t??kla"
                                                }
                                              })
                                              .then((value) => null)
                                              .onError((error, stackTrace) {
                                                print(element +
                                                    "e bildirim g??nderilmekdi");
                                              });
                                        });
                                        setstate();
                                        HomeModelView.homeModel.updateUsers();
                                        print(value);
                                      });
                                    });
                                  });
                                },
                                child: Text("${MyApp.lang.follow}"),
                              );
                            }
                          } else {
                            return OutlinedButton(
                              onPressed: null,
                              child: CircularProgressIndicator(),
                            );
                          }
                        }) /*  */
                    ),
                Container(
                    width: width * 0.45,
                    child: FutureBuilder(
                        future: DatabaseOperations.isFollowing(
                            userModel, MyApp.currentuser),
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> isFollow) {
                          if (isFollow.hasData) {
                            if (isFollow.data == true) {
                              return OutlinedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return FollowerCategorizerBottomSheet(
                                            userModel: userModel);
                                      });
                                },
                                child: Text("${MyApp.lang.addCat}"),
                              );
                            } else {
                              return OutlinedButton(
                                onPressed: null,
                                child: Text("${MyApp.lang.doesNotFollowU}"),
                              );
                            }
                          } else {
                            return OutlinedButton(
                              onPressed: null,
                              child: CircularProgressIndicator(),
                            );
                          }
                        }) /*  */
                    ),
              ]),
            ],
          ),
        ));
  }

  static Widget profilAvatar(
      String UserDocId, double height, BuildContext context, double width) {
    return FutureBuilder(
        future: DatabaseOperations.getImage(UserDocId),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return CircleAvatar(
              radius: width * 0.12,
              child: CachedNetworkImage(
                imageUrl: snapshot.data!,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage('assets/noImage.jpg'),
                      fit: BoxFit.cover),
                )),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
              ),
            );
          } else {
            return CircleAvatar(
              radius: width * 0.12,
              backgroundColor: Colors.black,
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  static Widget profileLinksZone(
    UserModel userModel,
    double width,
    double height,
  ) {
    return FutureBuilder(
        future: DatabaseOperations.getLinksOthers(
            me: MyApp.currentuser, it: userModel),
        builder:
            (BuildContext context, AsyncSnapshot<List<LinkModel>> snapshot) {
          if (snapshot.hasData) {
            return Container(
                height: (snapshot.data!.length * 40) + 50,
                width: double.infinity,
                color: Colors.deepOrange[10],
                child: Column(children: [
                  Container(
                    height: snapshot.data!.length * 40,
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final LinkModel item = snapshot.data![index];
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: otherProfileModelView.linkItem(
                                snapshot.data![index], context, width, height),
                          );
                        }),
                  ),
                ]));
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  static Widget linkItem(
      LinkModel linkModel, BuildContext context, double width, double height) {
    String icon = "";
    if (!ProfileModelView.knowingPlatforms.contains(linkModel.platform)) {
      icon = "hastag";
    } else {
      icon = linkModel.platform;
    }

    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Dialog(
                  backgroundColor: Colors.transparent,
                  child: new Container(
                      color: Colors.transparent,
                      width: width * 0.5,
                      height: height * 0.5,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                width: width * 0.5,
                                height: height * 0.06,
                              ),
                              Container(
                                  color: Colors.white,
                                  width: width,
                                  height: height * 0.44,
                                  child: Column(children: [
                                    SizedBox(
                                      height: height * 0.07,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width * 0.05,
                                        ),
                                        Text(
                                          "platform:",
                                          style: GoogleFonts.alice(
                                              fontSize: 20,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        SizedBox(
                                          width: width * 0.03,
                                        ),
                                        Text(
                                          linkModel.platform,
                                          style: GoogleFonts.alice(
                                              fontSize: 20,
                                              fontStyle: FontStyle.normal),
                                        ),
                                        SizedBox(
                                          width: width * 0.01,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width * 0.05,
                                        ),
                                        Text("nick:",
                                            overflow: TextOverflow.clip,
                                            maxLines: 2,
                                            style: GoogleFonts.alice(
                                                fontSize: 20,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w800)),
                                        SizedBox(
                                          width: width * 0.03,
                                        ),
                                        Container(
                                          width: width * 0.41,
                                          child: InkWell(
                                            onTap: () async {
                                              final url = linkModel.nick;
                                              if (await canLaunch(url)) {
                                                await launch(
                                                  url,
                                                  forceSafariVC: true,
                                                );
                                              }
                                              if (await canLaunch(
                                                  "https://www." +
                                                      linkModel.platform +
                                                      ".com/" +
                                                      url)) {
                                                await launch(
                                                  "https://www." +
                                                      linkModel.platform +
                                                      ".com/" +
                                                      url,
                                                  forceSafariVC: true,
                                                );
                                              }
                                            },
                                            child: Text(
                                              linkModel.nick,
                                              maxLines: 2,
                                              overflow: TextOverflow.fade,
                                              style: GoogleFonts.alice(
                                                  fontSize: 20,
                                                  fontStyle: FontStyle.normal),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.01,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Text(
                                      "${MyApp.lang.info}",
                                      overflow: TextOverflow.clip,
                                      style: GoogleFonts.alice(
                                          fontSize: 20,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        linkModel.info,
                                        style: GoogleFonts.alice(
                                          fontSize: 18,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ]))
                            ],
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: height * 0.06,
                                child: (ProfileModelView.knowingPlatforms
                                        .contains(linkModel.platform))
                                    ? SvgPicture.asset(
                                        'assets/${linkModel.platform}.svg',
                                        height: height * 0.1,
                                        semanticsLabel: 'Acme Logo')
                                    : SvgPicture.asset('assets/hastag.svg',
                                        height: height * 0.1,
                                        semanticsLabel: 'Acme Logo')),
                          )
                        ],
                      )),
                ),
              );
            });
      },
      child: Container(
          decoration: BoxDecoration(
              border: Border(
            top: BorderSide.none,
            right: BorderSide.none,
            bottom: BorderSide(color: Colors.black),
            left: BorderSide(color: Colors.black),
          )),
          height: 40,
          width: width,
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
              width: 5,
            ),
            SvgPicture.asset('assets/${icon}.svg',
                height: 20, semanticsLabel: 'Acme Logo'),
            SizedBox(
              width: 5,
            ),
            Stack(children: [
              Text(linkModel.platform + ":   "),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                SizedBox(
                  width: width * 0.3,
                ),
                Container(
                  width: width * 0.41,
                  child: Text(
                    linkModel.nick,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ])
            ]),
            Expanded(
              child: Container(),
            ),
            SvgPicture.asset('assets/more.svg',
                height: 20, semanticsLabel: 'Acme Logo'),
            SizedBox(
              width: 10,
            )
          ])),
    );
  }
}
