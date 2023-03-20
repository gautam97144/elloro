import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/model/user_register_model.dart';
import 'package:elloro/provider/internet_connectivity.dart';
import 'package:elloro/provider/provider.dart';
import 'package:elloro/screen/terms_and_condition_screen/body.dart';
import 'package:elloro/screen/version_screen/internet_connectivity/second_screen.dart';
import 'package:elloro/widget/custom_padding.dart';
import 'package:elloro/widget/custom_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({Key? key}) : super(key: key);

  @override
  _TermsAndConditionState createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  UserRegisterModel? user;

  // gettoken() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //
  //   user = UserRegisterModel.fromJson(
  //       jsonDecode(preferences.getString('user') ?? ""));
  //   print(user?.toString());
  //
  //   print(preferences.getString('user') ?? '');
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).getUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: AppColor.black,
          title: Text(
            StringConstant.termsAndCondition,
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
        body: SafeArea(
          child: SingleChildScrollView(
              child: CustomPadding(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                termsAndConditionTitle(),
                SizedBox(
                  height: 2.h,
                ),
                termsAndConditionDescribtion()
              ],
            ),
          )),
        ),
      ),
      Provider.of<InternetConnectivityCheck>(context, listen: true).isNoInternet
          ? const NoInternetSecond()
          : const SizedBox.shrink()
    ]);
  }

  Widget termsAndConditionTitle() {
    return Text(
      StringConstant.termsAndConditionTitle,
      style: CustomTextStyle.body3.copyWith(fontWeight: FontWeight.w800),
    );
  }

  Widget termsAndConditionDescribtion() {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        StringConstant.termsAndConditionOne,
        style: CustomTextStyle.body4,
      ),
    );
  }
}
