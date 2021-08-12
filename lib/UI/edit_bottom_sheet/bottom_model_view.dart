import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:group_button/group_button.dart';
import 'package:linker/UI/profile/profile_model_view.dart';
import 'package:linker/UI/profile/profile_view.dart';
import 'package:linker/core/link_model.dart';
import 'package:linker/services/database/database_operations.dart';

import '../../main.dart';
import 'bottom_model.dart';

class BottomModelView {
  static final TextEditingController _controllerPlatform =
      new TextEditingController();
  static final TextEditingController _controllerNick =
      new TextEditingController();
  static final TextEditingController _controllerInfo =
      new TextEditingController();
  static final TextEditingController _controllerNewGroup =
      new TextEditingController();
  static final bottomModel = BottomModel();
  static List<String> choosenGroups = [];
  static final GlobalKey<AnimatedListState> listKey =
      GlobalKey<AnimatedListState>();
  static List<int> _items = [];
  static Widget layerLister() {
    return Observer(builder: (_) {
      return GroupButton(
        isRadio: false,
        spacing: 10,
        buttons: bottomModel.groups.cast<String>(),
        borderRadius: BorderRadius.circular(30),
        onSelected: (i, selected) {
          if (selected) {
            choosenGroups.add(bottomModel.groups[i]);
          }
          if (!selected) {
            choosenGroups.remove(bottomModel.groups[i]);
          }
          print(choosenGroups);
        },
      );
    });
  }

  static Widget platformInputField() {
    return TextField(
      controller: _controllerPlatform,
      decoration: InputDecoration(
        labelText: 'platform',
        suffixIcon: PopupMenuButton<String>(
          icon: const Icon(Icons.arrow_drop_down),
          onSelected: (String value) {
            _controllerPlatform.text = value;
          },
          itemBuilder: (BuildContext context) {
            return [
              'instagram',
              "youtube",
              "email",
              "linkedin",
              "linker",
              "snapchat",
              "twitter",
              "facebook",
              "tumblr",
              "spotify",
              "whatsapp",
              "diğer"
            ].map<PopupMenuItem<String>>((String value) {
              if (value == "diğer") {
                return new PopupMenuItem(
                    child: Row(children: [
                      SvgPicture.asset('assets/hastag.svg',
                          height: 20, semanticsLabel: 'Acme Logo'),
                      SizedBox(
                        width: 5,
                      ),
                      Text(value)
                    ]),
                    value: value);
              }
              if (value == "linker") {
                return new PopupMenuItem(
                    child: Row(children: [
                      Image.asset(
                        'assets/linker.png',
                        color: Colors.black,
                        height: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(value)
                    ]),
                    value: value);
              }
              return new PopupMenuItem(
                  child: Row(children: [
                    SvgPicture.asset('assets/${value}.svg',
                        height: 20, semanticsLabel: 'Acme Logo'),
                    SizedBox(
                      width: 5,
                    ),
                    Text(value)
                  ]),
                  value: value);
            }).toList();
          },
        ),
      ),
    );
  }

  static Widget platformNickField() {
    return TextFormField(
      controller: _controllerNick,
      decoration: InputDecoration(
        labelText: 'özel kullanıcı adı',
      ),
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {},
    );
  }

  static Widget platformInfoField() {
    return TextFormField(
      maxLines: 3,
      controller: _controllerInfo,
      validator: (val) {
        if (val == "") {
          return "bu çok kısa oldu";
        }
      },
      decoration: InputDecoration(
        labelText: 'açıklama serpiştirme',
      ),
      keyboardType: TextInputType.multiline,
      onSaved: (value) {},
    );
  }

  static Widget saveButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          Navigator.pop(context);
          await DatabaseOperations.setNewLink(
              MyApp.currentuser,
              LinkModel(
                  nick: _controllerNick.text,
                  izinliler: choosenGroups,
                  platform: _controllerPlatform.text,
                  docId: "yeni",
                  info: _controllerInfo.text));
          ProfileModelView.profilModel.getLinks();
          choosenGroups.clear();
          _controllerInfo.text = "";
          _controllerNick.text = "";
          _controllerPlatform.text = "";
        },
        child: Text('kaydet'));
  }

  static Widget newLayerButton(
    BuildContext context,
  ) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
        ),
        onPressed: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  child: Stack(children: [
                    Container(
                        color: Colors.transparent,
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(children: [
                          Container(
                            height: 30,
                            width: double.infinity,
                            color: Colors.transparent,
                          ),
                          Container(
                            height: 20,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                          Container(
                              color: Colors.white,
                              height: 50,
                              alignment: Alignment.center,
                              child: Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                      left: 10, top: 1, right: 10),
                                  alignment: Alignment.center,
                                  child: TextFormField(
                                    controller: _controllerNewGroup,
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                        hintText: 'örneğin kankalarım',
                                        suffixIcon: Container(
                                          child: FlatButton(
                                              onPressed: () {
                                                if (_controllerNewGroup.text !=
                                                    "") {
                                                  print(
                                                      "--------------dsfasdfasdf---------");
                                                  listKey.currentState!
                                                      .insertItem(0,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      500));
                                                  BottomModelView
                                                      .bottomModel.groups
                                                      .insert(
                                                          0,
                                                          _controllerNewGroup
                                                              .text);

                                                  DatabaseOperations
                                                      .updateGroups(
                                                          MyApp.currentuser,
                                                          BottomModelView
                                                              .bottomModel
                                                              .groups);
                                                  BottomModelView.bottomModel
                                                      .reloadGroups();
                                                }

                                                _controllerNewGroup.text = "";
                                              },
                                              child: Expanded(
                                                child: Text(
                                                  "ekle",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              )),
                                        )),
                                  ))),
                          Container(
                            color: Colors.white,
                            height: 500,
                            child: AnimatedList(
                              key: listKey,
                              initialItemCount:
                                  BottomModelView.bottomModel.groups.length,
                              itemBuilder:
                                  (BuildContext context, int index, animation) {
                                return BottomModelView.slideIt(
                                    context,
                                    index,
                                    animation,
                                    BottomModelView.bottomModel.groups[index]);
                              },
                            ),
                          ),
                        ])),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        alignment: Alignment.topRight,
                        child: SvgPicture.asset('assets/kapat.svg',
                            color: Colors.red,
                            height: 50,
                            width: 50,
                            semanticsLabel: 'Acme Logo'),
                      ),
                    )
                  ]),
                );
              });
        },
        child: Text(
          'yeni katman ekle',
          style: TextStyle(color: Colors.blue),
        ));
  }

  static Widget _buildChip(
      String label, Color color, int index, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Chip(
        labelPadding: EdgeInsets.all(2.0),
        avatar: CircleAvatar(
          backgroundColor: Colors.white70,
          child: Text(label[0].toUpperCase()),
        ),
        label: Container(
          width: double.infinity,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        deleteIcon: (Icon(
          Icons.delete,
          color: Colors.white,
        )),
        onDeleted: () async {
          listKey.currentState!.removeItem(
              index, (_, animation) => slideIt(context, 0, animation, label),
              duration: const Duration(milliseconds: 500));

          await BottomModelView.bottomModel.groups.removeAt(index);
          await DatabaseOperations.updateGroups(
              MyApp.currentuser, BottomModelView.bottomModel.groups);
          BottomModelView.bottomModel.reloadGroups();
        },
        backgroundColor: color,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.all(8.0),
      ),
    );
  }

  static Widget slideIt(
      BuildContext context, int index, animation, String label) {
    int item = index;
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset(0, 0),
      ).animate(animation),
      child: BottomModelView._buildChip(label, Colors.black45, index, context),
    );
  }
}
