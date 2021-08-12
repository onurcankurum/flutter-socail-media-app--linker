import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linker/core/user_model.dart';
import 'package:linker/main.dart';
import 'package:linker/services/database/database_operations.dart';

class Auth {
  static bool isRegister = false;

  static CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  static Future<String> register({required UserModel user}) async {
    String error = '';
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.email, password: user.pass);
      DatabaseOperations.insertUser(user);
      error = 'kayıt Başarılı';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return MyApp.lang.weakPassword;
      } else if (e.code == 'email-already-in-use') {
        return MyApp.lang.emailAlreadyInUser;
      }
    } catch (e) {
      return e.toString();
    }
    DatabaseOperations.createUserBiokDocs(user);
    DatabaseOperations.createUserLinkDocs(user);
    DatabaseOperations.createGroupsPath(user);
    DatabaseOperations.createUserFollowersAndFollowingkDocs(user);
    DatabaseOperations.createUserNotificationkDoc(user);

    return MyApp.lang.succesfullRegister;
  }

  static Future<String> signIn({required UserModel user}) async {
    try {
      user.email = await DatabaseOperations.nickToEmail(user.userDocId);
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: user.email, password: user.pass);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return MyApp.lang.noUserFoundForThatMail;
      } else if (e.code == 'wrong-password') {
        print('parola yanlış');
        return MyApp.lang.wrongPassword;
      } else {
        return MyApp.lang.somethingWentWrong;
      }
    } catch (e) {
      print("böyle bir nick yok");
      return MyApp.lang.thisNickDoesntExist;
    }

    print("giriş başarılı");
    return MyApp.lang.succesfullLogin;
  }
}
