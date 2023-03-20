import 'package:elloro/model/login_model.dart';
import 'package:elloro/model/user_register_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserRegisterModel user = UserRegisterModel();

  get getUser => user;

  setUser({required UserRegisterModel currentUser}) {
    this.user = currentUser;
    notifyListeners();
  }
}
