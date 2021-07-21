import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:linker/UI/edit_bottom_sheet/bottom_model_view.dart';
import 'package:linker/UI/home/logi_model_view.dart';

class EditBottomSheet extends StatefulWidget {
  EditBottomSheet({Key? key}) : super(key: key);

  @override
  _EditBottomSheetState createState() => _EditBottomSheetState();
}

class _EditBottomSheetState extends State<EditBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
      child: Container(
          alignment: Alignment.center,
          height: deviceSize.height * 0.8,
          width: double.infinity,
          child: Column(children: [
            BottomModelView.platformInputField(),
            BottomModelView.platformNickField(),
            BottomModelView.layerLister([
              'aile',
              'arkadaşlar',
              'diğer',
              'bablar',
              'salaklar',
              'bebişler'
                  'aile',
              'arkadaşlar',
              'diğer',
              'bablar',
              'salaklar',
              'bebişler',
            ]),
            BottomModelView.saveButton(context),
          ])),
    );
  }
}
