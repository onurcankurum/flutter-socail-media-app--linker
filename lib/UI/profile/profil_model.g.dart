// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profil_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProfilModel on _ProfilModel, Store {
  final _$imageUrlAtom = Atom(name: '_ProfilModel.imageUrl');

  @override
  String get imageUrl {
    _$imageUrlAtom.reportRead();
    return super.imageUrl;
  }

  @override
  set imageUrl(String value) {
    _$imageUrlAtom.reportWrite(value, super.imageUrl, () {
      super.imageUrl = value;
    });
  }

  final _$bioAtom = Atom(name: '_ProfilModel.bio');

  @override
  String get bio {
    _$bioAtom.reportRead();
    return super.bio;
  }

  @override
  set bio(String value) {
    _$bioAtom.reportWrite(value, super.bio, () {
      super.bio = value;
    });
  }

  final _$linksAtom = Atom(name: '_ProfilModel.links');

  @override
  List<LinkModel> get links {
    _$linksAtom.reportRead();
    return super.links;
  }

  @override
  set links(List<LinkModel> value) {
    _$linksAtom.reportWrite(value, super.links, () {
      super.links = value;
    });
  }

  final _$getImageAsyncAction = AsyncAction('_ProfilModel.getImage');

  @override
  Future<void> getImage(String id) {
    return _$getImageAsyncAction.run(() => super.getImage(id));
  }

  @override
  String toString() {
    return '''
imageUrl: ${imageUrl},
bio: ${bio},
links: ${links}
    ''';
  }
}
