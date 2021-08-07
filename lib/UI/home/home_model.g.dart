// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeModel on _HomeModel, Store {
  final _$usermodelReleaseAtom = Atom(name: '_HomeModel.usermodelRelease');

  @override
  List<UserModel> get usermodelRelease {
    _$usermodelReleaseAtom.reportRead();
    return super.usermodelRelease;
  }

  @override
  set usermodelRelease(List<UserModel> value) {
    _$usermodelReleaseAtom.reportWrite(value, super.usermodelRelease, () {
      super.usermodelRelease = value;
    });
  }

  @override
  String toString() {
    return '''
usermodelRelease: ${usermodelRelease}
    ''';
  }
}
