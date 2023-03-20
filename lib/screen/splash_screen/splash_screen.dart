import 'dart:convert';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/model/user_register_model.dart';
import 'package:elloro/provider/internet_connectivity_one%20time.dart';
import 'package:elloro/provider/provider.dart';
import 'package:elloro/screen/bottom_navigation/bottom_navigation.dart';
import 'package:elloro/screen/version_screen/internet_connectivity/no_internet_screen.dart';
import 'package:elloro/screen/onbording_screen/onbording_one.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../version_screen/internet_connectivity/second_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isNoData = false;
  int? index;
  SharedPreferences? preferences;
  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userData = (preferences.getString("user"));

    if (userData != null) {
      print("userdata exe");
      UserRegisterModel userRegisterModel =
          UserRegisterModel.fromJson(jsonDecode(userData));

      Provider.of<UserProvider>(context, listen: false)
          .setUser(currentUser: userRegisterModel);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigation()),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const FirstOnBording()),
          (route) => false);
    }
  }

  checkInternetConnectivity() {
    Provider.of<InternetConnectivityCheckOneTime>(context, listen: false)
        .checkOneTimeConnectivity();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noData();
  }

  noData() async {
    await Provider.of<InternetConnectivityCheckOneTime>(context, listen: false)
        .checkOneTimeConnectivity();

    print(Provider.of<InternetConnectivityCheckOneTime>(context, listen: false)
        .isOneTimeInternet);

    if (Provider.of<InternetConnectivityCheckOneTime>(context, listen: false)
        .isOneTimeInternet) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var user = preferences.getString("user");
      if (user != null) {
        print("hello");

        setState(() {
          index = 1;
        });
      } else {
        print("gohil");
        setState(() {
          index = 2;
        });
      }
    } else {
      print("exce");
      Future.delayed(Duration(seconds: 3), () {
        getData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Images.splashScreenImage),
                fit: BoxFit.cover)),
        child:
            Scaffold(backgroundColor: Colors.transparent, body: visibility()));
  }

  Widget visibility() {
    if (index == 1) {
      return NoInternet();

      //   Visibility(
      //   visible: true,
      //   child: Container(
      //     height: 200,
      //     decoration: BoxDecoration(
      //         color: AppColor.black, borderRadius: BorderRadius.circular(20)),
      //     width: double.infinity,
      //     child: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Text(
      //           "Oops! No Internet",
      //           style: CustomTextStyle.body1.copyWith(color: AppColor.grey),
      //         ),
      //         TextButton(
      //             style: ButtonStyle(
      //                 backgroundColor:
      //                     MaterialStateProperty.all(AppColor.primarycolor),
      //                 shape: MaterialStateProperty.all(RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(15)))),
      //             onPressed: () {
      //               Navigator.pushAndRemoveUntil(
      //                   context,
      //                   CupertinoPageRoute(builder: (context) => MyAudio()),
      //                   (route) => false);
      //             },
      //             child: Text(
      //               "Go To Download",
      //               style: CustomTextStyle.body1.copyWith(color: Colors.black),
      //             ))
      //       ],
      //     ),
      //   ),
      // );
    }
    if (index == 2) {
      return NoInternetSecond();

      //   Visibility(
      //   visible: true,
      //   child: Container(
      //     decoration: BoxDecoration(
      //         color: AppColor.black, borderRadius: BorderRadius.circular(20)),
      //     width: double.infinity,
      //     child: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Text(
      //           "Oops! No Internet",
      //           style: CustomTextStyle.body1.copyWith(color: AppColor.grey),
      //         ),
      //       ],
      //     ),
      //   ),
      // );
    }
    return Center(
      child: SizedBox(
        height: 20.h,
        width: 20.w,
        child: Image.asset(Images.ellorpLogo),
      ),
    );
  }
}
