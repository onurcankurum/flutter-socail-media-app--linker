import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:linker/UI/login/login_view.dart';
import 'package:linker/UI/others_profile/others_profile_views.dart';
import 'package:linker/services/database/database_operations.dart';

import 'UI/home/home_model_view.dart';
import 'UI/home/home_view.dart';
import 'UI/notifications/notification_view.dart';
import 'UI/profile/profile_view.dart';
import 'core/user_model.dart';
import 'services/database/auth.dart';

void main() async {
/*   WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(); */

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final _functions = FirebaseFunctions.instance;
  static bool isRegister = false;
  static UserModel currentuser =
      UserModel(userDocId: "", email: "bilemem", pass: "pass", name: "name");
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    //FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
    return FutureBuilder(
        future: _initialization,
        builder: (context, appSnapshot) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.
                primarySwatch: Colors.blue,
                primaryColor: Colors.deepPurpleAccent),
            home: appSnapshot.connectionState != ConnectionState.done
                ? CircularProgressIndicator()
                : StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (ctx, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (userSnapshot.hasData) {
                        print("alş");
                        print(isRegister);
                        if (isRegister) {
                          isRegister = false;
                          print("alş");
                          return LoginScreen();
                        }

                        return Home();
                      } else {
                        return LoginScreen();
                      }
                    }),
            routes: {
              // When navigating to the "/" route, build the FirstScreen widget.

              // When navigating to the "/second" route, build the SecondScreen widget.
              '/home': (context) => Home(),
              '/login': (context) => LoginScreen(),
              '/profile': (context) => Profile(),
              NotificationView.routeName: (context) => NotificationView(),
              OthersProfileViews.routeName: (context) => OthersProfileViews(),
            },
          );
        });
  }
}
