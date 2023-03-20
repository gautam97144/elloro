import 'package:dio/dio.dart';
import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/model/user_register_model.dart';
import 'package:elloro/provider/internet_connectivity.dart';
import 'package:elloro/provider/provider.dart';
import 'package:elloro/screen/loader/loader.dart';
import 'package:elloro/screen/version_screen/internet_connectivity/second_screen.dart';
import 'package:elloro/services/auth_service.dart';
import 'package:elloro/validation/validation.dart';
import 'package:elloro/widget/custom_large_yellow_button.dart';
import 'package:elloro/widget/custom_padding.dart';
import 'package:elloro/widget/custom_profile_picture.dart';
import 'package:elloro/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool obscureTextConfirmPassword = true;
  bool obscureTextNewPassword = true;
  final formkey = GlobalKey<FormState>();

  UserRegisterModel? user;
  bool? isLoader = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    user = Provider.of<UserProvider>(context, listen: false).getUser!;
    // gettoken();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: AppColor.black));

    return Stack(children: [
      GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.black,
              appBar: AppBar(
                //titleSpacing: 10,
                title: Text(
                  StringConstant.changePassword,
                  style: CustomTextStyle.headline2,
                ),
                backgroundColor: AppColor.black,
                actions: [
                  Padding(
                      padding: EdgeInsets.only(right: 4.w),
                      child: Row(children: [
                        CustomProfilePicture(
                          url: user?.image ?? "",
                        ),
                      ])),
                ],
              ),
              body: SingleChildScrollView(
                child: CustomPadding(
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          StringConstant.oldPassword,
                          style: CustomTextStyle.body1,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        oldPasswordField(),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          StringConstant.newPassword,
                          style: CustomTextStyle.body1,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        newPasswordField(),
                        SizedBox(
                          height: 1.h,
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          StringConstant.confirmPassword,
                          style: CustomTextStyle.body1,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        confirmPasswordField(),
                        SizedBox(
                          height: 3.h,
                        ),
                        submitbutton(),
                      ],
                    ),
                  ),
                ),
              )),
        ),
      ),
      Provider.of<InternetConnectivityCheck>(context, listen: true).isNoInternet
          ? const NoInternetSecond()
          : const SizedBox.shrink(),
      isLoader == true ? const CustomLoader() : const SizedBox.shrink()
    ]);
  }

  Widget oldPasswordField() {
    return CustomInPutField(
      validator: (value) => Validation.passwordValidation(value!),
      fieldController: oldPasswordController,
      hint: StringConstant.oldPasswordHintText,
      hintStyle: CustomTextStyle.body4,
    );
  }

  Widget newPasswordField() {
    return CustomInPutField(
        validator: (value) => Validation.validatePassword(value!),
        fieldController: newPasswordController,
        obscureText: obscureTextNewPassword,
        suffixIcon: suffixIconOfNewPassword(),
        hint: StringConstant.newPasswordHintText,
        hintStyle: CustomTextStyle.body4);
  }

  Widget confirmPasswordField() {
    return CustomInPutField(
        validator: (value) => confirmPasswordValidation(value!),
        fieldController: confirmPasswordController,
        obscureText: obscureTextConfirmPassword,
        suffixIcon: suffixIconOfConfirmPassword(),
        hint: StringConstant.confirmPasswordHintText,
        hintStyle: CustomTextStyle.body4);
  }

  Widget submitbutton() {
    return CustomLargeButton(
      title: Text(
        StringConstant.submit,
        style: CustomTextStyle.body2,
      ),
      onPressed: () async {
        if (formkey.currentState!.validate()) {
          FormData userdata = FormData.fromMap({
            "old_password": oldPasswordController.text,
            "new_password": newPasswordController.text
          });

          setState(() {
            isLoader = true;
            FocusScope.of(context).unfocus();
          });
          await ApiService().changePassword(
              context: context, data: userdata, loginModel: user!);

          setState(() {
            isLoader = false;
          });
        }
      },
    );
  }

  Widget suffixIconOfConfirmPassword() {
    return IconButton(
      color: AppColor.grey,
      icon: obscureTextConfirmPassword == true
          ? Icon(
              Icons.visibility_off,
            )
          : Icon(
              Icons.visibility,
            ),
      onPressed: () {
        setState(() {
          obscureTextConfirmPassword = !obscureTextConfirmPassword;
        });
      },
    );
  }

  Widget suffixIconOfNewPassword() {
    return IconButton(
      color: AppColor.grey,
      icon: obscureTextNewPassword == true
          ? Icon(
              Icons.visibility_off,
            )
          : Icon(
              Icons.visibility,
            ),
      onPressed: () {
        setState(() {
          obscureTextNewPassword = !obscureTextNewPassword;
        });
      },
    );
  }

  confirmPasswordValidation(String value) {
    if (value.isEmpty) {
      return "Please enter your confirm password";
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      return "Confirm Password does not match";
    }

    return null;
  }
}
