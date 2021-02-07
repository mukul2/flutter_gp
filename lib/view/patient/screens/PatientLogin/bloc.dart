import 'package:maulaji/models/login_response.dart';
import 'package:maulaji/networking/ApiProvider.dart';
import 'package:maulaji/streams/AuthControllerStream.dart';
import 'package:maulaji/utils/mySharedPreffManager.dart';
import 'package:maulaji/view/patient/screens/DoctorLogin/stream.dart';
import 'package:maulaji/view/patient/screens/DoctorLogin/ui.dart';
import 'package:maulaji/view/patient/screens/PatientLogin/stream.dart';
import 'package:maulaji/models/PatientLoginModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Block {
  static Block block;

  clickedLogin(BuildContext context, String email, String password,String type) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {

     // Navigator.of(context).pop();
      //UserAuthStream.getInstanceNoCheck().loginProcessing();
      //update screen aout the process
      PatientLoginStream.getInstance().loginProcessing();
      PatientLoginModel loginResponse = await performLogin(email, password);
      //print(loginResponse.toString());
      //  showThisToast(loginResponse.message);

      //  showThisToast(loginResponse.toString());

      if (loginResponse != null && loginResponse.status) {
        //show login update status
        setLoginStatus(true);
        // AUTH_KEY = "Bearer " + loginResponse.accessToken;
        USER_ID = loginResponse.userInfo.id.toString();
        setUserType("p");

        Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
        SharedPreferences prefs = await _prefs;
        prefs.setString("uid", loginResponse.userInfo.id.toString());
        prefs.setString("patient_id", loginResponse.userInfo.patientId);
        prefs.setString("uname", loginResponse.userInfo.username.toString());
        prefs.setString("uphone", loginResponse.userInfo.phone.toString());
        prefs.setString("uphoto", loginResponse.userInfo.username.toString());
        prefs.setString("uemail", loginResponse.userInfo.email.toString());
        prefs.setString("utype", "p");
        prefs.setString("udes", "");
        prefs.setString("auth", "Bearer " + "1");
        prefs.setBool("isLoggedIn", true);

        PatientLoginStream.getInstance().signIn("p");

/*
        if (loginResponse.userInfo.userType.contains("d")) {
          DOC_HOME_VISIT = loginResponse.userInfo.home_visits;
          DoctorLoginStream.getInstance().signIn(loginResponse.userInfo.userType.toString());
        } else if (loginResponse.userInfo.userType.contains("p")) {
          PatientLoginStream.getInstance().signIn(loginResponse.userInfo.userType.toString());
        } else {
          //unknwon user
          // showThisToast("Unknown user");
        }

 */
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
