import 'dart:io';

class LinkModel {
  late String nick;
  late List<String> izinliler;
  late String platform;
  late String docId;
  late String info;

  LinkModel(
      {required this.nick,
      required this.izinliler,
      required this.platform,
      required this.docId,
      required this.info});

  factory LinkModel.fromJson(Map<String, dynamic> json, String docId) {
    return LinkModel(
        info: json['info'],
        nick: json['nick'],
        izinliler: json['izinliler'].cast<String>(),
        platform: json['platform'],
        docId: docId);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['info'] = this.info;
    data['nick'] = this.nick;
    data['izinliler'] = this.izinliler;
    data['platform'] = this.platform;
    return data;
  }
}
