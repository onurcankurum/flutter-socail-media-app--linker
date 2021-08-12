import 'package:flutter/material.dart';
import 'package:linker/UI/notifications/notification_model_view.dart';
import 'package:linker/core/notification_model.dart';
import 'package:linker/core/user_model.dart';
import 'package:linker/main.dart';
import 'package:linker/services/database/database_operations.dart';

class NotificationView extends StatefulWidget {
  NotificationView({Key? key}) : super(key: key);
  static String routeName = "/notifications";
  static List<NotificationModel> items = [];
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    NotificationView.items.sort((a, b) => a.date.compareTo(b.date));

    return Scaffold(
        appBar: AppBar(
          title: Text(MyApp.lang.notifications),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: RefreshIndicator(
              displacement: 50,
              backgroundColor: Colors.blue,
              onRefresh: () async {
                NotificationView.items =
                    (await DatabaseOperations.getNotifications(
                        MyApp.currentuser));
                NotificationView.items.sort((a, b) => a.date.compareTo(b.date));

                setState(() {});
              },
              child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: NotificationView.items.length,
                  itemBuilder: (context, i) {
                    return NotificationModelView.item(
                        NotificationView
                            .items[NotificationView.items.length - i - 1],
                        context);
                    //do something
                  })),
        ));
  }
}
