class GetUserData {
  int? success;
  Data? data;
  String? message;

  GetUserData({this.success, this.data, this.message});

  GetUserData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? userId;
  String? uniqueId;
  String? name;
  String? email;
  String? password;
  String? image;
  String? referralCode;
  String? deviceToken;
  String? apiToken;
  String? refreshToken;
  String? tokenCreatedAt;
  String? expiredAt;
  String? otp;
  String? totalToken;
  int? status;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.userId,
      this.uniqueId,
      this.name,
      this.email,
      this.password,
      this.image,
      this.referralCode,
      this.deviceToken,
      this.apiToken,
      this.refreshToken,
      this.tokenCreatedAt,
      this.expiredAt,
      this.otp,
      this.totalToken,
      this.status,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    uniqueId = json['unique_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    image = json['image'];
    referralCode = json['referral_code'];
    deviceToken = json['device_token'];
    apiToken = json['api_token'];
    refreshToken = json['refresh_token'];
    tokenCreatedAt = json['token_created_at'];
    expiredAt = json['expired_at'];
    otp = json['otp'];
    totalToken = json['total_token'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['unique_id'] = this.uniqueId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['image'] = this.image;
    data['referral_code'] = this.referralCode;
    data['device_token'] = this.deviceToken;
    data['api_token'] = this.apiToken;
    data['refresh_token'] = this.refreshToken;
    data['token_created_at'] = this.tokenCreatedAt;
    data['expired_at'] = this.expiredAt;
    data['otp'] = this.otp;
    data['total_token'] = this.totalToken;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
