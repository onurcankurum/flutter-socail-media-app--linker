import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:linker/UI/edit_bottom_sheet/bottom_model_view.dart';
import 'package:linker/UI/home/home_model_view.dart';

class EditBottomSheet extends StatefulWidget {
  EditBottomSheet({Key? key}) : super(key: key);

  @override
  _EditBottomSheetState createState() => _EditBottomSheetState();
}

class _EditBottomSheetState extends State<EditBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
      child: Container(
          alignment: Alignment.center,
          height: deviceSize.height * 0.9,
          width: double.infinity,
          child: Column(children: [
            BottomModelView.platformInputField(),
            BottomModelView.platformNickField(),
            BottomModelView.platformInfoField(),
            BottomModelView.layerLister(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BottomModelView.newLayerButton(context),
                SizedBox(width: 40),
                BottomModelView.saveButton(context),
              ],
            )
          ])),
    );
  }
}
