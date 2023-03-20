import 'package:elloro/appconstant/app_color.dart';
import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData themeData(BuildContext context) => ThemeData(
        appBarTheme: AppBarTheme(
          color: AppColor.black,
          elevation: 0,
        ),
      );
}
