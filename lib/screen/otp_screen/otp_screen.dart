import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/screen/loader/loader.dart';
import 'package:elloro/services/auth_service.dart';
import 'package:elloro/widget/custom_large_yellow_button.dart';
import 'package:elloro/widget/custom_padding.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:sizer/sizer.dart';

class OtpScreen extends StatefulWidget {
  String? userid;
  OtpScreen({Key? key, this.userid}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? controller;
  bool isValidate = false;
  bool isLoader = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
          backgroundColor: Colors.black,
          body: CustomPadding(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8.h,
                ),
                headingBanner(),
                SizedBox(
                  height: 4.h,
                ),
                otpTextField(),
                SizedBox(
                  height: 4.h,
                ),
                submitButton(),
                SizedBox(
                  height: 4.h,
                ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      isLoader = true;
                    });
                    await ApiService()
                        .resendOtp(context: context, data: data());
                    setState(() {
                      isLoader = false;
                    });
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Resend Otp",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: AppColor.primarycolor),
                    ),
                  ),
                )
              ],
            ),
          )),
      isLoader == true ? const CustomLoader() : const SizedBox.shrink()
    ]);
  }

  FormData data() {
    return FormData.fromMap({"user_id": widget.userid});
  }

  Widget headingBanner() {
    return Text(
      StringConstant.otpSend,
      style: CustomTextStyle.headline2,
    );
  }

  Widget otpTextField() {
    return OtpTextField(
        keyboardType: TextInputType.number,
        cursorColor: AppColor.primarycolor,
        numberOfFields: 4,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        fieldWidth: 10.w,
        showFieldAsBox: true,
        textStyle: const TextStyle(fontSize: 14, color: AppColor.primarycolor),
        focusedBorderColor: AppColor.primarycolor,
        enabledBorderColor: AppColor.grey,
        fillColor: Colors.transparent,
        filled: true,
        borderRadius: BorderRadius.circular(5),
        onSubmit: (pin) {
          controller = pin;
        });
  }

  Widget submitButton() {
    return CustomLargeButton(
      onPressed: () async {
        if (controller == null) {
          return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Please your enter otp"),
            backgroundColor: Colors.red,
          ));
        } else {
          setState(() {
            isLoader = true;
          });

          FormData data =
              FormData.fromMap({"user_id": widget.userid, "otp": controller});

          await ApiService().verifyUser(context: context, data: data);

          setState(() {
            isLoader = false;
          });
        }
      },
      title: Text(
        StringConstant.submit,
        style: CustomTextStyle.body2,
      ),
    );
  }
}
