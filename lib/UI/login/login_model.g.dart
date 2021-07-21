// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Login on _Login, Store {
  final _$valueAtom = Atom(name: '_Login.value');

  @override
  int get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(int value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  final _$nickstatusAtom = Atom(name: '_Login.nickstatus');

  @override
  nickStatus get nickstatus {
    _$nickstatusAtom.reportRead();
    return super.nickstatus;
  }

  @override
  set nickstatus(nickStatus value) {
    _$nickstatusAtom.reportWrite(value, super.nickstatus, () {
      super.nickstatus = value;
    });
  }

  final _$passstatusAtom = Atom(name: '_Login.passstatus');

  @override
  passwordStatus get passstatus {
    _$passstatusAtom.reportRead();
    return super.passstatus;
  }

  @override
  set passstatus(passwordStatus value) {
    _$passstatusAtom.reportWrite(value, super.passstatus, () {
      super.passstatus = value;
    });
  }

  final _$mailstatusAtom = Atom(name: '_Login.mailstatus');

  @override
  emailStatus get mailstatus {
    _$mailstatusAtom.reportRead();
    return super.mailstatus;
  }

  @override
  set mailstatus(emailStatus value) {
    _$mailstatusAtom.reportWrite(value, super.mailstatus, () {
      super.mailstatus = value;
    });
  }

  final _$loginstatusAtom = Atom(name: '_Login.loginstatus');

  @override
  loginStatus get loginstatus {
    _$loginstatusAtom.reportRead();
    return super.loginstatus;
  }

  @override
  set loginstatus(loginStatus value) {
    _$loginstatusAtom.reportWrite(value, super.loginstatus, () {
      super.loginstatus = value;
    });
  }

  final _$showHideAtom = Atom(name: '_Login.showHide');

  @override
  bool get showHide {
    _$showHideAtom.reportRead();
    return super.showHide;
  }

  @override
  set showHide(bool value) {
    _$showHideAtom.reportWrite(value, super.showHide, () {
      super.showHide = value;
    });
  }

  final _$checkNicknameAsyncAction = AsyncAction('_Login.checkNickname');

  @override
  Future<bool> checkNickname(String nickTry) {
    return _$checkNicknameAsyncAction.run(() => super.checkNickname(nickTry));
  }

  final _$_LoginActionController = ActionController(name: '_Login');

  @override
  void passwordCheck(String pass) {
    final _$actionInfo =
        _$_LoginActionController.startAction(name: '_Login.passwordCheck');
    try {
      return super.passwordCheck(pass);
    } finally {
      _$_LoginActionController.endAction(_$actionInfo);
    }
  }

  @override
  void emailCheck(String email) {
    final _$actionInfo =
        _$_LoginActionController.startAction(name: '_Login.emailCheck');
    try {
      return super.emailCheck(email);
    } finally {
      _$_LoginActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value},
nickstatus: ${nickstatus},
passstatus: ${passstatus},
mailstatus: ${mailstatus},
loginstatus: ${loginstatus},
showHide: ${showHide}
    ''';
  }
}
