import 'dart:convert';
import 'package:elloro/provider/internet_connectivity.dart';
import 'package:elloro/screen/version_screen/internet_connectivity/second_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/model/user_register_model.dart';
import 'package:elloro/provider/provider.dart';
import 'package:elloro/screen/privacy_policy_screen/body.dart';
import 'package:elloro/widget/custom_padding.dart';
import 'package:elloro/widget/custom_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class PrivacyAndPolicy extends StatefulWidget {
  const PrivacyAndPolicy({Key? key}) : super(key: key);

  @override
  _PrivacyAndPolicyState createState() => _PrivacyAndPolicyState();
}

class _PrivacyAndPolicyState extends State<PrivacyAndPolicy> {
  UserRegisterModel? user;
  Uri uri = Uri.parse("https://elloro.life/");
  Uri applePrivacy = Uri.parse("https://www.apple.com/privacy/");
  Uri googlePrivacy = Uri.parse("https://policies.google.com/privacy");

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
              StringConstant.privacyAndPolicy,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                privacyAndPolicyTitle(),
                SizedBox(
                  height: 2.h,
                ),
                privacyAndPolicyOne(),
                SizedBox(
                  height: 2.h,
                ),
                privacyAndPolicyDescription(),
                SizedBox(
                  height: 2.h,
                ),
                access(),
                privacySix(),
                privacyfive()
              ],
            ),
          )))),
      Provider.of<InternetConnectivityCheck>(context, listen: true).isNoInternet
          ? const NoInternetSecond()
          : const SizedBox.shrink()
    ]);
  }

  Widget privacyAndPolicyTitle() {
    return Text("This Policy describes how we process your personal data.",
        style: CustomTextStyle.body3.copyWith(fontWeight: FontWeight.w800));
  }

  Widget privacyAndPolicyOne() {
    return Text(StringConstant.privacyOne, style: CustomTextStyle.body4);
  }

  Widget privacyAndPolicyDescription() {
    return Text(StringConstant.privacyTwo,
        style: CustomTextStyle.body4, textAlign: TextAlign.start);
  }

  Widget privacyThird() {
    return Text(StringConstant.privacyThird,
        style: CustomTextStyle.body4, textAlign: TextAlign.start);
  }

  Widget access() {
    return RichText(
        text: TextSpan(
            text: StringConstant.privacyThird,
            style: CustomTextStyle.body4,
            children: [
          WidgetSpan(
              child: InkWell(
            onTap: () {
              openBrowserUrl(url: uri);
            },
            child: Text(
              StringConstant.privacyFour,
              style: CustomTextStyle.body4.copyWith(color: AppColor.blue),
            ),
          )),
          TextSpan(
              text: StringConstant.privacySix, style: CustomTextStyle.body4),
          WidgetSpan(
              child: InkWell(
            onTap: () {
              openBrowserUrl(url: applePrivacy);
            },
            child: Text(StringConstant.privacySeven,
                style: CustomTextStyle.body4.copyWith(color: AppColor.blue)),
          )),
          TextSpan(
              text: StringConstant.privacyNign, style: CustomTextStyle.body4),
          WidgetSpan(
              child: InkWell(
            onTap: () {
              openBrowserUrl(url: googlePrivacy);
            },
            child: Text(
              StringConstant.privacyTen,
              style: CustomTextStyle.body4.copyWith(color: AppColor.blue),
            ),
          )),
        ]));
  }

  Widget privacySix() {
    return RichText(
      text: TextSpan(
          text:
              '''While it is unlikely that law enforcement will contact us, if they were to do so then we would provide them with the information that the prevailing law requires of us.
For help, please contact us using the information on the Contact page of our website ''',
          style: CustomTextStyle.body4,
          children: [
            WidgetSpan(
                child: InkWell(
              onTap: () {
                openBrowserUrl(url: uri);
              },
              child: Text(
                "(www.elloro.life).",
                style: CustomTextStyle.body4.copyWith(color: AppColor.blue),
              ),
            ))
          ]),
    );
  }

  Widget privacyfive() {
    return Text(StringConstant.privacyFive, style: CustomTextStyle.body4);
  }

  Future openBrowserUrl({required Uri url, bool inApp = false}) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalNonBrowserApplication,
      );
    }
  }
}
