import 'package:flutter/material.dart';
import 'package:linker/UI/home/home_model_view.dart';
import 'package:linker/UI/others_profile/others_profile_views.dart';
import 'package:linker/core/notification_model.dart';
import 'package:linker/services/database/database_operations.dart';

class NotificationModelView {
  static Widget item(NotificationModel notif, BuildContext context) {
    if (notif.whom == null) {
      return Column(children: [
        Container(
            height: 20,
            color: Colors.blueAccent[50],
            width: double.infinity,
            child: Row(
              children: [
                Text("   "),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    Navigator.pushNamed(context, OthersProfileViews.routeName,
                        arguments: ScreenArguments(
                            userModel: (await DatabaseOperations.getUser(
                                inputNick: notif.who!))!));
                  },
                  child: Text(
                    notif.who!,
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                Text("   "),
                Text(notif.notification)
              ],
            )),
        Divider()
      ]);
    } else {
      return Column(children: [
        Container(
            height: 20,
            color: Colors.blueAccent[50],
            width: double.infinity,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text("  "),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  Navigator.pushNamed(context, OthersProfileViews.routeName,
                      arguments: ScreenArguments(
                          userModel: (await DatabaseOperations.getUser(
                              inputNick: notif.who!))!));
                },
                child: Text(
                  notif.who!,
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Text(",  "),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  Navigator.pushNamed(context, OthersProfileViews.routeName,
                      arguments: ScreenArguments(
                          userModel: (await DatabaseOperations.getUser(
                              inputNick: notif.whom!))!));
                },
                child: Text(
                  notif.whom!,
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Text("  "),
              Text(notif.notification),
            ])),
        Divider()
      ]);
    }
  }
}
