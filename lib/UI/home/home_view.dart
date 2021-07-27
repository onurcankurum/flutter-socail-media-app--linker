import 'package:flutter/material.dart';
import 'package:linker/core/user_model.dart';
import 'package:linker/services/database/database_operations.dart';

import 'home_model_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearch = false;
  @override
  void initState() {
    super.initState();
  }

  setstate() {
    setState(() {});
  }

  double animeWidth = 1;
  final HomeModelView homeModelViews = HomeModelView();

  @override
  Widget build(BuildContext context) {
    final double appBarheight = AppBar().preferredSize.height * 1.32;
    final deviceSize = MediaQuery.of(context).size;
    print(appBarheight);

    return Scaffold(
        floatingActionButton: !HomeModelView.isSearch
            ? HomeModelView.floatActionButtons(
                profil: HomeModelView.FloatButtonNotification(context),
                notifications: HomeModelView.FloatButtonProfile(context),
              )
            : null,
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          homeModelViews.getAnimatedAppbar(deviceSize, appBarheight, setstate),
          !HomeModelView.isSearch
              ? Container(
                  width: double.infinity,
                  height: deviceSize.height - appBarheight,
                  child: ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemCount: 40,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 50,
                          child: HomeModelView.items(),
                        );
                      }))
              : FutureBuilder(
                  future: DatabaseOperations.searchUser(
                      HomeModelView.myController.text),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> results) {
                    if (results.hasData) {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: results.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return HomeModelView.searchResultCard(
                                results.data![index]);
                          });
                    } else {
                      return Text("arıyorum");
                    }
                  }),
        ]));
  }
}
