import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

enum LoginStatus { unknown, loggedAsDoc, loggedAsPat, loggedOut ,loginProcessing,loginFailedAsDoc,loginFailedAspatient,moveMainToPatientLogint}

class UserAuthStream {
  static UserAuthStream model ;
  final StreamController<LoginStatus> _Controller = StreamController<LoginStatus>.broadcast();
  Stream<LoginStatus> get onAuthChanged => _Controller.stream;
  Sink<LoginStatus> get inData => _Controller.sink;

  dataReload() {getData().then((value) => inData.add(value));}

  void dispose() {_Controller.close();}
  static UserAuthStream getInstance() {

    if (model == null) {
      model = new UserAuthStream();
      model.dataReload();
      return model;
    } else {
      model.dataReload();
      return model;
    }
  }
  static UserAuthStream getInstanceNoCheck() {

    if (model == null) {
      model = new UserAuthStream();
      return model;
    } else {
      return model;
    }
  }
  void signOut()async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    prefs.setBool("isLoggedIn", false).then((value) {
      print("then is finished.going to in");

      dataReload();
    });
  }

  void loginFailedAsPatient()async{
    print("failed as patient");

    inData.add(LoginStatus.loginFailedAspatient);
  }
  void signIn(String type)async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    prefs.setBool("isLoggedIn", true).then((value) {
      prefs.setString("userType", type).then((value) {
        print("then is finished.going to in");

        dataReload();
      });
    });

  }
  void loginProcessing(){
    print("trying to process");
    inData.add(LoginStatus.loginProcessing);

  }
  void loginFailedAsDoc(){
    print("failed as doc");
    inData.add(LoginStatus.loginFailedAsDoc);
  }
  void moveToPatientLogin(){
    print("failed as doc");
    inData.add(LoginStatus.moveMainToPatientLogint);
  }

  void changeUserTYPE(String type)async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    prefs.setBool("isLoggedIn", true).then((value) {
      prefs.setString("userType", type).then((value) {
        print("then is finished.going to in");

        dataReload();
      });
    });

  }

  Future<LoginStatus> getData() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    bool isLoggedIn = false;
    String type;

    if(prefs.getBool("isLoggedIn")==null){
      return LoginStatus.loggedOut;
    }else if(prefs.getBool("isLoggedIn")==true){
      type = prefs.getString("userType");
      if(type == "p"){
        return LoginStatus.loggedAsPat;
      }else {
        return LoginStatus.loggedAsDoc;
      }
      return LoginStatus.loggedOut;
    }else {
      return LoginStatus.loggedOut;
    }

  }
}






