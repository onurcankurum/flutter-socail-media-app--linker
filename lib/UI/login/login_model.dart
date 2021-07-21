import 'dart:async';
import 'dart:core';

import 'package:linker/services/database/database_operations.dart';
import 'package:mobx/mobx.dart';

import 'login_model_view.dart';

part 'login_model.g.dart';

// This is the class used by rest of your codebase
class Login = _Login with _$Login;

// The store-class
enum nickStatus {
  availeble,
  unavailable,
  loading,
  nothing,
}
enum passwordStatus {
  short,
  good,
  notr,
}
enum emailStatus {
  valid,
  invalid,
  notr,
}
enum loginStatus {
  valid,
  invalid,
  notr,
}

abstract class _Login with Store {
  @observable
  int value = 0;
  @observable
  nickStatus nickstatus = nickStatus.nothing;
  @observable
  passwordStatus passstatus = passwordStatus.notr;
  @observable
  emailStatus mailstatus = emailStatus.notr;
  @observable
  loginStatus loginstatus = loginStatus.notr;
  @observable
  bool showHide = true;

  @action
  Future<bool> checkNickname(String nickTry) async {
    nickstatus = nickStatus.loading;
    if (LoginModelView.nickValidateKey.currentState!.validate() &&
        nickTry != '') {
      if (true == await DatabaseOperations.isNickExist(nickTry)) {
        nickstatus = nickStatus.unavailable;
        return false;
      } else {
        nickstatus = nickStatus.availeble;
        return true;
      }
    } else {
      nickstatus = nickStatus.unavailable;
      return false;
    }
  }

  @action
  void passwordCheck(String pass) {
    if (!LoginModelView.passValidateKey.currentState!.validate()) {
      passstatus = passwordStatus.short;
    } else {
      passstatus = passwordStatus.good;
    }
  }

  @action
  void emailCheck(String email) {
    LoginModelView.emailValidateKey.currentState!.validate();
    if (email.isEmpty || !email.contains('@')) {
      mailstatus = emailStatus.invalid;
    } else {
      mailstatus = emailStatus.valid;
    }
  }
}
