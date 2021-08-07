import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linker/core/user_model.dart';
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
        return 'parola çok zayıf ';
      } else if (e.code == 'email-already-in-use') {
        return 'bu hesap zaten mevcut';
      }
    } catch (e) {
      return e.toString();
    }
    DatabaseOperations.createUserBiokDocs(user);
    DatabaseOperations.createUserLinkDocs(user);
    DatabaseOperations.createGroupsPath(user);
    DatabaseOperations.createUserFollowersAndFollowingkDocs(user);
    DatabaseOperations.createUserNotificationkDoc(user);

    return 'kayıt başarılı';
  }

  static Future<String> signIn({required UserModel user}) async {
    try {
      user.email = await DatabaseOperations.nickToEmail(user.userDocId);
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: user.email, password: user.pass);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return ('bu mail bulunamadı');
      } else if (e.code == 'wrong-password') {
        print('parola yanlış');
        return 'parola yanlış';
      } else {
        return 'birşeyler ters gitt';
      }
    } catch (e) {
      print("böyle bir nick yok");
      return "böyle bir nick yok";
    }

    print("giriş başarılı");
    return 'giriş başarılı';
  }
}
