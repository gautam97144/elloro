import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class InternetConnectivity extends StatelessWidget {
  const InternetConnectivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "No Internet",
              style: CustomTextStyle.body1
                  .copyWith(color: AppColor.grey, fontSize: 18.sp),
            ),
          ),
          Center(
            child: Text(
              "A connection is required to access the catalogue",
              style: CustomTextStyle.body1.copyWith(color: AppColor.grey),
            ),
          )
        ],
      ),
    );
  }
}
