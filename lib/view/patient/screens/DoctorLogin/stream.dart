import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

enum Status { initialStateDoctor,loginSuccessDoctor,loginFailedDoctor,loadingDoctor}

class DoctorLoginStream {
  static DoctorLoginStream model ;
  final StreamController<Status> _Controller = StreamController<Status>.broadcast();
  Stream<Status> get onAuthChanged => _Controller.stream;
  Sink<Status> get inData => _Controller.sink;


  void dispose() {_Controller.close();}

  static DoctorLoginStream getInstance() {

    if (model == null) {
      model = new DoctorLoginStream();
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

      inData.add(Status.initialStateDoctor);
    });
  }

  void tryAgain()async{
    print("failed as patient");
    inData.add(Status.initialStateDoctor);
  }
  void loginFailed()async{
    print("failed as doctyor");
    inData.add(Status.loginFailedDoctor);
  }
  void signIn(String type)async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    prefs.setBool("isLoggedIn", true).then((value) {
      prefs.setString("userType", type).then((value) {
        print("then is finished.going to in");
        inData.add(Status.loginSuccessDoctor);
      });
    });

  }
  void loginProcessing(){
    print("trying to process");
    inData.add(Status.loadingDoctor);

  }

}






