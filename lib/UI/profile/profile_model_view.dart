import 'dart:ffi';
import 'dart:io';
import 'dart:math' as Math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:linker/UI/edit_bottom_sheet/bottom_model_view.dart';
import 'package:linker/UI/edit_bottom_sheet/bottom_view.dart';
import 'package:linker/UI/profile/profil_model.dart';
import 'package:linker/UI/profile/profile_view.dart';
import 'package:linker/core/link_model.dart';
import 'package:linker/services/database/database_operations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

class ProfileModelView {
  static final List<String> knowingPlatforms = [
    'instagram',
    "youtube",
    "email",
    "linkedin",
    "snapchat",
    "twitter",
    "facebook",
    "tumblr",
    "spotify",
    "whatsapp",
    "diğer"
  ];
  static late File compressedImage;

  static final profilModel = ProfilModel();
  static bool isEdit = false;
  static final TextEditingController _controllerBio =
      new TextEditingController();
  static Widget floatActionButtonAdd(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: new Container(
          width: 100.0,
          height: 40.0,
          child: new Material(
            child: new InkWell(
              onTap: () async {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return EditBottomSheet();
                    });
                await BottomModelView.bottomModel.reloadGroups();
              },
              child: Icon(Icons.add),
            ),
            color: Colors.transparent,
          ),
          decoration: BoxDecoration(
            color: Colors.deepOrange,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
            borderRadius: new BorderRadius.all(Radius.circular(50)),
          ),
        ),
      ),
    );
  }

  static Widget IdentityZone(
      {required double height,
      required double width,
      required BuildContext context,
      required Function setstate}) {
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
                  Observer(builder: (_) {
                    print(profilModel.imageUrl);
                    return profilAvatar(height, isEdit, context, width);
                  }),
                  Container(
                    width: width * 0.7,
                    height: height * 0.50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        isEdit
                            ? SizedBox()
                            : Text(
                                MyApp.lang.biography,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.meriendaOne(
                                    fontSize: 15, fontStyle: FontStyle.normal),
                              ),
                        isEdit
                            ? SizedBox()
                            : Divider(
                                thickness: 2,
                              ),
                        Padding(
                          padding: EdgeInsets.all(2),

                          //newly added
                          child: Container(
                            child: isEdit
                                ? Container(
                                    height: height * 0.45,
                                    width: width * 0.7,
                                    child: TextField(
                                      controller: _controllerBio
                                        ..text = profilModel.bio,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  )
                                : Observer(
                                    builder: (_) {
                                      return FutureBuilder(
                                          future: profilModel.myBio(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<void> snapshot) {
                                            return Text(
                                              profilModel.bio,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.alice(
                                                  fontSize: 15,
                                                  fontStyle: FontStyle.normal),
                                            );
                                          });
                                    },
                                  ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(height * 0.03),
                child: FutureBuilder(
                    future: profilModel.getName(),
                    builder: (context, AsyncSnapshot<void> A) {
                      return Text(profilModel.name);
                    }),
              ),
              Container(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    if (isEdit) {
                      await DatabaseOperations.setBio(
                          MyApp.currentuser, _controllerBio.text);
                      profilModel.myBio();
                    }
                    isEdit ? isEdit = false : isEdit = true;
                    setstate();
                  },
                  child: isEdit
                      ? Text(MyApp.lang.saveProfile)
                      : Text(MyApp.lang.editProfile),
                ),
              ),
            ],
          ),
        ));
  }

  static Widget linkItem(
      LinkModel linkModel, BuildContext context, double width, double height) {
    String icon = "";
    if (!knowingPlatforms.contains(linkModel.platform)) {
      if (linkModel.platform == "linker") {
        icon = 'linker';
      } else {
        icon = "hastag";
      }
    } else {
      icon = linkModel.platform;
    }

    return Container(
        decoration: BoxDecoration(
            border: Border(
          top: BorderSide.none,
          right: BorderSide.none,
          bottom: BorderSide(color: Colors.black),
          left: BorderSide(color: Colors.black),
        )),
        height: 40,
        width: width * 0.95,
        child: Row(children: [
          InkWell(
            onTap: () => onTapLink(context, height, width, linkModel),
            child: Container(
              width: width * 0.85,
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  width: 5,
                ),
                icon == "linker"
                    ? Image.asset(
                        'assets/linker.png',
                        color: Colors.black,
                        height: 20,
                      )
                    : SvgPicture.asset('assets/${icon}.svg',
                        height: 20, semanticsLabel: 'Acme Logo'),
                SizedBox(
                  width: 5,
                ),
                Stack(children: [
                  Text(linkModel.platform + ":   "),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
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
                SizedBox(
                  width: 10,
                )
              ]),
            ),
          ),
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Dialog(
                        child: Container(
                          padding: EdgeInsets.all(height * 0.02),
                          height: width * 0.5,
                          width: height * 0.5,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Text(
                                "bu linki görebilenler",
                                style: GoogleFonts.sourceSansPro(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              Container(
                                width: height * 0.5,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Text(
                                          linkModel.platform + ":   ",
                                          style: GoogleFonts.sourceSansPro(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                      Text(
                                        linkModel.nick,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.sourceSansPro(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300),
                                      )
                                    ]),
                              ),
                              Divider(
                                indent: 40,
                                thickness: 3,
                                endIndent: 40,
                              ),
                              Text(
                                linkModel.izinliler.isEmpty
                                    ? "kimse"
                                    : linkModel.izinliler.toString(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.notoSans(fontSize: 18),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
            child: SvgPicture.asset('assets/more.svg',
                height: 20, semanticsLabel: 'Acme Logo'),
          ),
        ]));
  }

  static void onTapLink(
      BuildContext context, double height, double width, LinkModel linkModel) {
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
                                        style: GoogleFonts.alice(
                                            fontSize: 20,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w800)),
                                    SizedBox(
                                      width: width * 0.03,
                                    ),
                                    Container(
                                      width: width * 0.42,
                                      child:
                                          /* RichText(
                                        overflow: TextOverflow.clip,
                                        maxLines: 2,
                                        text: TextSpan(
                                          style: TextStyle(color: Colors.green),
                                          text: linkModel.nick,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url = linkModel.nick;
                                              if (await canLaunch(url)) {
                                                await launch(
                                                  url,
                                                  forceSafariVC: true,
                                                );
                                              }
                                            },
                                        ),
                                      ), */

                                          InkWell(
                                        onTap: () async {
                                          final url = linkModel.nick;
                                          if (await canLaunch(url)) {
                                            await launch(
                                              url,
                                              forceSafariVC: true,
                                            );
                                          }
                                          if (await canLaunch("https://www." +
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
                                  "açıklama",
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
                                    textAlign: TextAlign.center,
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
                                : linkModel.platform == 'linker'
                                    ? Image.asset(
                                        'assets/linker.png',
                                        color: Colors.black,
                                        height: height * 0.1,
                                      )
                                    : SvgPicture.asset('assets/hastag.svg',
                                        height: height * 0.1,
                                        semanticsLabel: 'Acme Logo')),
                      )
                    ],
                  )),
            ),
          );
        });
  }

  static Widget profilAvatar(
      double height, bool isEdit, BuildContext context, double width) {
    return FutureBuilder(
        future: profilModel.getImage(MyApp.currentuser.userDocId),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return isEdit
              ? GestureDetector(
                  onTap: () async {
                    final task = DatabaseOperations.uploadFile(
                        "users/${MyApp.currentuser.userDocId}.png",
                        await selectFile());

                    if (task == null) return;

                    await task.whenComplete(() async {
                      await profilModel.getImage(MyApp.currentuser.userDocId);
                    });
                  },
                  child: Stack(children: [
                    CircleAvatar(
                      radius: width * 0.12,
                      child: CachedNetworkImage(
                        imageUrl: profilModel.imageUrl,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
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
                    ),
                    CircleAvatar(
                      radius: width * 0.12,
                      backgroundColor: Colors.black45,
                      child: Icon(Icons.add_a_photo),
                    ),
                  ]),
                )
              : CircleAvatar(
                  radius: width * 0.12,
                  child: CachedNetworkImage(
                    imageUrl: profilModel.imageUrl,
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
        });
  }

  static Widget profileLinksZone(
    double width,
    double height,
  ) {
    ProfileModelView.profilModel.getLinks();
    return Observer(builder: (_) {
      return Container(
          height: (profilModel.links.length * 40) + 50,
          width: double.infinity,
          color: Colors.deepOrange[10],
          child: Column(children: [
            Container(
              height: profilModel.links.length * 40,
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: profilModel.links.length,
                  itemBuilder: (BuildContext context, int index) {
                    final LinkModel item = profilModel.links[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Dismissible(
                        background: Container(
                            color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "sil",
                                    style: GoogleFonts.aclonica(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    "Sil",
                                    style: GoogleFonts.aclonica(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                              ],
                            )),
                        onDismissed: (direction) {
                          DatabaseOperations.deleteOneLink(item);
                          profilModel.getLinks();
                          // Remove the item from the data source.

                          // Then show a snackbar.
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  '${item.platform} platformundan ${item.nick} silindi')));
                        },
                        key: Key(item.docId),
                        child: ProfileModelView.linkItem(
                            profilModel.links[index], context, width, height),
                      ),
                    );
                  }),
            ),
          ]));
    });
  }

  static Future<File> selectFile() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    if (result == null) return File("sdaef");
    final pathOriginal = result.files.single.path!;

    File imageFile = File(pathOriginal);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Math.Random().nextInt(10000);
    Im.Image? image = Im.decodeImage(imageFile.readAsBytesSync());
    Im.Image smallerImage = Im.copyResize(
      image!,
      width: 500,
    ); // choose the size here, it will maintain aspect ratio

    var compressedImage = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(smallerImage));

    return compressedImage;
  }
}
