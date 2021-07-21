import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'logi_model_view.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("linker"),
          actions: [Icon(Icons.person_search_outlined)],
        ),
        floatingActionButton: HomeModelView.floatActionButtons(
          profil: HomeModelView.FloatButtonNotification(context),
          notifications: HomeModelView.FloatButtonProfile(context),
        ),
        body: Center(
            child: ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: 40,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 50,
                    child: HomeModelView.items(),
                  );
                })));
  }
}
