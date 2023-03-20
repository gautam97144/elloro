import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_icon.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/widget/my_popUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'custom_small_black_button.dart';
import 'custom_small_yellow_button.dart';

class MyButton {
  NumberFormat format = NumberFormat.simpleCurrency(locale: "mnt");

  static Widget playButton(context) {
    return Container(
      width: 36.w,
      child: Row(children: [
        Container(
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
        Spacer(),
        cancleButton(context),
      ]),
    );
  }

  static Widget cancleButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MyPopUp().removeAudioPopUp(context);
      },
      child: Icon(
        Icons.cancel_outlined,
        color: AppColor.grey,
        size: 3.5.h,
      ),
    );
  }

  static Widget moreBanner() {
    return SizedBox(
      width: 9.w,
      height: 3.2.h,
      child: TextButton(
          onPressed: () {},
          style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.all(.2.h)),
              backgroundColor: MaterialStateProperty.all(Colors.black),
              foregroundColor: MaterialStateProperty.all(AppColor.grey),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
              side: MaterialStateProperty.all(BorderSide(
                  color: AppColor.grey, width: 2, style: BorderStyle.solid))),
          child: Icon(
            Icons.more_horiz,
            color: AppColor.grey,
          )

          // Text(
          //   "...",
          //   style: CustomTextStyle.body4
          //       .copyWith(fontSize: 15, fontWeight: FontWeight.w900),
          // ),
          ),
    );
  }

  static Widget ratingAndCount() {
    return Container(
      // color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star,
            size: 2.2.h,
            color: AppColor.primarycolor,
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              "5",
              style: CustomTextStyle.body4.copyWith(fontSize: 11.sp),
            ),
          ),
        ],
      ),
    );
  }

  static Widget downloadButton() {
    return SizedBox(
      height: 4.5.h,
      width: 28.w,
      child: TextButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(StadiumBorder()),
            side: MaterialStateProperty.all(BorderSide(
                color: AppColor.primarycolor,
                width: 2,
                style: BorderStyle.solid))),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(AppIcon.downloadNow),
            Text(
              StringConstant.downloadNow,
              style: CustomTextStyle.body6
                  .copyWith(fontSize: 10.sp)
                  .copyWith(color: AppColor.primarycolor),
            ),
          ],
        ),
      ),
    );
  }

  Widget tokenButton(String token) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        constraints: BoxConstraints(minWidth: 19.w),
        alignment: Alignment.center,
        height: 4.5.h,
        //  width: 19.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
                colors: [AppColor.pink, AppColor.primarycolor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight)),
        child: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "${format.currencySymbol}",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(
              width: 2,
            ),
            Text(token
                // StringConstant.tokenText,
                // style:
                // CustomTextStyle.body3.copyWith(fontWeight: FontWeight.w500)
                ),
          ]),
        ));
  }

  Widget priceBanner(context) {
    return GestureDetector(
      onTap: () {
        // FocusScope.of(context).unfocus();
        //  MyPopUp().detailPopUpOfPurchase(context);
      },
      child: Container(
        alignment: Alignment.center,
        height: 5.h,
        width: 20.w,
        decoration: const ShapeDecoration(
          shape:
              StadiumBorder(side: BorderSide(width: 2, color: AppColor.blue)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(format.currencySymbol,
                style: TextStyle(color: AppColor.blue, fontSize: 12.sp)),
          ),
          Text(
            StringConstant.two + StringConstant.get,
            style: CustomTextStyle.body6.copyWith(fontSize: 12.sp),
          ),
        ]),
      ),
    );
  }

  static Widget purchasedButton() {
    return SizedBox(
      width: 30.w,
      child: SizedBox(
        height: 5.h,
        //width: 37.w,
        child: TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(const StadiumBorder()),
              side: MaterialStateProperty.all(const BorderSide(
                  color: AppColor.white, width: 2, style: BorderStyle.solid))),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.check_circle_outlined,
                color: Colors.white,
              ),
              Text(
                StringConstant.purchased,
                style: CustomTextStyle.body6
                    .copyWith(fontSize: 10.sp)
                    .copyWith(color: AppColor.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget popButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        CoustomSmallBlackButton(
          onPressed: () {
            Get.back();
          },
          title: StringConstant.cancel,
          style: CustomTextStyle.body1
              .copyWith(fontFamily: CustomTextStyle.fontFamilyMontserrat),
        ),
        CoustomSmallButton(
          onPressed: () {},
          title: StringConstant.yes,
          style: CustomTextStyle.body1.copyWith(
              color: AppColor.black,
              fontWeight: FontWeight.w600,
              fontFamily: CustomTextStyle.fontFamilyMontserrat),
        )
      ],
    );
  }
}
