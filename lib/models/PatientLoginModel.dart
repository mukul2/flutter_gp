
import 'dart:convert';

PatientLoginModel patientLoginModelFromJson(String str) => PatientLoginModel.fromJson(json.decode(str));

String patientLoginModelToJson(PatientLoginModel data) => json.encode(data.toJson());

class PatientLoginModel {
  PatientLoginModel({
    this.status,
    this.message,
    this.accessToken,
    this.userInfo,
  });

  bool status;
  String message;
  dynamic accessToken;
  UserInfo userInfo;

  factory PatientLoginModel.fromJson(Map<String, dynamic> json) => PatientLoginModel(
    status: json["status"],
    message: json["message"],
    accessToken: json["access_token"],
    userInfo: UserInfo.fromJson(json["user_info"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "access_token": accessToken,
    "user_info": userInfo.toJson(),
  };
}

class UserInfo {
  UserInfo({
    this.id,
    this.ipAddress,
    this.username,
    this.password,
    this.salt,
    this.email,
    this.activationCode,
    this.forgottenPasswordCode,
    this.forgottenPasswordTime,
    this.rememberCode,
    this.createdOn,
    this.lastLogin,
    this.active,
    this.firstName,
    this.lastName,
    this.company,
    this.phone,
    this.hospitalIonId,
    this.emailActive,
    this.imageUrl,
    this.patientId,
  });

  int id;
  String ipAddress;
  String username;
  String password;
  dynamic salt;
  String email;
  dynamic activationCode;
  dynamic forgottenPasswordCode;
  dynamic forgottenPasswordTime;
  dynamic rememberCode;
  String createdOn;
  String lastLogin;
  String active;
  dynamic firstName;
  dynamic lastName;
  dynamic company;
  String phone;
  String hospitalIonId;
  String emailActive;
  String imageUrl;
  String patientId;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    id: json["id"],
    ipAddress: json["ip_address"],
    username: json["username"],
    password: json["password"],
    salt: json["salt"],
    email: json["email"],
    activationCode: json["activation_code"],
    forgottenPasswordCode: json["forgotten_password_code"],
    forgottenPasswordTime: json["forgotten_password_time"],
    rememberCode: json["remember_code"],
    createdOn: json["created_on"],
    lastLogin: json["last_login"],
    active: json["active"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    company: json["company"],
    phone: json["phone"],
    hospitalIonId: json["hospital_ion_id"],
    emailActive: json["email_active"],
    imageUrl: json["image_url"],
    patientId: json["patient_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ip_address": ipAddress,
    "username": username,
    "password": password,
    "salt": salt,
    "email": email,
    "activation_code": activationCode,
    "forgotten_password_code": forgottenPasswordCode,
    "forgotten_password_time": forgottenPasswordTime,
    "remember_code": rememberCode,
    "created_on": createdOn,
    "last_login": lastLogin,
    "active": active,
    "first_name": firstName,
    "last_name": lastName,
    "company": company,
    "phone": phone,
    "hospital_ion_id": hospitalIonId,
    "email_active": emailActive,
    "image_url": imageUrl,
    "patient_id": patientId,
  };
}
