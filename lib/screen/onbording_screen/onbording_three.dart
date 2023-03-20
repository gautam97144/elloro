import 'dart:ui';

import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_icon.dart';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/screen/login_screen/login_screen.dart';
import 'package:elloro/screen/sign_up_screen/sign_up.dart';
import 'package:elloro/widget/custom_small_yellow_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:sizer/sizer.dart';

class ThirdOnBording extends StatefulWidget {
  const ThirdOnBording({Key? key}) : super(key: key);

  @override
  _ThirdOnBordingState createState() => _ThirdOnBordingState();
}

class _ThirdOnBordingState extends State<ThirdOnBording> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Images.thirdOnBording), fit: BoxFit.fill)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Spacer(flex: 3),
              Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(LoginScreen());
                    },
                    child: Text(
                      StringConstant.skip,
                      style: CustomTextStyle.body1
                          .copyWith(fontSize: 14.sp, color: Colors.black),
                    ),
                  ),
                ]),
              ),
              Spacer(
                flex: 8,
              ),
              GlassmorphicContainer(
                borderRadius: 45,
                linearGradient: LinearGradient(colors: [
                  Colors.black.withOpacity(.3),
                  Colors.black.withOpacity(.3)
                ]),
                borderGradient:
                    LinearGradient(colors: [Colors.yellow, Colors.yellow]),
                height: 45.h,
                border: 0,
                width: double.infinity,
                blur: 5,
                child: Stack(children: [
                  Positioned(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 25),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              StringConstant.onBordingThreeSubtitle,
                              style: CustomTextStyle.body4.copyWith(
                                  color: AppColor.white,
                                  fontWeight: FontWeight.w300),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              "Welcome to Elloro",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: CustomTextStyle.fontFamilyAvenir),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            SvgPicture.asset(AppIcon.thirdIndicator),
                            Spacer(),
                            CoustomSmallButton(
                              title: 'Next',
                              onPressed: () {
                                Get.to(SignUpScreen());
                              },
                            )
                          ]),
                    ),
                  ),
                ]),
              )
            ],
          )),
    );
  }
}
