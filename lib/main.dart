import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:linker/UI/login/login_view.dart';

import 'UI/home/home_view.dart';
import 'UI/profile/profile_view.dart';

void main() async {
/*   WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(); */
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
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
            ),
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
                        return Home();
                      }

                      return LoginScreen();
                    }),
            routes: {
              // When navigating to the "/" route, build the FirstScreen widget.

              // When navigating to the "/second" route, build the SecondScreen widget.
              '/home': (context) => Home(),
              '/login': (context) => LoginScreen(),
              '/profile': (context) => Profile(),
            },
          );
        });
  }
}
