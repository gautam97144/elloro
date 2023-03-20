import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomPlayNowButton extends StatelessWidget {
  Function()? onPressed;
  CustomPlayNowButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          alignment: Alignment.center,
          height: 4.5.h,
          width: 28.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.play_circle_filled,
                color: AppColor.white,
              ),
              Text(
                StringConstant.playNow,
                style: CustomTextStyle.body1.copyWith(fontSize: 10.sp),
              )
            ],
          ),
          decoration: const ShapeDecoration(
            shape: StadiumBorder(
                side: BorderSide(width: 2, color: AppColor.white)),
          )),
    );
  }
}
