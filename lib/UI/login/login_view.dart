import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linker/UI/login/login_model_view.dart';
import 'package:linker/core/user_model.dart';
import 'package:linker/services/database/auth.dart';
import 'package:linker/services/database/database_operations.dart';
import 'login_model.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isRegister = true;
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
      Navigator.pushReplacementNamed(context, '/home');
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );

    return msg;
  }

  void register() async {
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
      _isRegister = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.blue[100],
        body: Container(
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
                    LoginModelView.nickName(_isRegister),
                    LoginModelView.password(),
                    _isRegister
                        ? LoginModelView.usernameField()
                        : SizedBox.shrink(),
                    _isRegister ? LoginModelView.email() : SizedBox.shrink(),
                    ElevatedButton(
                        onPressed: () {
                          if (_isRegister) {
                            setState(() {
                              register();
                            });
                          } else {
                            signIn(context);
                          }
                        },
                        child: _isRegister
                            ? Text('kayıt olmak')
                            : Text('giriş yapmak')),
                    TextButton(
                        onPressed: () async {
                          setState(() {
                            _isRegister
                                ? _isRegister = false
                                : _isRegister = true;
                          });
                        },
                        child: _isRegister
                            ? Text('giriş ekranı')
                            : Text('kayıt ekranı'))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
