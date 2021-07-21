// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottom_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BottomModel on _BottomModel, Store {
  final _$groupsAtom = Atom(name: '_BottomModel.groups');

  @override
  dynamic get groups {
    _$groupsAtom.reportRead();
    return super.groups;
  }

  @override
  set groups(dynamic value) {
    _$groupsAtom.reportWrite(value, super.groups, () {
      super.groups = value;
    });
  }

  final _$reloadGroupsAsyncAction = AsyncAction('_BottomModel.reloadGroups');

  @override
  Future<void> reloadGroups() {
    return _$reloadGroupsAsyncAction.run(() => super.reloadGroups());
  }

  @override
  String toString() {
    return '''
groups: ${groups}
    ''';
  }
}
