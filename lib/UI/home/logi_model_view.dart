import 'package:flutter/material.dart';

class HomeModelView {
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

  static Widget FloatButtonNotification(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        child: FloatingActionButton(
            backgroundColor: Colors.deepOrangeAccent,
            onPressed: () {
              // Navigator.pushNamed(context, '/profile');
            },
            child: Icon(
              Icons.notifications_active_outlined,
            )));
  }

  static Widget FloatButtonProfile(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        child: FloatingActionButton(
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
}
