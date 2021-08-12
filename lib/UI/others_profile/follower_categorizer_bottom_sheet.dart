import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:group_button/group_button.dart';
import 'package:linker/UI/edit_bottom_sheet/bottom_model.dart';
import 'package:linker/core/user_model.dart';
import 'package:linker/services/database/database_operations.dart';

class FollowerCategorizerBottomSheet extends StatefulWidget {
  UserModel userModel;
  FollowerCategorizerBottomSheet({required this.userModel});
  @override
  _FollowerCategorizerBottomSheetState createState() =>
      _FollowerCategorizerBottomSheetState();
}

class _FollowerCategorizerBottomSheetState
    extends State<FollowerCategorizerBottomSheet> {
  BottomModel bottomModel = BottomModel();
  List<String> choosenGroups = [];
  List<int> choosenGroupsIndexBefore = [];
  List<String> choosenGroupsNameBefore = ["herkes"];

  @override
  Widget build(BuildContext context) {
    bottomModel.reloadGroups();

    final deviceSize = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.topCenter,
      height: deviceSize.height * 0.7,
      child: Column(children: [
        Observer(builder: (_) {
          return FutureBuilder(
              future:
                  DatabaseOperations.getPermissionMyFollower(widget.userModel),
              builder: (context, AsyncSnapshot<List<dynamic>> perms) {
                List<int> selected = List<int>.generate(
                    (perms.data!.length),
                    (i) => bottomModel.groups
                        .cast<String>()
                        .indexOf(perms.data![i]));
                perms.data!.forEach((element) {
                  choosenGroups.add(element);
                });
                print(
                    selected.toString() + "aa" + perms.data!.length.toString());
                return GroupButton(
                  selectedButtons: selected,
                  isRadio: false,
                  spacing: 10,
                  buttons: bottomModel.groups.cast<String>(),
                  borderRadius: BorderRadius.circular(30),
                  onSelected: (i, selected) {
                    print(i);
                    if (selected) {
                      print("- selected" + i.toString());
                      choosenGroups.add(bottomModel.groups[i]);
                      print(selected.toString() + "is added");
                    }
                    if (!selected) {
                      choosenGroups.remove(bottomModel.groups[i]);
                    }
                    print("- full" + choosenGroups.toString());
                  },
                );
              });
        }),
        RaisedButton(
            child: Text("kaydet"),
            onPressed: () async {
              await DatabaseOperations.setPermissionMyFollower(
                  widget.userModel, choosenGroups);
              Navigator.pop(context);
              print(choosenGroups);
            })
      ]),
    );
  }
}
