import 'dart:convert';

import 'package:maulaji/models/doctor_login_model.dart';
import 'package:maulaji/models/login_response.dart';
import 'package:maulaji/networking/ApiProvider.dart';
import 'package:maulaji/streams/AuthControllerStream.dart';
import 'package:maulaji/utils/mySharedPreffManager.dart';
import 'package:maulaji/view/patient/screens/DoctorLogin/stream.dart';
import 'package:maulaji/view/patient/screens/DoctorLogin/ui.dart';
import 'package:maulaji/view/patient/screens/PatientLogin/stream.dart';
import 'package:maulaji/view/patient/screens/PatientLogin/ui.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Block {
  static Block block;

  clickedLogin(BuildContext context, String email, String password,String type) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {

     // Navigator.of(context).pop();
      //UserAuthStream.getInstanceNoCheck().loginProcessing();
      //update screen aout the process
      DoctorLoginStream.getInstance().loginProcessing();
      DoctorLoginModel loginResponse = await performLoginDoctor(email, password);
      //print(loginResponse.toString());
      //  showThisToast(loginResponse.message);

      //  showThisToast(loginResponse.toString());

      if (loginResponse != null && loginResponse.status) {
        //show login update status
        setLoginStatus(true);
        // AUTH_KEY = "Bearer " + loginResponse.accessToken;
       // USER_ID = loginResponse.userInfo.id.toString();
       // setUserType("");

        Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
        SharedPreferences prefs = await _prefs;

        prefs.setString("uid",loginResponse.userInfo.ionUserId);
        prefs.setString("uname", loginResponse.userInfo.username.toString());
        prefs.setString("uphone", loginResponse.userInfo.phone.toString());
        prefs.setString("uphoto", loginResponse.userInfo.imageUrl.toString());
        prefs.setString("uemail", loginResponse.userInfo.email.toString());
        prefs.setString("ion_user_id", loginResponse.userInfo.ionUserId);
        prefs.setString("utype", "d");
      //  prefs.setString("udes", loginResponse.userInfo.designationTitle.toString());
        prefs.setString("auth", "Bearer " + "");
        prefs.setBool("isLoggedIn", true);
        //UserAuthStream.getInstanceNoCheck().signIn("d");
        DoctorLoginStream.getInstance().signIn("d");
        //DoctorLoginStream.getInstance().signIn("d");
/*
        if (loginResponse.userInfo.userType.contains("d")) {
          DOC_HOME_VISIT = loginResponse.userInfo.home_visits;
        } else if (loginResponse.userInfo.userType.contains("p")) {
        } else {
          //unknwon user
          // showThisToast("Unknown user");
        }

 */

        // Navigator.of(context).pop();

     //   DoctorLoginStream.getInstance().signIn(loginResponse.userInfo.userType.toString());
      } else {
        if(type=="p"){
          PatientLoginStream.getInstance().loginFailed();
        }else {

          DoctorLoginStream.getInstance().loginFailed();
        }


        //show login failed with worng pass

        //  showThisToast(loginResponse.message);
      }
    });
  }

  clickedImDoctor(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => NewDoctorLoginForm()));
    });
  }

  static Block getInstance() {
    if (block == null) {
      block = new Block();

      return block;
    } else {
      return block;
    }
  }
}
