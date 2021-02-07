class DoctorLoginModel {
  bool status;
  String message;
  Null accessToken;
  UserInfo userInfo;

  DoctorLoginModel(
      {this.status, this.message, this.accessToken, this.userInfo});

  DoctorLoginModel.fromJson(Map<String, dynamic> json) {
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
  String phone;
  String hospitalIonId;
  String emailActive;
  String imageUrl;
  String ionUserId;

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
        this.emailActive,
        this.imageUrl,
        this.ionUserId});

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
    emailActive = json['email_active'];
    imageUrl = json['image_url'];
    ionUserId = json['ion_user_id'];
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
    data['email_active'] = this.emailActive;
    data['image_url'] = this.imageUrl;
    data['ion_user_id'] = this.ionUserId;
    return data;
  }
}