import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linker/UI/login/login_model_view.dart';
import 'package:linker/UI/profile/profile_view.dart';
import 'package:linker/core/user_model.dart';
import 'package:linker/main.dart';
import 'package:linker/services/database/auth.dart';
import 'package:linker/services/database/database_operations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_model.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginScreen extends StatefulWidget {
  static bool isRegister = true;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    if (msg == "giriş başarılı") {
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

    return Scaffold(
        backgroundColor: Colors.blue[100],
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Form(
                key: LoginModelView.formKey,
                child: Container(
                  width: deviceSize.width,
                  height: deviceSize.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(40),
                        child: Image(
                          image: AssetImage('assets/icon.png'),
                          color: Colors.deepOrangeAccent,
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
                              ? Text('kayıt olmak')
                              : Text('giriş yapmak')),
                      TextButton(
                          onPressed: () async {
                            setState(() {
                              LoginScreen.isRegister
                                  ? LoginScreen.isRegister = false
                                  : LoginScreen.isRegister = true;
                            });
                          },
                          child: LoginScreen.isRegister
                              ? Text('giriş ekranı')
                              : Text('kayıt ekranı'))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
