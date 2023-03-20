import 'package:flutter/material.dart';

class TokenModel {
  int? id;
  String? token;
  String? profileImage;

  TokenModel({this.token, this.profileImage, this.id});

  TokenModel.fromJson(Map<String, dynamic> json) {
    profileImage = json['profileImage'];
    id = json['id'];
    token = json['token'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileImage'] = this.profileImage;
    data['id'] = this.id;
    data['token'] = this.token;
    return data;
  }
}
