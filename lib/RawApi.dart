import 'dart:convert';
import 'package:http/http.dart' as http;
import 'networking/ApiProvider.dart';

Future<List<dynamic>> get_prescriptions({String targetuser}) async {

  String uid ;
  String utype = await getUserType();
  if(utype=="d"){
    uid = await getDoctor_id();
  }else {
    uid = await getPatientID();
  }
    // String ion =await getIon_user_id();
    final http.Response response = await http.post(
      'https://callgpnow.com/api_callgpnow/get_prescriptions.php',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'id': targetuser}),
    );
    print("Prescription downlaoded");
    print(response.body);
    print(uid);
    //showThisToast(response.statusCode.toString());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
     // downloadMyHomeVisitList();
    }

}
Future<List<dynamic>> downloadMyHomeVisitList() async {

  String uid ;
  String utype = await getUserType();
  if(utype=="d"){
    uid = await getDoctor_id();
  }else {
    uid = await getPatientID();
  }
    // String ion =await getIon_user_id();
    final http.Response response = await http.post(
      'https://callgpnow.com/api_callgpnow/home_visit_appointment_request_list.php',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'id': uid, 'userType':utype}),
    );
    print(response.body);
    print(uid);
    //showThisToast(response.statusCode.toString());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
     // downloadMyHomeVisitList();
    }

}

Future<List<dynamic>> downloadUrgentList() async {



    String uid ;
    String utype = await getUserType();
    if(utype=="d"){
      uid = await getDoctor_id();
    }else {
      uid = await getPatientID();
    }
    // String ion =await getIon_user_id();
    final http.Response response = await http.post(
      'https://callgpnow.com/api_callgpnow/urgent_appointment_list.php',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'id': uid, 'userType':utype}),
    );
    print(response.body);
    print(uid);
    //showThisToast(response.statusCode.toString());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      //downloadUrgentList();
    }

}

Future<List<dynamic>> downloadMyScheduledList() async {

    String uid ;
    String utype = await getUserType();
    if(utype=="d"){
      uid = await getDoctor_id();
    }else {
      uid = await getPatientID();
    }
    // String ion =await getIon_user_id();
    final http.Response response = await http.post(
      'https://callgpnow.com/api_callgpnow/scheduled_appointment_request_list.php',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'id': uid, 'userType':utype}),
    );
    print(response.body);
    print(uid);
    print(utype);
    //showThisToast(response.statusCode.toString());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      //downloadUrgentList();
    }

}
