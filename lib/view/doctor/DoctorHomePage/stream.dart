import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

enum Status { initialState,loginSuccess,loginFailed,loading}

class DoctorHomeStream {
  static DoctorHomeStream model ;
  final StreamController<Status> _Controller = StreamController<Status>.broadcast();
  Stream<Status> get onAuthChanged => _Controller.stream;
  Sink<Status> get inData => _Controller.sink;


  void dispose() {_Controller.close();}

  static DoctorHomeStream getInstance() {

    if (model == null) {
      model = new DoctorHomeStream();
      model.checkLoggedIn();
      return model;
    } else {
      return model;
    }
  }


  void tryAgain()async{
    print("failed as doc");
    inData.add(Status.initialState);
  }
  void loginFailed()async{
    print("failed as doc");
    inData.add(Status.loginFailed);
  }
  void signIn(String type)async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    prefs.setBool("isLoggedIn", true).then((value) {
      prefs.setString("userType", type).then((value) {
        print("then is finished.going to in");
        inData.add(Status.loginSuccess);
      });
    });

  }
  void checkLoggedIn()async{
    print("trying to process");
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    if(prefs.getBool("isLoggedIn")) inData.add(Status.loginSuccess);
    else inData.add(Status.loginFailed);

  }
  void loginProcessing(){
    print("trying to process");
    inData.add(Status.loading);

  }

}