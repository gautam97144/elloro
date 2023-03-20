import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:flutter/material.dart';

class GlobalSnackBar {
  final String message;

  const GlobalSnackBar({
    required this.message,
  });

  static show(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColor.black,
        content: Text(
          message,
          style: CustomTextStyle.body1.copyWith(color: AppColor.primarycolor),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
