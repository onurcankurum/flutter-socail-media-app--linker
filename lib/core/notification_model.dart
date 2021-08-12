import 'dart:io';

import 'package:flutter/src/widgets/framework.dart';

class NotificationModel {
  String notification;
  String? who;
  String? whom;
  String date;

  NotificationModel(
      {required this.date, required this.notification, this.who, this.whom});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      date: json['date'],
      notification: json['notification'],
      who: json['who'],
      whom: json['whom'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification'] = this.notification;
    data['date'] = this.date;

    data['who'] = this.who;
    data['whom'] = this.whom;
    return data;
  }
}
