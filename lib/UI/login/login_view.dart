import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linker/UI/login/login_model_view.dart';
import 'package:linker/UI/profile/profile_view.dart';
import 'package:linker/core/user_model.dart';
import 'package:linker/main.dart';
import 'package:linker/services/database/auth.dart';
import 'package:linker/services/database/database_operations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/database/lang_services/languages.dart';
import 'login_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:linker/services/database/lang_services/language_constants.dart'
    as lc;

class LoginScreen extends StatefulWidget {
  static bool isRegister = true;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _changeLanguage(Language language) async {
    Locale _locale = await lc.setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  @override
  void initState() {
    super.initState();
  }

  final loginS = Login();
  Future<String> signIn(BuildContext context) async {
    UserModel user = UserModel(
        userDocId: LoginModelView.nickController.text,
        email: "emaile henüz erişilmedi",
        pass: LoginModelView.passwordController.text,
        name: "isime henüz erişilmedi");
    String msg = await Auth.signIn(user: user);
    if (msg == "succesfull login" || msg == "giriş başarılı") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('nick', user.userDocId);
      await prefs.setString('email', user.email);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );

    return msg;
  }

  Future<void> register() async {
    UserModel user = UserModel(
        userDocId: LoginModelView.nickController.text,
        email: LoginModelView.emailController.text,
        pass: LoginModelView.passwordController.text,
        name: LoginModelView.nameController.text);
    if (LoginModelView.formKey.currentState!.validate() &&
        nickStatus.loading != loginS.nickstatus) {
      String a = await Auth.register(user: user);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(a),
        ),
      );
      LoginScreen.isRegister = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    double appBarheight = AppBar().preferredSize.height + 20;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<Language>(
                underline: SizedBox(),
                icon: Icon(
                  Icons.language,
                  color: Colors.blue,
                  size: 30,
                ),
                onChanged: (language) {
                  _changeLanguage(language!);
                  print(language.toString());
                },
                items: Language.languageList()
                    .map<DropdownMenuItem<Language>>(
                      (e) => DropdownMenuItem<Language>(
                        value: e,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              e.flag,
                              style: TextStyle(fontSize: 30),
                            ),
                            Text(e.name)
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(deviceSize.width * 0.05),
          child: Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Form(
                key: LoginModelView.formKey,
                child: Container(
                  width: deviceSize.width,
                  height: deviceSize.height - appBarheight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: deviceSize.height * 0.3,
                        child: Text(
                          "Linker",
                          style: GoogleFonts.jost(
                              color: Colors.black,
                              fontSize: deviceSize.height * 0.1,
                              fontStyle: FontStyle.normal),
                        ),
                      ),
                      LoginModelView.nickName(LoginScreen.isRegister),
                      LoginModelView.password(),
                      LoginScreen.isRegister
                          ? LoginModelView.usernameField()
                          : SizedBox.shrink(),
                      LoginScreen.isRegister
                          ? LoginModelView.email()
                          : SizedBox.shrink(),
                      ElevatedButton(
                          onPressed: () async {
                            if (LoginScreen.isRegister) {
                              setState(() async {
                                MyApp.isRegister = true;
                                await register();
                              });
                            } else {
                              MyApp.isRegister = false;
                              await FirebaseAuth.instance.signOut();
                              signIn(context);
                            }
                          },
                          child: LoginScreen.isRegister
                              ? Text(MyApp.lang.register)
                              : Text(MyApp.lang.login)),
                      TextButton(
                          onPressed: () async {
                            setState(() {
                              LoginScreen.isRegister
                                  ? LoginScreen.isRegister = false
                                  : LoginScreen.isRegister = true;
                            });
                          },
                          child: LoginScreen.isRegister
                              ? Text(MyApp.lang.loginScreen)
                              : Text(MyApp.lang.registerScreen))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
