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
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:sizer/sizer.dart';

import 'onbording_one.dart';
import 'onbording_three.dart';

class SecondOnBording extends StatefulWidget {
  const SecondOnBording({Key? key}) : super(key: key);

  @override
  _SecondOnBordingState createState() => _SecondOnBordingState();
}

class _SecondOnBordingState extends State<SecondOnBording> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Images.onbordingTwo), fit: BoxFit.fill)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Spacer(flex: 3),
              Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(SignUpScreen());
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              StringConstant.onBordingTwo,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: CustomTextStyle.fontFamilyAvenir),
                            ),
                            // SizedBox(
                            //   height: 6.h,
                            // ),
                            Text(
                              StringConstant.onBordingTwoSubtitle,
                              style: CustomTextStyle.body4.copyWith(
                                  color: AppColor.white,
                                  fontWeight: FontWeight.w300),
                              textAlign: TextAlign.center,
                            ),
                            // SizedBox(
                            //   height: 4.h,
                            // ),
                            SvgPicture.asset(AppIcon.secondIndicator),
                            // Spacer(),
                            CoustomSmallButton(
                              title: 'Next',
                              onPressed: () {
                                Get.to(ThirdOnBording());
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
