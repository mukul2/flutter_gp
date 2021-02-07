import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

enum Status { initialState,loginSuccess,loginFailed,loading}

class PatientHomeStream {
  static PatientHomeStream model ;
  final StreamController<Status> _Controller = StreamController<Status>.broadcast();
  Stream<Status> get onAuthChanged => _Controller.stream;
  Sink<Status> get inData => _Controller.sink;


  void dispose() {_Controller.close();}

  static PatientHomeStream getInstance() {

    if (model == null) {
      model = new PatientHomeStream();
      return model;
    } else {
      return model;
    }
  }


  void tryAgain()async{
    print("failed as patient");
    inData.add(Status.initialState);
  }
  void loginFailed()async{
    print("failed as patient");
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
  void loginProcessing(){
    print("trying to process");
    inData.add(Status.loading);

  }

}