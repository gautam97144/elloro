import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/appconstant/app_theme.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/model/login_model.dart';
import 'package:elloro/provider/internet_connectivity.dart';
import 'package:elloro/screen/forgot_password/forgot_password.dart';
import 'package:elloro/screen/loader/loader.dart';
import 'package:elloro/screen/sign_up_screen/sign_up.dart';
import 'package:elloro/screen/version_screen/internet_connectivity/second_screen.dart';
import 'package:elloro/services/auth_service.dart';
import 'package:elloro/validation/validation.dart';
import 'package:elloro/widget/custom_large_yellow_button.dart';
import 'package:elloro/widget/custom_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:dio/dio.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoader = false;
  final formkey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool obscureTextNewPassword = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(children: [
        Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
              child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 24, left: 24),
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 1.h,
                    ),
                    Stack(children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            elloroLogo(),
                            loginBanner(),
                          ],
                        ),
                      ),
                      Positioned(
                          right: -100,
                          child: Image.asset(
                            Images.soundwave,
                            width: 230,
                            height: 200,
                          ))
                    ]),
                    SizedBox(
                      height: 3.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 24),
                      child: Text(
                        StringConstant.emailAddress,
                        style: CustomTextStyle.body1,
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 24),
                      child: emailField(),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      StringConstant.password,
                      style: CustomTextStyle.body1,
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Padding(
                        padding: EdgeInsets.only(right: 24),
                        child: passwordField()),
                    SizedBox(
                      height: 1.h,
                    ),
                    Padding(
                        padding: EdgeInsets.only(right: 24),
                        child: forgotPasswordBanner()),
                    SizedBox(
                      height: 4.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 24),
                      child: loginbutton(context),
                    ),
                  ],
                ),
              ),
            ),
          )),
          bottomNavigationBar: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: noLoginBanner())
              ]),
        ),Provider.of<InternetConnectivityCheck>(context, listen: true).isNoInternet
            ? const NoInternetSecond()
            : const SizedBox.shrink(),
        isLoader == true ?const CustomLoader() :const SizedBox.shrink()
      ]),
    );
  }

  Widget noLoginBanner() {
    return RichText(
      text: TextSpan(
          text: StringConstant.noAccount,
          style: CustomTextStyle.body3.copyWith(color: AppColor.white),
          children: [
            TextSpan(
                text: StringConstant.ragistor,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()),
                        )
                      },
                style: CustomTextStyle.body3
                    .copyWith(color: AppColor.primarycolor))
          ]),
    );
  }

  Widget elloroLogo() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
          //color: Colors.red,
          width: 50.w,
          height: 20.h,
          child: Image.asset(Images.logo)),
      SizedBox(
        width: 5.w,
      ),
    ]);
  }

  Widget loginBanner() {
    return Text(StringConstant.login, style: CustomTextStyle.headline);
  }

  Widget emailField() {
    return CustomInPutField(
      validator: (value) => Validation.emailValidate(value!),
      fieldController: emailController,
      hint: StringConstant.emailHintText,
      hintStyle: CustomTextStyle.body4,
    );
  }

  Widget passwordField() {
    return CustomInPutField(
      validator: (value) => Validation.passwordValidation(value!),
      fieldController: passwordController,
      obscureText: obscureTextNewPassword,
      suffixIcon: suffixIconOfNewPassword(),
      hint: StringConstant.passwordHintText,
      hintStyle: CustomTextStyle.body4,
    );
  }

  Widget forgotPasswordBanner() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          child: GestureDetector(
            onTap: () {
              Get.to(() => ForgotPassword());
            },
            child: Text(
              StringConstant.forgotPassword,
              style: CustomTextStyle.body1,
            ),
          ),
        ),
      ],
    );
  }

  Widget loginbutton(BuildContext context) {
    return CustomLargeButton(
      title: Text(
        StringConstant.login,
        style: CustomTextStyle.body2,
      ),
      onPressed: () async {
        if (formkey.currentState!.validate()) {
          FormData data = FormData.fromMap({
            "email": emailController.text,
            "password": passwordController.text
          });

          setState(() {
            isLoader = true;
          });

          FocusScope.of(context).unfocus();

          LoginModel? loginData =
              await ApiService().loginUser(context: context, data: data);

          setState(() {
            isLoader = false;
          });
          print(loginData?.toJson().toString());
        }
      },
    );
  }

  Widget suffixIconOfNewPassword() {
    return IconButton(
      color: AppColor.grey,
      icon: obscureTextNewPassword == true
          ? const Icon(
              Icons.visibility_off,
            )
          :const Icon(
              Icons.visibility,
            ),
      onPressed: () {
        setState(() {
          obscureTextNewPassword = !obscureTextNewPassword;
        });
      },
    );
  }
}
