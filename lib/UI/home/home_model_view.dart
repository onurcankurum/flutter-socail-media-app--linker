import 'package:flutter/material.dart';
import 'package:linker/UI/home/home_view.dart';
import 'package:linker/core/user_model.dart';
import 'package:linker/services/database/database_operations.dart';

class HomeModelView {
  static double animeWidth = 0;
  static TextEditingController myController = TextEditingController();
  static void _searchbarOpenAnime(Function setstate) {
    animeWidth = 700;
    setstate();
  }

  static void _searchbarCloseAnime(Function setstate) async {
    animeWidth = 1;
    setstate();
  }

  static Widget floatActionButtons(
      {required Widget profil, required Widget notifications}) {
    return Wrap(
      direction: Axis.horizontal, //
      children: [
        profil,
        notifications,
      ],
    );
  }

  static bool isSearch = false;

  Widget getAnimatedAppbar(
    Size deviceSize,
    double appBarheight,
    Function setsttate,
  ) {
    return Container(
      height: appBarheight,
      child: Stack(children: [
        Container(color: Colors.blue, width: 700, height: appBarheight),
        Container(
          alignment: Alignment.centerRight,
          width: deviceSize.width,
          height: appBarheight,
          child: AnimatedContainer(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            curve: isSearch ? Curves.easeOutSine : Curves.easeInOut,
            width: animeWidth,
            height: appBarheight,
            duration: Duration(milliseconds: 200),
          ),
        ),
        AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: isSearch
              ? GestureDetector(
                  onTap: () {
                    isSearch = false;
                    _searchbarCloseAnime(setsttate);
                  },
                  child: Icon(Icons.arrow_back))
              : Icon(Icons.menu),
          title: isSearch
              ? TextFormField(
                  controller: HomeModelView.myController,
                  onChanged: (s) {
                    print(myController.text);
                    setsttate();
                  },
                  cursorWidth: 1.2,
                  cursorRadius: Radius.circular(10),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  cursorColor: Colors.white,
                  cursorHeight: appBarheight * 0.45,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'kullanıcı adı girin',
                    hintStyle: TextStyle(color: Colors.blueGrey[300]),
                  ))
              : Container(alignment: Alignment.topRight, child: Text("Linker")),
          actions: [
            GestureDetector(
              onTap: () {
                if (isSearch == false) {
                  isSearch = true;

                  _searchbarOpenAnime(setsttate);
                }
              },
              child: Icon(Icons.search),
            )
          ],
        ),
      ]),
    );
  }

  static Widget FloatButtonNotification(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        child: FloatingActionButton(
            heroTag: "btn2",
            backgroundColor: Colors.deepOrangeAccent,
            onPressed: () {
              DatabaseOperations.searchUser("onu");
              DatabaseOperations.getUser(inputNick: "cccc");
            },
            child: Icon(
              Icons.notifications_active_outlined,
            )));
  }

  static Widget searchResultCard(String userDocId) {
    return FutureBuilder(
        future: DatabaseOperations.getUser(inputNick: userDocId),
        builder: (BuildContext context,
            AsyncSnapshot<UserModel?> snapshotUserModel) {
          if (snapshotUserModel.hasData) {
            return Container(
                color: Colors.cyan[100],
                height: 50,
                width: 100,
                child: Row(children: [
                  FutureBuilder(
                      future: DatabaseOperations.getImage(
                          snapshotUserModel.data!.userDocId),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshotImageUrl) {
                        if (snapshotImageUrl.hasData) {
                          return CircleAvatar(
                            foregroundImage:
                                NetworkImage(snapshotImageUrl.data!),
                          );
                        } else {
                          return Text("image not found");
                        }
                      }),
                  Container(
                    height: 50,
                    width: 100,
                    child: Column(children: [
                      Text(snapshotUserModel.data!.userDocId),
                      Text(snapshotUserModel.data!.name)
                    ]),
                  ),
                ]));
          } else {
            return Container(
                width: 100, height: 50, child: Text("ca<rd yüklenitor"));
          }
        });
  }

  static Widget FloatButtonProfile(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        child: FloatingActionButton(
            heroTag: "btn1",
            backgroundColor: Colors.deepPurpleAccent,
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: Icon(Icons.person_outline_outlined)));
  }

  static Widget items() {
    return Container(
        height: 50,
        width: double.infinity,
        child: Row(
          children: [
            CircleAvatar(
              child: Icon(Icons.person_add),
            ),
            Padding(
              padding: EdgeInsets.all(0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('isim soyisim'),
                    Text(
                      'bio buradada yazacak kanka ama uzun yaza',
                      overflow: TextOverflow.fade,
                    )
                  ]),
            )
          ],
        ));
  }

  Widget userSearchResult(UserModel userModel) {
    return Container(
      child: Text(userModel.userDocId),
    );
  }
}
