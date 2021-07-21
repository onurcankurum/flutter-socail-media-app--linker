import 'dart:ffi';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:linker/UI/edit_bottom_sheet/bottom_model_view.dart';
import 'package:linker/UI/edit_bottom_sheet/bottom_view.dart';
import 'package:linker/UI/profile/profil_model.dart';
import 'package:linker/UI/profile/profile_view.dart';
import 'package:linker/core/link_model.dart';
import 'package:linker/services/database/database_operations.dart';

import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;

class ProfileModelView {
  static late File compressedImage;
  static final profilModel = ProfilModel();
  static bool isEdit = false;
  static final TextEditingController _controllerBio =
      new TextEditingController();
  static Widget IdentityZone(
      {required double height,
      required double width,
      required BuildContext context,
      required Function setstate}) {
    return Container(
        height: height,
        width: double.infinity,
        color: Colors.amber[50],
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
                        isEdit ? SizedBox() : Text("biografi"),
                        isEdit
                            ? SizedBox()
                            : Text(
                                "----------------------------------------------------------"),
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
                                            return Text(profilModel.bio,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(),
                                                softWrap: true);
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
                child: Text("Onur Can Kurum"),
              ),
              Container(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    if (isEdit) {
                      await DatabaseOperations.setBio(
                          Profile.currentuser, _controllerBio.text);
                      profilModel.myBio();
                    }
                    isEdit ? isEdit = false : isEdit = true;
                    setstate();
                  },
                  child: isEdit ? Text("bunu kaydet") : Text("profili düzenle"),
                ),
              ),
            ],
          ),
        ));
  }

  static Widget profileLinksZone() {
    ProfileModelView.profilModel.getLinks();
    return Observer(builder: (_) {
      return Container(
          height: (profilModel.links.length * 40) + 50,
          width: double.infinity,
          color: Colors.blue[50],
          child: Column(children: [
            Container(
              height: profilModel.links.length * 40,
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: profilModel.links.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ProfileModelView.linkItem(profilModel.links[index]);
                  }),
            ),
          ]));
    });
  }

  static Widget profilAvatar(
      double height, bool isEdit, BuildContext context, double width) {
    return FutureBuilder(
        future: profilModel.getImage(Profile.currentuser.userDocId),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return isEdit
              ? GestureDetector(
                  onTap: () async {
                    final task = DatabaseOperations.uploadFile(
                        "users/${Profile.currentuser.userDocId}.png",
                        await selectFile());

                    if (task == null) return;

                    await task.whenComplete(() async {
                      await profilModel.getImage(Profile.currentuser.userDocId);
                      print('burdayım');
                    });

                    print(profilModel.imageUrl);
                  },
                  child: Stack(children: [
                    CircleAvatar(
                      radius: width * 0.12,
                      backgroundColor: Colors.transparent,
                      foregroundImage: NetworkImage(profilModel.imageUrl),
                      child: Text("fotoğraf yükleniyor"),
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
                  backgroundColor: Colors.transparent,
                  foregroundImage: NetworkImage(profilModel.imageUrl),
                  child: Text("foto  seçin"),
                );
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

  static Widget linkItem(LinkModel linkModel) {
    return InkWell(
      onTap: () {
        DatabaseOperations.deleteOneLink(linkModel);
        profilModel.getLinks();
      },
      child: Container(
          height: 40,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Text(linkModel.platform),
            Text(linkModel.nick),
            Icon(Icons.help_outlined),
            Text(linkModel.izinliler.toString()),
            Icon(Icons.delete),
          ])),
    );
  }

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
}
