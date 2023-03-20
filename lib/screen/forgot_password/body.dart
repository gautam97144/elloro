import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/screen/forgot_password/forgot_password.dart';
import 'package:elloro/screen/thank_you_screen/thank_you_screen.dart';
import 'package:elloro/widget/custom_large_yellow_button.dart';
import 'package:elloro/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class BodyForgotPassword {
  TextEditingController emailcontroller = TextEditingController();
  static Widget emailAddressBanner() {
    return Text(
      StringConstant.emailAddress,
      style: CustomTextStyle.body1,
    );
  }

  // static Widget sendEmailButton() {
  //   return
  //
  // }
}
