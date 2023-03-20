import 'package:dio/dio.dart';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/model/login_model.dart';
import 'package:elloro/screen/forgot_password/forgot_password.dart';
import 'package:elloro/services/auth_service.dart';
import 'package:elloro/validation/validation.dart';
import 'package:elloro/widget/custom_large_yellow_button.dart';
import 'package:elloro/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:sizer/sizer.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final formkey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool obscureTextNewPassword = true;
  var isLoader = false.obs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
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
                      ellorologo(),
                      loginbanner(),
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
                child: emailfield(),
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
                  padding: EdgeInsets.only(right: 24), child: passwordfield()),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                  padding: EdgeInsets.only(right: 24),
                  child: forgotpasswordbanner()),
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
    );
  }

  Widget ellorologo() {
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

  Widget loginbanner() {
    return Text(StringConstant.login, style: CustomTextStyle.headline);
  }

  Widget emailfield() {
    return CustomInPutField(
      validator: (value) => Validation.emailValidate(value!),
      fieldController: emailController,
      hint: StringConstant.emailHintText,
      hintStyle: CustomTextStyle.body4,
    );
  }

  Widget passwordfield() {
    return CustomInPutField(
      validator: (value) => Validation.passwordValidation(value!),
      fieldController: passwordController,
      obscureText: obscureTextNewPassword,
      suffixIcon: suffixIconOfNewPassword(),
      hint: StringConstant.passwordHintText,
      hintStyle: CustomTextStyle.body4,
    );
  }

  Widget forgotpasswordbanner() {
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

          isLoader.value = true;

          FocusScope.of(context).unfocus();

          LoginModel logindata =
              await ApiService().loginUser(context: context, data: data);

          isLoader.value = false;

          print(logindata.toJson().toString());
        }
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
}
