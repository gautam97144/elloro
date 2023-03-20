import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/screen/bottom_navigation/bottom_navigation.dart';
import 'package:elloro/widget/custom_large_yellow_button.dart';
import 'package:elloro/widget/custom_padding.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sizer/sizer.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return CustomPadding(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
                width: 100,
                height: 100,
                //color: Colors.green,
                child: Image.asset(Images.thankYouImage)),
          ),
          SizedBox(
            height: 6.5.h,
          ),
          thankyouBanner(),
          SizedBox(
            height: 4.h,
          ),
          continueButton(),
        ],
      ),
    );
  }

  Widget continueButton() {
    return CustomLargeButton(
      onPressed: () {
        Get.to(BottomNavigation());
      },
      title: Text(
        StringConstant.Continue,
        style: CustomTextStyle.body2,
      ),
    );
  }

  Widget thankyouBanner() {
    return Text(
      StringConstant.thankYouMessage,
      style: CustomTextStyle.body1,
      textAlign: TextAlign.center,
    );
  }
}
