import 'package:linker/services/database/database_operations.dart';
import 'package:mobx/mobx.dart';

import '../../main.dart';
//flutter packages pub run build_runner build
part 'bottom_model.g.dart';

//flutter packages pub run build_runner build
// This is the class used by rest of your codebase
class BottomModel = _BottomModel with _$BottomModel;

abstract class _BottomModel with Store {
  @observable
  dynamic groups = [];
  @action
  Future<void> reloadGroups() async {
    groups = await DatabaseOperations.getAllGroups(MyApp.currentuser);
  }
}
