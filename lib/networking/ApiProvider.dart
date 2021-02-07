import 'dart:math';

import 'package:maulaji/chat/model/chat_message.dart';
import 'package:maulaji/models/doctor_login_model.dart';
import 'package:maulaji/models/login_response.dart';
import 'package:maulaji/networking/CustomException.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:maulaji/models/PatientLoginModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

String AUTH_KEY = "";
String USER_ID = "";
String USER_NAME = "";
String USER_PHOTO = "";
String USER_MOBILE = "";
String USER_EMAIL = "";
int DOC_HOME_VISIT = 0;

final String _baseUrl = "https://api.callgpnow.com/api/";
final String _baseUrl_raw_php = "https://callgpnow.com/api_callgpnow/";


Future <dynamic> pushNotification(dynamic b)async{
  http.Response response = await http.post(
    'https://fcm.googleapis.com/fcm/send',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization':
      'key=AAAA0EpRwPY:APA91bHBbBup11jcpJ65yZKqUqkUK5IPDUN9O51ade_qcoFKZdqyUuiK07v3mFSUmrA2ZAEP1M0zV09a794SZPOlmvbvDAOHN5cNdKNst0aCMq4WJIKbhDMWPK0ks-obO7rUd_vgTGIn',
      // Constant string
    },
    body: b,
  );
  return response;
}

Future<PatientLoginModel> performLogin(String email, String password) async {
  final http.Response response = await http.post(
    _baseUrl + 'login-app',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'email': email, 'password': password}),

  );
  print(response.body);
  //showThisToast(response.statusCode.toString());
  print(response.body);
  if (response.statusCode == 200) {
    dynamic jsonRes = json.decode(response.body);

    if (jsonRes["status"] == true) {
      PatientLoginModel loginResponse = PatientLoginModel.fromJson(json.decode(response.body));

      return loginResponse;
    } else
      return null;
  } else {
    return null;
    showThisToast(response.statusCode.toString());
    throw Exception('Failed to load album');
  }
}
Future<DoctorLoginModel> performLoginDoctor(String email, String password) async {
  final http.Response response = await http.post(
    _baseUrl + 'loginDoctor',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'email': email, 'password': password}),
  );
  //showThisToast(response.statusCode.toString());
  print("startd");
  print(response.body);
  print("end");
  if (response.statusCode == 200) {
    dynamic jsonRes = json.decode(response.body);

    if (jsonRes["status"] == true) {
      DoctorLoginModel loginResponse = DoctorLoginModel.fromJson(json.decode(response.body));
      USER_NAME = loginResponse.userInfo.username;
      USER_PHOTO = loginResponse.userInfo.imageUrl;
      USER_MOBILE = loginResponse.userInfo.phone;
      USER_EMAIL = loginResponse.userInfo.email;
      //showThisToast("phoyo link "+USER_PHOTO);


      return loginResponse;
    } else
      return null;
  } else {
    return null;
    showThisToast(response.statusCode.toString());
    throw Exception('Failed to load album');
  }
}

Future<dynamic> checkNumber(String phone) async {
  final http.Response response = await http.post(
    _baseUrl + 'checkMobileNumber',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'phone': phone}),
  );
  //showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}

Future<dynamic> fetchuserByEmailorPhone(String phone) async {
  final http.Response response = await http.post(
    _baseUrl + 'fetchuserByEmailorPhone',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'key': phone}),
  );
  //showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    showThisToast("API error");
    throw Exception('Failed to load album');
  }
}
Future<List> getGpList() async {
  final http.Response response = await http.get(
    _baseUrl_raw_php+ 'all_gp.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  //showThisToast(response.statusCode.toString());
  print(response.body);
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    getGpList();
  }
}
Future<List> getUrgentDocList() async {
  final http.Response response = await http.get(
    'https://callgpnow.com/api_callgpnow/urgent_doctors_list.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  //showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    getUrgentDocList();
  }
}
Future<List> getHomeVIsitDocList() async {
  final http.Response response = await http.get(
    'https://callgpnow.com/api_callgpnow/get_home_visit_doctors.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  //showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    getUrgentDocList();
  }
}
Future<dynamic> changePasswood(String phone, String pass) async {
  final http.Response response = await http.post(
    _baseUrl + 'changePasswood',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'phone': phone, 'newPassword': pass}),
  );
  //showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    showThisToast("API error");
    throw Exception('Failed to load album');
  }
}

Future<dynamic> signupPatient(String name, String phone, String email,
    String type, String password) async {
  final http.Response response = await http.post(
    _baseUrl + 'sign-up',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'phone': phone,
      'email': email,
      'user_type': type,
      'name': name,
      'password': password,
      'department': "0"
    }),
  );
  //showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}
Future<dynamic> homeVisitRequest(String dr_id,String patient_id,String problems,String patient_name,String reason,String birth_date,String hospital_id,String email,String home_address,String date,String phone) async {
  final http.Response response = await http.post(
   'https://callmygp.herokuapp.com/home_visit',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'dr_id': dr_id,
      'patient_id': patient_id,
      'problems': problems,
      'patient_name': patient_name,
      'reason': reason,
      'birth_date': birth_date,
      'hospital_id': hospital_id,
      'email': email,
      'home_address': home_address,
      'date': date,
      'phone': phone,
    }),
  );
  print(response.body);
  //showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return response.statusCode.toString();
  }
}
Future<dynamic> UrgentCareRequest(String dr_id,String patient_id,String problems,String patient_name,String reason,String birth_date,String hospital_id,String email,String home_address,String date,String phone,String allergy) async {

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs = await _prefs;
  final http.Response response = await http.post(
   'https://callgpnow.com/api_callgpnow/insert_urgent_req.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'dr_id': dr_id,
      'patient_id': patient_id,
      'problems': problems,
      'patient_name': prefs.getString("uname"),
      'reason': reason,
      'birth_date': birth_date,
      'hospital_id': hospital_id,
      'email': prefs.getString("email"),
      'home_address': home_address,
      'date': date,
      'phone': prefs.getString("uphone"),
      'status': "1",
      'dateReq':"2020-12-20",
      'appointment_for':"0",
      'allergy':allergy,
    }),
  );
  print(response.body);
  //showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return response.statusCode.toString();
  }
}
Future<String> getDepartmentsData() async {
  final http.Response response = await http.post(
    _baseUrl + 'department-list',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': AUTH_KEY,
    },
  );
//  this.setState(() {
//    blogCategoryList = json.decode(response.body);
//    getBlogs();
//  });
  return response.body;
}

Future<String> getTestRecListData(String auth) async {
  final http.Response response = await http.get(
    _baseUrl + 'all-diagnosis-test-list',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': auth,
    },
  );
  //showThisToast(response.statusCode.toString());
  //showThisToast(response.body.toString());
//  this.setState(() {
//    blogCategoryList = json.decode(response.body);
//    getBlogs();
//  });
  return response.body;
}

Future<dynamic> signupDoctor(String name, String phone, String email,
    String type, String password, String depaertment) async {
  final http.Response response = await http.post(
    _baseUrl + 'sign-up',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'phone': phone,
      'email': email,
      'user_type': type,
      'name': name,
      'password': password,
      'department':
          depaertment != null && depaertment.length > 0 ? depaertment : "0"
    }),
  );
  print(response.body);
  showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}

Future<dynamic> performLoginSecond(String email, String password) async {
  final http.Response response = await http.post(
    _baseUrl + 'login',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'email': email, 'password': password}),
  );
  // showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    LoginResponse loginResponse =
        LoginResponse.fromJson(json.decode(response.body));
    USER_NAME = loginResponse.userInfo.username;
    USER_PHOTO = loginResponse.userInfo.username;
    USER_MOBILE = loginResponse.userInfo.phone;
    USER_EMAIL = loginResponse.userInfo.email;
    //  showThisToast("phoyo link "+USER_PHOTO);
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}

Future<dynamic> performAppointmentSubmit(
    String AUTH,
    String patient_id,
    String dr_id,
    String problems,
    String phone,
    String name,
    String chamber_id,
    String date,
    String status,
    String type,
    String time) async {
  final http.Response response = await http.post(
    _baseUrl + 'add-appointment-info',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': AUTH,
    },
    body: jsonEncode(<String, String>{
      'patient_id': patient_id,
      'dr_id': dr_id,
      'problems': problems,
      'phone': phone,
      'name': name,
      'chamber_id': chamber_id,
      'date': date,
      'status': status,
      'type': type,
      'time': time,
    }),
  );
  print(response.body);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    showThisToast(response.statusCode.toString());

    throw Exception('Failed to load');
  }
}
Future<int> performAppointmentSubmitNewVersion(
    String AUTH,
    String patient_id,
    String dr_id,
    String problems,
    String phone,
    String name,
    String chamber_id,
    String date,
    String status,
    String type,
    String time,
    String age,
    String gender,
    String reasonToVisit,
    String condition,
    String medications,
    String weight,
    String temparature,
    String bloodPressure,
    String fees,
    String dateLong,
    String s_time_key,
    String hospital_id,
    ) async {
  final http.Response response = await http.post(
    _baseUrl + 'add-appointment-info',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': AUTH,
    },
    body: jsonEncode(<String, String>{
      'patient_id': patient_id,
      'dr_id': dr_id,
      'problems': problems,
      'phone': phone,
      'name': name,
      'chamber_id': chamber_id,
      'date': date,
      'status': status,
      'type': type,
      'time': time,
      'age': age,
      'gender': gender,
      'reasonToVisit': reasonToVisit,
      'condition': condition,
      'medications': medications,
      'weight': weight,
      'temparature': temparature,
      'bloodPressure': bloodPressure,
      'fees': fees,
      'dateLong': dateLong,
      's_time_key': s_time_key,
      'hospital_id': hospital_id,

    }),
  );
  print(response.body);
  return response.statusCode;
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    showThisToast(response.statusCode.toString());

    throw Exception('Failed to load');
  }
}
Future<LoginResponse> fetchDepartList(String email, String password) async {
  final http.Response response = await http.post(
    _baseUrl + 'department-list',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': AUTH_KEY,
    },
  );
  //  showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    return json.decode(response.body);
    // return LoginResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

Future<dynamic> updateDisplayName(
    String auth, String userID, String name) async {
  final http.Response response = await http.post(
    _baseUrl + 'update-user-info',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': auth,
    },
    body: jsonEncode(<String, String>{'name': name, 'user_id': userID}),
  );
  // showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    return json.decode(response.body);
    // return LoginResponse.fromJson(json.decode(response.body));
  } else {
    showThisToast((response.statusCode).toString());
    throw Exception('Failed to load album');
  }
}
Future<dynamic> updateDesignationName(
    String auth, String userID, String name) async {
  final http.Response response = await http.post(
    _baseUrl + 'update-user-info',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': auth,
    },
    body: jsonEncode(<String, String>{'designation_title': name, 'user_id': userID}),
  );
  // showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    return json.decode(response.body);
    // return LoginResponse.fromJson(json.decode(response.body));
  } else {
    showThisToast((response.statusCode).toString());
    throw Exception('Failed to load album');
  }
}
Future<int> updateBasicServiceFees(
    String auth, String userID, String type,String fees) async {
  final http.Response response = await http.post(
    _baseUrl + 'update_basic_fees',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': auth,
    },
    body: jsonEncode(<String, String>{'fees': fees, 'id': userID,'type':type}),
  );
  print(response.body);
  // showThisToast(response.statusCode.toString());

  return response.statusCode;
  if (response.statusCode == 200) {
    return json.decode(response.body);
    // return LoginResponse.fromJson(json.decode(response.body));
  } else {
    showThisToast((response.statusCode).toString());
    throw Exception('Failed to load album');
  }
}
Future<dynamic> submitPrescriptionPhotorequest(
    String cus_id, String cus_picture, String amount,String discount,String shippedcharges,String shippinaddress,String prescription_image) async {
  final http.Response response = await http.post(
    'https://callmygp.herokuapp.com/add_prescription_photo_order',
  body: <String, String>{
    'cus_id': cus_id,
    'cus_picture': cus_picture,
    'amount':amount,
    'discount':discount,
    'shippedcharges':shippedcharges,
    'status':"1",
    'shippinaddress':shippinaddress,
    'prescription_image':prescription_image,

  });
  print(response.statusCode.toString());
  //print(response.body);
  // showThisToast(response.statusCode.toString());

  return response.body;
  if (response.statusCode == 200) {
    return json.decode(response.body);
    // return LoginResponse.fromJson(json.decode(response.body));
  } else {
    showThisToast((response.statusCode).toString());
    throw Exception('Failed to load album');
  }
}
Future<dynamic> request_withdraw(
    String auth, String userID, String amout, String bank) async {
  final http.Response response = await http.post(
    _baseUrl + 'add_withdrawal_request',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': auth,
    },
    body: jsonEncode(
        <String, String>{'amount': amout, 'dr_id': userID, 'bankinfo': bank}),
  );
  // showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    return json.decode(response.body);
    // return LoginResponse.fromJson(json.decode(response.body));
  } else {
    showThisToast((response.statusCode).toString());
    throw Exception('Failed to load album');
  }
}
Future <String>getUserID()async{
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs = await _prefs;
  return prefs.getString("uid");
}
Future <String>getDoctor_id()async{
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs = await _prefs;
  return prefs.getString("ion_user_id");
}
Future <String>getUserName()async{
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs = await _prefs;
  return prefs.getString("uname");
}
Future <String>getUserType()async{
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs = await _prefs;
  return prefs.getString("userType");
}
Future <String>getUserPhoto()async{
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs = await _prefs;
  return prefs.getString("uphoto");
}
Future <String>getPatientID()async{
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs = await _prefs;
  return prefs.getString("patient_id");
}
Future<dynamic> addDiseasesHistory(String auth, String uid, String name,
    String startdate, String status) async {
  final http.Response response = await http.post(
    _baseUrl + 'add-disease-record',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': auth,
    },
    body: jsonEncode(<String, String>{
      'patient_id': uid,
      'disease_name': name,
      'first_notice_date': startdate,
      'status': status
    }),
  );
  // showThisToast(response.statusCode.toString());
  if (response.statusCode == 200) {
    return json.decode(response.body);
    // return LoginResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception((response.statusCode).toString());
  }
}

void showThisToast(String s) {
  Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
