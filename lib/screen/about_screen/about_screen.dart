import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/model/user_register_model.dart';
import 'package:elloro/provider/internet_connectivity.dart';
import 'package:elloro/provider/provider.dart';
import 'package:elloro/screen/about_screen/body.dart';
import 'package:elloro/screen/version_screen/internet_connectivity/second_screen.dart';
import 'package:elloro/widget/custom_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  UserRegisterModel? user;
  Uri uri = Uri.parse("https://elloro.life/");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).getUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: AppColor.black,
            actions: [
              Padding(
                  padding: EdgeInsets.only(right: 4.w),
                  child: Row(children: [
                    CustomProfilePicture(
                      url: user?.image ?? "",
                    ),
                  ]))
            ],
            title: Text(
              StringConstant.about,
              style: CustomTextStyle.headline2,
            ),
          ),
          body: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  elloroLogo(),
                  SizedBox(
                    height: 3.h,
                  ),
                  aboutText(),
                  SizedBox(
                    height: 3.h,
                  ),
                  aboutTextSecond(),
                  SizedBox(
                    height: 3.h,
                  ),
                  aboutTextThird(),
                  SizedBox(
                    height: 3.h,
                  ),
                  aboutTextFour(),
                  SizedBox(
                    height: 3.h,
                  ),
                  aboutTextFive(),
                  SizedBox(
                    height: 3.h,
                  ),
                  aboutTextSix(),
                  aboutSeven(),
                  aboutEight()
                ],
              ),
            ),
          )),
        ),
      ),
      Provider.of<InternetConnectivityCheck>(context, listen: true).isNoInternet
          ? const NoInternetSecond()
          : const SizedBox.shrink()
    ]);
  }

  Widget elloroLogo() {
    return Image.asset(
      Images.logo,
      scale: 4,
      fit: BoxFit.fill,
    );
  }

  Widget aboutText() {
    return Text(
      StringConstant.aboutFirst,
      style: CustomTextStyle.body4,
    );
  }

  Widget aboutTextSecond() {
    return Text(
      StringConstant.aboutSecond,
      style: CustomTextStyle.body4,
    );
  }

  Widget aboutTextThird() {
    return Text(
      StringConstant.aboutThird,
      style: CustomTextStyle.body4,
    );
  }

  Widget aboutTextFour() {
    return Text(
      StringConstant.aboutforth,
      style: CustomTextStyle.body4,
    );
  }

  Widget aboutTextFive() {
    return Text(
      StringConstant.aboutfive,
      style: CustomTextStyle.body4,
    );
  }

  Widget aboutTextSix() {
    return Text(
      StringConstant.aboutsix,
      style: CustomTextStyle.body4,
    );
  }

  Widget aboutSeven() {
    return InkWell(
      onTap: () {
        setState(() {
          openBrowserUrl(url: uri);
        });
      },
      child: Text(
        "hello@elloro.life",
        style: CustomTextStyle.body4.copyWith(color: Colors.blue),
      ),
    );
  }

  Widget aboutEight() {
    return Text(
      "\n May 2022",
      style: CustomTextStyle.body4,
    );
  }

  Future openBrowserUrl({required Uri url, bool inApp = false}) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalNonBrowserApplication,
        webViewConfiguration:
            const WebViewConfiguration(enableDomStorage: false),
      );
    }
  }
}
