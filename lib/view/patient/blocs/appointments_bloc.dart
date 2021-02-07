import 'dart:async';
import 'dart:convert';

import 'package:maulaji/view/patient/sharedActivitys.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _baseUrl = "https://api.callgpnow.com/api/";
String _baseUrl_image = "https://api.callgpnow.com/";

class UpCommingAppointmentModel {
  static UpCommingAppointmentModel model = null;
  final StreamController<List> _Controller = StreamController<List>.broadcast();

  Stream<List> get outData => _Controller.stream;

  Sink<List> get inData => _Controller.sink;

  dataReload() {
    getVdoAppDataUpComming().then((value) => inData.add(value));
  }

  void dispose() {
    _Controller.close();
  }

  static UpCommingAppointmentModel getInstance() {
    if (model == null) {
      model = new UpCommingAppointmentModel();
      return model;
    } else {
      return model;
    }
  }

  Future<List> getVdoAppDataUpComming() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    String AUTH_KEY = prefs.getString("auth");
    String UID = prefs.getString("uid");
    body = <String, String>{'user_type': "patient", 'id': UID};
    String apiResponse =
        await makePostReq("get_video_appointment_upcomming", AUTH_KEY, body);

    return json.decode(apiResponse);
  }
}
