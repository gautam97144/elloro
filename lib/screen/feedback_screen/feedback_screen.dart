import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/model/user_register_model.dart';
import 'package:elloro/provider/internet_connectivity.dart';
import 'package:elloro/provider/provider.dart';
import 'package:elloro/screen/loader/loader.dart';
import 'package:elloro/screen/version_screen/internet_connectivity/second_screen.dart';
import 'package:elloro/services/auth_service.dart';
import 'package:elloro/widget/custom_padding.dart';
import 'package:elloro/widget/custom_profile_picture.dart';
import 'package:elloro/widget/custom_small_black_button.dart';
import 'package:elloro/widget/custom_small_yellow_button.dart';
import 'package:elloro/widget/custom_snackbar.dart';
import 'package:elloro/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:dio/dio.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({Key? key}) : super(key: key);

  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  TextEditingController controllerOne = TextEditingController();
  TextEditingController controllerTwo = TextEditingController();
  TextEditingController controllerThree = TextEditingController();
  TextEditingController controllerFour = TextEditingController();
  TextEditingController controllerFive = TextEditingController();
  TextEditingController controllerSix = TextEditingController();

  String? value1;

  bool isRating = false;
  int intialindex = 0;
  bool isLoader = false;
  UserRegisterModel? user;
  String text = "Amazing";
  var item = [
    'Amazing',
    "Fantastic",
    "Excellent",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).getUser!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(children: [
        Scaffold(
            // resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            appBar: AppBar(
              // titleSpacing: 10,
              elevation: 0,
              backgroundColor: AppColor.black,
              title: Text(
                StringConstant.feedback,
                style: CustomTextStyle.headline2,
              ),
              actions: [
                Padding(
                    padding: EdgeInsets.only(right: 4.w),
                    child: Row(children: [
                      CustomProfilePicture(
                        url: user?.image ?? "",
                      ),
                    ])),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                //reverse: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 2.5.h,
                    ),
                    image(),
                    SizedBox(
                      height: 2.5.h,
                    ),
                    giveFeedbackBanner(),
                    SizedBox(
                      height: 1.h,
                    ),
                    // feedbackDescription(),
                    SizedBox(
                      height: 2.h,
                    ),
                    rating(),
                    // SizedBox(
                    //   height: 2.h,
                    // ),

                    // FormField<String>(
                    //   // validator: (value) {
                    //   //   if (value == "") {
                    //   //     setState(() {
                    //   //       isMonthValidate = true;
                    //   //     });
                    //   //   } else {
                    //   //     setState(() {
                    //   //       isMonthValidate = false;
                    //   //     });
                    //   //   }
                    //   // },
                    //   builder: (FormFieldState<String> state) {
                    //     return InputDecorator(
                    //       decoration: InputDecoration(
                    //         enabledBorder: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(12),
                    //             borderSide: BorderSide(
                    //                 color: AppColor.grey.withOpacity(.22))),
                    //         focusedBorder: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(12),
                    //             borderSide:
                    //                 BorderSide(color: AppColor.primarycolor)),
                    //         contentPadding: EdgeInsets.all(18),
                    //         filled: true,
                    //         fillColor: AppColor.grey.withOpacity(.12),
                    //         hintText: 'Month',
                    //       ),
                    //       //isEmpty: false,
                    //       child: Container(
                    //         //color: AppColor.grey.withOpacity(.12),
                    //         child: DropdownButtonHideUnderline(
                    //           child: DropdownButton<String>(
                    //             icon: Icon(
                    //               Icons.keyboard_arrow_down_outlined,
                    //               color: AppColor.white,
                    //             ),
                    //             borderRadius: BorderRadius.circular(15),
                    //             dropdownColor: Colors.black,
                    //             hint: Text(
                    //               'Amazing',
                    //               style: CustomTextStyle.body1,
                    //             ),
                    //             value: value1,
                    //             isDense: true,
                    //             onChanged: (String? newValue) {
                    //               setState(() {
                    //                 value1 = newValue;
                    //                 print(value1);
                    //               });
                    //             },
                    //             items: item.map((String value) {
                    //               return DropdownMenuItem<String>(
                    //                 value: value,
                    //                 child: Text(
                    //                   value,
                    //                   style: CustomTextStyle.body1,
                    //                 ),
                    //               );
                    //             }).toList(),
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),

                    SizedBox(
                      height: 4.h,
                    ),
                    // Text(
                    //   StringConstant.tetxfilledout,
                    //   style: CustomTextStyle.body4
                    //       .copyWith(fontSize: 14.sp, color: AppColor.white),
                    // ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      StringConstant.elloroHasHelped,
                      style: CustomTextStyle.body1,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    CustomInPutField(
                      maxLength: 256,
                      fieldController: controllerTwo,
                      fieldName: 'Elorro is',
                      hint: StringConstant.char256,
                      hintStyle: CustomTextStyle.body4,
                      maxline: 5,
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      StringConstant.enableme,
                      style: CustomTextStyle.body1,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    CustomInPutField(
                      maxLength: 256,
                      fieldController: controllerThree,
                      fieldName: 'Elorro is',
                      hint: StringConstant.hasEnabledHintText,
                      hintStyle: CustomTextStyle.body4,
                      maxline: 5,
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      StringConstant.aboutElloro,
                      style: CustomTextStyle.body1,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    CustomInPutField(
                      maxLength: 256,
                      fieldController: controllerFour,
                      fieldName: 'Elorro is',
                      hint: StringConstant.aboutElloroHintText,
                      hintStyle: CustomTextStyle.body4,
                      maxline: 5,
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      StringConstant.Ellorocould,
                      style: CustomTextStyle.body1,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    CustomInPutField(
                      maxLength: 256,
                      fieldController: controllerFive,
                      fieldName: 'Elorro is',
                      hint: StringConstant.elloroCouldHintText,
                      hintStyle: CustomTextStyle.body4,
                      maxline: 5,
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      StringConstant.wouldliketo,
                      style: CustomTextStyle.body1,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    CustomInPutField(
                      maxLength: 256,
                      fieldController: controllerSix,
                      fieldName: 'Elorro is',
                      hint: StringConstant.hintText,
                      hintStyle: CustomTextStyle.body4,
                      maxline: 5,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    button(),
                    SizedBox(
                      height: 2.5.h,
                    ),
                  ],
                ),
              ),
            )),
        Provider.of<InternetConnectivityCheck>(context, listen: true)
                .isNoInternet
            ? const NoInternetSecond()
            : const SizedBox.shrink(),
        isLoader == true ? const CustomLoader() : const SizedBox.shrink()
      ]),
    );
  }

  Widget image() {
    return AspectRatio(
      aspectRatio: 17 / 8,
      child: Container(

          //Colors.red,
          child: Image.asset(Images.feedBackImage)),
    );
  }

  Widget giveFeedbackBanner() {
    return Text(
      StringConstant.giveFeedback,
      style: CustomTextStyle.body4
          .copyWith(fontSize: 15.sp, color: AppColor.white),
    );
  }

  Widget feedbackDescription() {
    return Text(
      StringConstant.giveFeedbackDescription,
      style: CustomTextStyle.body1,
    );
  }

  Widget rating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...List.generate(
            5,
            (index) => IconButton(
                  icon: index < intialindex
                      ? const Icon(
                          Icons.star,
                          size: 38,
                          color: AppColor.primarycolor,
                        )
                      : const Icon(
                          Icons.star_border,
                          size: 38,
                          color: AppColor.primarycolor,
                        ),
                  onPressed: () {
                    setState(() {
                      intialindex = index + 1;
                    });
                  },
                ))
      ],
    );
  }

  Widget button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CoustomSmallBlackButton(
          onPressed: () {
            controllerTwo.clear();
            controllerThree.clear();
            controllerFour.clear();
            controllerFive.clear();
            controllerSix.clear();
            setState(() {
              intialindex = 0;
            });
          },
          title: StringConstant.cancel,
          style: CustomTextStyle.body1
              .copyWith(fontFamily: CustomTextStyle.fontFamilyMontserrat),
        ),
        CoustomSmallButton(
            onPressed: () async {
              if (intialindex != 0) {
                FormData data = FormData.fromMap({
                  "rate": intialindex,
                  "elloro_is": "",
                  "helped_me_to_become": controllerTwo,
                  "enabled_me_to": controllerThree,
                  "what_i_like_about": controllerFour,
                  "could_improve_by": controllerFive,
                  "i_would_like_to_see_more_content_on": controllerSix
                });

                setState(() {
                  isLoader = true;
                });

                await ApiService()
                    .audioFeedback(
                        context: context, userRegisterModel: user!, data: data)
                    .then((value) {
                  controllerTwo.clear();
                  controllerThree.clear();
                  controllerFour.clear();
                  controllerFive.clear();
                  controllerSix.clear();
                  setState(() {
                    intialindex = 0;
                  });
                });

                setState(() {
                  isLoader = false;
                });
              } else {
                GlobalSnackBar.show(context, "Please Enter Rating");
              }
            },
            title: StringConstant.submit,
            style: CustomTextStyle.body1.copyWith(
                color: AppColor.black,
                fontWeight: FontWeight.w600,
                fontFamily: CustomTextStyle.fontFamilyMontserrat)),
      ],
    );
  }
}
