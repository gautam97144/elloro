import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_icon.dart';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/screen/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'custom_button.dart';
import 'custom_dialog.dart';
import 'package:get/get.dart';

import 'custom_small_black_button.dart';
import 'custom_small_yellow_button.dart';

class MyPopUp {
  Future detailPopUp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopUp(
            content: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                cancelButtonPopUp(),
                imageAndMusicTitle(),
                SizedBox(
                  height: 2.h,
                ),
                SizedBox(
                  height: 2.h,
                ),

                sizeAndDurationTitle(),
                SizedBox(height: 2.h),
                aboutSong(),
                SizedBox(
                  height: 2.h,
                ),
                aboutCreatorBanner(),
                SizedBox(
                  height: 1.h,
                ),
                aboutCreator(),

                //image(),
                SizedBox(height: 3.h),
              ]),
        ));
      },
    );
  }

  Future specialOfferPopUp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: AppColor.black,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                      //mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          StringConstant.specialoffer,
                          style: CustomTextStyle.body1.copyWith(
                              fontWeight: FontWeight.w900, fontSize: 16.sp),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.cancel_outlined,
                            color: AppColor.grey,
                            // size: 3.5.h,
                          ),
                        ),
                      ]),
                  SizedBox(
                    height: 3.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 10.h,
                          //color: Colors.blue,
                          child: Row(
                            children: [
                              Container(
                                // color: Colors.red,
                                child: Image.asset(
                                  Images.popUpImage,
                                  // scale: 3,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      StringConstant.salam,
                                      style: CustomTextStyle.body1,
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Text(
                                      StringConstant.yasinSkekh,
                                      style: CustomTextStyle.body1,
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            StringConstant.getText,
                                            style: CustomTextStyle.body1
                                                .copyWith(
                                                    color:
                                                        AppColor.primarycolor),
                                          ),
                                          SizedBox(
                                            width: 3.w,
                                          ),
                                          Text(StringConstant.overlineGetText,
                                              style: CustomTextStyle.body1
                                                  .copyWith(
                                                      color: AppColor.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                        ]),
                                  ],
                                ),
                                //  color: Colors.green,
                                //height: 5.h,
                              ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  purchaseButtonOfSpecialOffer()
                ],
              ),
            ),
          );
        });
  }

  Future submitRating(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopUp(
            content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.cancel_outlined,
                      color: AppColor.grey,
                      // size: 3.5.h,
                    ),
                  )
                ],
              ),
              image(),
              SizedBox(
                height: 3.h,
              ),
              Text(
                StringConstant.giveRating,
                style: CustomTextStyle.body3.copyWith(color: AppColor.white),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                StringConstant.loremIpsum,
                style: CustomTextStyle.body4,
                // textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 3.h,
              ),
              rating(),
              SizedBox(
                height: 3.5.h,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                CoustomSmallButton(
                    title: StringConstant.submit,
                    style: CustomTextStyle.body1.copyWith(
                        color: AppColor.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: CustomTextStyle.fontFamilyMontserrat)),
              ])
            ]));
      },
    );
  }

  Future removeAudioPopUp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopUp(
            content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(
            Icons.cancel,
            color: AppColor.orange,
            size: 50,
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            StringConstant.removeAudio,
            style: CustomTextStyle.body3,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 3.h,
          ),
          MyButton.popButton()
        ]));
      },
    );
  }

  Future LogOutPopup(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return PopUp(
            content: Container(
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image.asset(
                    //   Images.factoryIcon,
                    //   scale: 8,
                    // ),
                    Text(
                      StringConstant.logoutPopup,
                      style: CustomTextStyle.body3,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    popUpButton(context)
                  ],
                ),
              ),
            ),
          );
        });
  }

  // widget

  Widget cancelButtonPopUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.clear,
            color: AppColor.grey,
            // size: 3.5.h,
          ),
        )
      ],
    );
  }

  Widget sizeAndDurationTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyButton.ratingAndCount(),
        Icon(
          Icons.fiber_manual_record,
          color: AppColor.white,
          size: 7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(AppIcon.clockIcon),
            SizedBox(
              width: 1.w,
            ),
            Text(
              StringConstant.durationText,
              style: CustomTextStyle.body1.copyWith(fontSize: 10.sp),
            )
          ],
        ),
        Icon(
          Icons.fiber_manual_record,
          color: AppColor.white,
          size: 7,
        ),
        Row(
          children: [
            SvgPicture.asset(AppIcon.sizeIcon),
            SizedBox(
              width: 1.w,
            ),
            Text(
              StringConstant.size,
              style: CustomTextStyle.body1.copyWith(fontSize: 10.sp),
            )
          ],
        )
      ],
    );
  }

  Widget aboutSong() {
    return Text(
      StringConstant.songDescription,
      style: CustomTextStyle.body1,
    );
  }

  Widget aboutCreator() {
    return Text(
      StringConstant.authorDescription,
      style: CustomTextStyle.body1,
      textAlign: TextAlign.start,
    );
  }

  Widget aboutCreatorBanner() {
    return Text(
      StringConstant.authorBanner,
      style: CustomTextStyle.body3,
    );
  }

  Widget imageAndMusicTitle() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            Images.bannerone,
            scale: 10,
          ),
          SizedBox(
            width: 2.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                StringConstant.betterRelationship,
                style: CustomTextStyle.body3.copyWith(color: AppColor.white),
              ),
              Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  StringConstant.subtitle,
                  style: CustomTextStyle.body4,
                  maxLines: 1,
                  // textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget purchaseButtonOfSpecialOffer() {
    return SizedBox(
      height: 5.h,
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            shape: MaterialStateProperty.all(StadiumBorder()),
            side: MaterialStateProperty.all(BorderSide(
                color: AppColor.blue, width: 2, style: BorderStyle.solid))),
        onPressed: () {},
        child: Text(
          StringConstant.purchaseNow,
          style: CustomTextStyle.body6
              .copyWith(fontFamily: CustomTextStyle.fontFamilyMontserrat),
        ),
      ),
    );
  }

  Widget image() {
    return AspectRatio(
      aspectRatio: 17 / 7,
      child: Container(
          // color: Colors.red,
          //height: 45.h,
          //width: 45.w,
          child: Image.asset(Images.feedBackImage)),
    );
  }

  Widget rating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ...List.generate(
        //     5,
        //     (index) =>
        //         // IconButton(
        //         //   icon: index < intialindex
        //         //       ? Icon(
        //         //           Icons.star,
        //         //           size: 27,
        //         //           color: CustomTheme.primarycolor,
        //         //         )
        //         //       : Icon(
        //         //           Icons.star_border,
        //         //           size: 27,
        //         //           color: CustomTheme.primarycolor,
        //         //         ),
        //         //   onPressed: () {
        //         //     setState(() {
        //         //       intialindex = index + 1;
        //         //     });
        //         //   },
        //         // )),
      ],
    );
  }

  Widget aboutCreatormore() {
    return Text(
      StringConstant.authorDescriptionone,
      style: CustomTextStyle.body1,
      textAlign: TextAlign.start,
    );
  }

  Widget popUpButton(BuildContext context) {
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
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false);
          },
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
