import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
class StatusModel {
  Status status =Status.loading;
  SharedPreferences prefs= null ;

  StatusModel(this.status, this.prefs);
}
enum Status { done,loading,failed}

class PatientProfileStream {
  static PatientProfileStream model ;
  final StreamController<StatusModel> _Controller = StreamController<StatusModel>.broadcast();
  Stream<StatusModel> get onDataChanged => _Controller.stream;
  Sink<StatusModel> get inData => _Controller.sink;


  void dispose() {_Controller.close();}

  static PatientProfileStream getInstance() {

    if (model == null) {
      model = new PatientProfileStream();
      model.dataReload();
      return model;
    } else {
      model.dataReload();
      return model;
    }
  }





  Future<StatusModel> dataReload() {load().then((value) => inData.add(value));}
   load()async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;

    return(StatusModel(Status.done,prefs));

    //inData.add(StatudModel(Status.done,prefs));

  }


}