class LoginResponse {
  bool status;
  String message;
  Null accessToken;
  UserInfo userInfo;

  LoginResponse({this.status, this.message, this.accessToken, this.userInfo});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    accessToken = json['access_token'];
    userInfo = json['user_info'] != null
        ? new UserInfo.fromJson(json['user_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['access_token'] = this.accessToken;
    if (this.userInfo != null) {
      data['user_info'] = this.userInfo.toJson();
    }
    return data;
  }
}

class UserInfo {
  int id;
  String ipAddress;
  String username;
  String password;
  Null salt;
  String email;
  Null activationCode;
  Null forgottenPasswordCode;
  Null forgottenPasswordTime;
  Null rememberCode;
  String createdOn;
  String lastLogin;
  String active;
  Null firstName;
  Null lastName;
  Null company;
  Null phone;
  String hospitalIonId;
  String imageUrl;
  String ion_user_id;
  String patient_id;

  UserInfo(
      {this.id,
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
        this.imageUrl,
        this.ion_user_id,
        this.patient_id});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ipAddress = json['ip_address'];
    username = json['username'];
    password = json['password'];
    salt = json['salt'];
    email = json['email'];
    activationCode = json['activation_code'];
    forgottenPasswordCode = json['forgotten_password_code'];
    forgottenPasswordTime = json['forgotten_password_time'];
    rememberCode = json['remember_code'];
    createdOn = json['created_on'];
    lastLogin = json['last_login'];
    active = json['active'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    company = json['company'];
    phone = json['phone'];
    hospitalIonId = json['hospital_ion_id'];
    imageUrl = json['image_url'];
    ion_user_id = json['ion_user_id'];
    patient_id = json['patient_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ip_address'] = this.ipAddress;
    data['username'] = this.username;
    data['password'] = this.password;
    data['salt'] = this.salt;
    data['email'] = this.email;
    data['activation_code'] = this.activationCode;
    data['forgotten_password_code'] = this.forgottenPasswordCode;
    data['forgotten_password_time'] = this.forgottenPasswordTime;
    data['remember_code'] = this.rememberCode;
    data['created_on'] = this.createdOn;
    data['last_login'] = this.lastLogin;
    data['active'] = this.active;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['company'] = this.company;
    data['phone'] = this.phone;
    data['hospital_ion_id'] = this.hospitalIonId;
    data['image_url'] = this.imageUrl;
    data['ion_user_id'] = this.ion_user_id;
    data['patient_id'] = this.patient_id;
    return data;
  }
}