import 'package:elloro/appconstant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomTextStyle {
  static String fontFamilyAvenir = "Avenir";
  static String fontFamilyMontserrat = "Montserrat";

  static TextStyle headline = TextStyle(
      color: AppColor.white,
      fontFamily: fontFamilyMontserrat,
      fontWeight: FontWeight.w700,
      fontSize: 24.sp);

  static TextStyle headline2 = TextStyle(
      color: AppColor.white,
      fontFamily: fontFamilyAvenir,
      fontWeight: FontWeight.w900,
      fontSize: 18.sp);

  static TextStyle body1 = TextStyle(
      color: AppColor.white,
      fontFamily: fontFamilyAvenir,
      fontWeight: FontWeight.w400,
      fontSize: 12.sp);

  static TextStyle body2 = TextStyle(
      color: AppColor.black,
      fontFamily: fontFamilyAvenir,
      fontWeight: FontWeight.w800,
      fontSize: 14.sp);

  static TextStyle body3 = TextStyle(
      color: AppColor.white,
      fontFamily: fontFamilyAvenir,
      fontWeight: FontWeight.w400,
      fontSize: 14.sp);

  static TextStyle body4 = TextStyle(
      color: AppColor.grey,
      fontFamily: fontFamilyAvenir,
      fontWeight: FontWeight.w400,
      fontSize: 12.sp);

  static TextStyle body5 = TextStyle(
      color: AppColor.white,
      fontFamily: fontFamilyAvenir,
      fontWeight: FontWeight.w400,
      fontSize: 14.sp);

  static TextStyle body6 = TextStyle(
      color: AppColor.blue,
      fontFamily: fontFamilyAvenir,
      fontWeight: FontWeight.w400,
      fontSize: 9.sp);

  static TextStyle body7 = TextStyle(
      color: AppColor.primarycolor,
      fontFamily: fontFamilyAvenir,
      fontWeight: FontWeight.w800,
      fontSize: 12.sp);
}
