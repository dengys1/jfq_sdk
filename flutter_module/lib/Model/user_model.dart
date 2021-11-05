class UserModel {
  final String today_first_login;
  final String redbag;
  final String login_id;
  final String token;
  final String uid;
  // final String code;
  // final String udid;
  final Map bind;
  int is_bind_phone = 0;
  String is_bind_udid = "0";
  int is_bind_wx = 0;

  UserModel(
      {this.today_first_login,
      this.redbag,
      this.login_id,
      this.token,
      this.uid,
      // this.code,
      // this.udid,
      this.bind,
      this.is_bind_phone,
      this.is_bind_udid,
      this.is_bind_wx});

  factory UserModel.fromJson(Map json) {
    return UserModel(
      today_first_login: json['today_first_login'].toString(),
      redbag: json['redbag'].toString(),
      login_id: json['login_id'].toString(),
      token: json['token'].toString(),
      uid: json['uid'].toString(),
      // code: json['code'].toString(),
      // udid: json['udid'].toString(),
      bind: json['bind'],
      is_bind_phone: json['bind']['is_bind_phone'],
      is_bind_udid: json['bind']['is_bind_udid'].toString(),
      is_bind_wx: json['bind']['is_bind_wx'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['today_first_login'] = this.today_first_login;
    data['redbag'] = this.redbag;
    data['login_id'] = this.login_id;
    data['token'] = this.token;
    data['uid'] = this.uid;
    // data['code'] = this.code;
    // data['udid'] = this.udid;
    data['bind'] = this.bind;
    data['is_bind_phone'] = this.is_bind_phone;
    data['is_bind_udid'] = this.is_bind_udid;
    data['is_bind_wx'] = this.is_bind_wx;
    return data;
  }
}
