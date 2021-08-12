import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:linker/UI/login/login_model.dart';
import 'package:linker/main.dart';

class LoginModelView {
  static Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  static final loginS = Login();
  static final GlobalKey<FormState> formKey = GlobalKey();

  static final nickValidateKey = GlobalKey<FormFieldState>();
  static final passValidateKey = GlobalKey<FormFieldState>();
  static final emailValidateKey = GlobalKey<FormFieldState>();
  static final usernameValidateKey = GlobalKey<FormFieldState>();

  static final nickController = TextEditingController();
  static final passwordController = TextEditingController();
  static final emailController = TextEditingController();
  static final nameController = TextEditingController();

  static Widget nickName(bool isRegiter) {
    return Observer(builder: (_) {
      Widget last = Text("");
      switch (loginS.nickstatus) {
        case nickStatus.loading:
          last = SizedBox(
              child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CircularProgressIndicator(),
          ));
          break;

        case nickStatus.availeble:
          last = Icon(
            Icons.check,
            size: 40,
            color: Colors.green,
          );
          break;
        case nickStatus.nothing:
          last = Container();
          break;
        case nickStatus.unavailable:
          last = Icon(
            Icons.mood_bad,
            size: 40,
            color: Colors.red,
          );
          break;
        default:
          break;
      }

      return TextFormField(
        keyboardType: TextInputType.visiblePassword,
        controller: nickController,
        key: nickValidateKey,
        onChanged: (str) {
          isRegiter
              ? loginS.checkNickname(str)
              : loginS.nickstatus = nickStatus.nothing;
        },
        validator: (value) {
          if (!RegExp(r"^([a-z]+-{0,1})+([a-z]+)+$")
              .hasMatch(value.toString())) {
            return MyApp.lang.nickName +
                " büyük harf içermemeli (Uppercase error)";
          }
          if (!RegExp(r'^(?!.*\.\.)(?!.*\.$)[^\W][\w.]{0,29}$')
              .hasMatch(value.toString())) {
            return 'türkçe harf ve özel karakter içermemeli';
          } else if (loginS.nickstatus == nickStatus.unavailable) {
            return MyApp.lang.thisNickBelgsSomeOneElse;
          }
        },
        decoration: InputDecoration(
            labelText: MyApp.lang.nick,
            suffixIcon: SizedBox(
              child: last,
              width: 10,
              height: 10,
            )),
        onSaved: (value) {},
      );
    });
  }

  static Widget password() {
    Widget showHideIcon = Icon(Icons.visibility_off_outlined);
    return Observer(builder: (_) {
      if (loginS.showHide == true) {
        showHideIcon = Icon(Icons.visibility_off_outlined);
      } else {
        showHideIcon = Icon(Icons.visibility_outlined);
      }

      return TextFormField(
        obscureText: loginS.showHide ? true : false,
        controller: passwordController,
        key: passValidateKey,
        validator: (value) {
          if (!RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$')
              .hasMatch(value.toString())) {
            return MyApp.lang.passwordRules;
          }
        },
        onChanged: (str) {
          print(str);

          loginS.passwordCheck(str);
        },
        decoration: InputDecoration(
            labelText: MyApp.lang.password,
            suffixIcon: GestureDetector(
                onTap: () {
                  print(loginS.showHide);
                  if (loginS.showHide == true) {
                    loginS.showHide = false;
                  } else {
                    loginS.showHide = true;
                  }
                },
                child: showHideIcon)),
        keyboardType: TextInputType.visiblePassword,
        onSaved: (value) {},
      );
    });
  }

  static Widget email() {
    return Observer(builder: (_) {
      Widget emailStatusWidget = Text('');
      switch (loginS.mailstatus) {
        case emailStatus.notr:
          break;

        case emailStatus.invalid:
          emailStatusWidget = Icon(
            Icons.remove,
            size: 40,
            color: Colors.red,
          );
          break;
        case emailStatus.valid:
          emailStatusWidget = Icon(
            Icons.check,
            size: 40,
            color: Colors.green,
          );
          break;
        default:
          break;
      }

      return TextFormField(
        controller: emailController,
        key: emailValidateKey,
        validator: (value) {
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
              .hasMatch(value.toString())) {
            return MyApp.lang.invalidForNow;
          }
        },
        onChanged: (str) {
          loginS.emailCheck(str);
        },
        decoration: InputDecoration(
            labelText: MyApp.lang.e_mail, suffixIcon: emailStatusWidget),
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) {},
      );
    });
  }

  static Widget usernameField() {
    return TextFormField(
      controller: nameController,
      key: usernameValidateKey,
      validator: (value) {
        if (!RegExp(
                r'^[A-Za-zÁČĎÉĚÍŇÓŘŠŤÚŮÝŽáčďéěíňóřšťúůýžÅÆÉØåæéøÉËÏÓÖÜéëïóöüÄÅÖäåöÀÂÆÇÉÈÊËÏÎÔŒÙÛÜŸàâæçéèêëïîôœùûüÿÄÖÜẞäöüßÁÉÍÖÓŐÜÚŰáéíöóőüúűÁÆÐÉÍÓÖÞÚÝáæðéíóöþúýÀÈÉÌÒÓÙàèéìòóùÅÆÂÉÈÊØÓÒÔåæâéèêøóòôĄĆĘŁŃÓŚŹŻąćęłńóśźżÃÁÀÂÇÉÊÍÕÓÔÚÜãáàâçéêíõóôúüĂÂÎŞȘŢȚăâîşșţțÁÉÍÑÓÚÜáéíñóúüÄÅÉÖäåéöÂÇĞIİÎÖŞÜÛâçğıİîöşüû]+(?: [A-Za-zÁČĎÉĚÍŇÓŘŠŤÚŮÝŽáčďéěíňóřšťúůýžÅÆÉØåæéøÉËÏÓÖÜéëïóöüÄÅÖäåöÀÂÆÇÉÈÊËÏÎÔŒÙÛÜŸàâæçéèêëïîôœùûüÿÄÖÜẞäöüßÁÉÍÖÓŐÜÚŰáéíöóőüúűÁÆÐÉÍÓÖÞÚÝáæðéíóöþúýÀÈÉÌÒÓÙàèéìòóùÅÆÂÉÈÊØÓÒÔåæâéèêøóòôĄĆĘŁŃÓŚŹŻąćęłńóśźżÃÁÀÂÇÉÊÍÕÓÔÚÜãáàâçéêíõóôúüĂÂÎŞȘŢȚăâîşșţțÁÉÍÑÓÚÜáéíñóúüÄÅÉÖäåéöÂÇĞIİÎÖŞÜÛâçğıİîöşüû]+)*$')
            .hasMatch(value.toString())) {
          return MyApp.lang.thisNameNotRealName;
        }
      },
      onChanged: (str) {
        LoginModelView.usernameValidateKey.currentState!.validate();
      },
      decoration: InputDecoration(
        labelText: MyApp.lang.personalName,
      ),
      keyboardType: TextInputType.name,
      onSaved: (value) {},
    );
  }
}
