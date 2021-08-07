import 'dart:io';

class NotificationModel {
  String notification;
  String? who;
  String? whom;

  NotificationModel({required this.notification, this.who, this.whom});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notification: json['notification'],
      who: json['who'],
      whom: json['whom'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification'] = this.notification;

    data['who'] = this.who;
    data['whom'] = this.whom;
    return data;
  }
}
