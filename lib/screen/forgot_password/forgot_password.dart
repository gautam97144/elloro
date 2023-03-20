import 'package:dio/dio.dart';
import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/model/forgot_password_model.dart';
import 'package:elloro/provider/internet_connectivity.dart';
import 'package:elloro/screen/forgot_password/body.dart';
import 'package:elloro/screen/loader/loader.dart';
import 'package:elloro/screen/version_screen/internet_connectivity/second_screen.dart';
import 'package:elloro/services/auth_service.dart';
import 'package:elloro/validation/validation.dart';
import 'package:elloro/widget/custom_large_yellow_button.dart';
import 'package:elloro/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formkey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  var isLoader = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(children: [
          SafeArea(
            child: Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  toolbarHeight: 12.h,
                  title: Text(StringConstant.forgotpassword,
                      style: CustomTextStyle.headline2),
                  backgroundColor: Colors.black,
                  elevation: 0,
                ),
                body: Form(
                  key: formkey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        BodyForgotPassword.emailAddressBanner(),
                        SizedBox(
                          height: 1.h,
                        ),
                        emailField(),
                        SizedBox(
                          height: 24,
                        ),
                        sendEmailButton(),
                      ],
                    ),
                  ),
                )),
          ),
          Provider.of<InternetConnectivityCheck>(context, listen: true)
                  .isNoInternet
              ? const NoInternetSecond()
              : const SizedBox.shrink(),
          isLoader == true ? const CustomLoader() : const SizedBox.shrink()
        ]));
  }

  Widget sendEmailButton() {
    return CustomLargeButton(
      title: Text(
        StringConstant.buttonText,
        style: CustomTextStyle.body2,
      ),
      onPressed: () async {
        if (formkey.currentState!.validate()) {
          if (mounted) {
            setState(() {
              isLoader = true;
              FocusScope.of(context).unfocus();
            });
          }

          FormData data = FormData.fromMap({"email": emailController.text});

          // setState(() {

          // });

          ForgotPasswordModel? forgotPasswordModel =
              await ApiService().forgotPassword(context: context, data: data);

          if (mounted) {
            setState(() {
              isLoader = false;
            });
          }

          print(forgotPasswordModel?.toJson().toString());
          // print(ForgotPassword().islod);
        } // Get.to(() => ThankYouScreen());
      },
    );
  }

  Widget emailField() {
    return CustomInPutField(
        validator: (value) => Validation.emailValidate(value!),
        fieldController: emailController,
        hint: StringConstant.emailHintText,
        hintStyle: CustomTextStyle.body4);
  }
}
