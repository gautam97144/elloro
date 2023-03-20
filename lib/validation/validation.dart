import 'package:flutter/material.dart';

class Validation {
  static nameValidation(String value) {
    if (value == "") {
      return "please enter your name";
    }
    return null;
  }

  static emailValidation(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(pattern);

    if (value == "") {
      return "please enter your emailAddress";
    } else if (!regExp.hasMatch(value)) {
      return "please enter valid email";
    }

    return null;
  }

  static String? validatePassword(String value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please enter password';
    }
    if (value.length < 6) {
      return "your password is too short";
    }

    // } else {
    //   if (!regex.hasMatch(value)) {
    //     return 'Enter valid password';
    //   } else {
    //     return null;
    //   }
  }

  static passwordValidation(String value) {
    if (value == "") {
      return "please enter  password";
    }
    return null;
  }

  static emailValidate(String value) {
    if (value.isEmpty) {
      return "Please enter your email";
    }
    return null;
  }
}
