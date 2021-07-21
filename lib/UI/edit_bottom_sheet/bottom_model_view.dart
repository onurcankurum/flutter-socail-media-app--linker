import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:group_button/group_button.dart';
import 'package:linker/UI/profile/profile_model_view.dart';
import 'package:linker/UI/profile/profile_view.dart';
import 'package:linker/core/link_model.dart';
import 'package:linker/services/database/database_operations.dart';

import 'bottom_model.dart';

class BottomModelView {
  static final TextEditingController _controllerPlatform =
      new TextEditingController();
  static final TextEditingController _controllerNick =
      new TextEditingController();
  static final bottomModel = BottomModel();
  static List<String> choosenGroups = [];

  static Widget layerLister(List<String> layerlist) {
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
              "e-posta",
              "linkedin",
              "snapchat",
              "twitter"
            ].map<PopupMenuItem<String>>((String value) {
              return new PopupMenuItem(child: new Text(value), value: value);
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

  static Widget saveButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          Navigator.pop(context);
          await DatabaseOperations.setNewLink(
              Profile.currentuser,
              LinkModel(
                  nick: _controllerNick.text,
                  izinliler: choosenGroups,
                  platform: _controllerPlatform.text,
                  docId: "yeni"));
          ProfileModelView.profilModel.getLinks();
          choosenGroups.clear();
        },
        child: Text('kaydet'));
  }
}
