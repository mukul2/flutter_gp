import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

enum Status { initialStatePatient,loginSuccessPatient,loginFailedPatient,loadingPatient,guestPatient,signedOut}

class PatientLoginStream {
  static PatientLoginStream model ;
  final StreamController<Status> _Controller = StreamController<Status>.broadcast();
  Stream<Status> get onAuthChanged => _Controller.stream;
  Sink<Status> get inData => _Controller.sink;


  void dispose() {_Controller.close();}

  static PatientLoginStream getInstance() {

    if (model == null) {
      model = new PatientLoginStream();
      return model;
    } else {
      return model;
    }
  }


  void tryAgain()async{
    print("failed as patient");
    inData.add(Status.initialStatePatient);
  }
  void signOut()async{
    print("failed as patient");
    inData.add(Status.signedOut);
  }
  void loginFailed()async{
    print("failed as patient");
    inData.add(Status.loginFailedPatient);
  }
  void signIn(String type)async{

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    prefs.setBool("isLoggedIn", true).then((value) {
      prefs.setString("userType", type).then((value) {
        print("then is finished.going to in");
        inData.add(Status.loginSuccessPatient);
      });
    });

  }
  void loginProcessing(){
    print("trying to process");
    inData.add(Status.loadingPatient);

  }
  void patientGuestLogin(){
    print("trying to be quest");
    inData.add(Status.guestPatient);

  }
}






