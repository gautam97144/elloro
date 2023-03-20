import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/provider/internet_connectivity.dart';
import 'package:elloro/provider/internet_connectivity_one%20time.dart';
import 'package:elloro/screen/bottom_navigation/bottom_navigation.dart';
import 'package:elloro/screen/my_audio_screen/my_audio.dart';
import 'package:elloro/screen/splash_screen/splash_screen.dart';
import 'package:elloro/widget/custom_padding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../onbording_screen/onbording_one.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //checkrealTimeConnectivity();
  }

  // checkrealTimeConnectivity() async {
  //   await Provider.of<InternetConnectivityCheck>(context, listen: false)
  //       .checkRealTimeConnectivity();
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // await Provider.of<InternetConnectivityCheck>(context, listen: false)
        //     .checkRealTimeConnectivity();
        //
        // if (!Provider.of<InternetConnectivityCheck>(context, listen: true)
        //     .isNoInternet) {
        //   Navigator.push(
        //       context, MaterialPageRoute(builder: (context) => SplashScreen()));
        // }

        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CustomPadding(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Oops! No Internet",
                    style: CustomTextStyle.body1
                        .copyWith(color: AppColor.grey, fontSize: 18.sp),
                  ),
                  AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.asset(Images.noInternet)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        onPressed: () async {
                          await Provider.of<InternetConnectivityCheckOneTime>(
                                  context,
                                  listen: false)
                              .checkOneTimeConnectivity();

                          if (!Provider.of<InternetConnectivityCheckOneTime>(
                                  context,
                                  listen: false)
                              .isOneTimeInternet) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SplashScreen()));
                          }
                        },
                        child: Text("Retry",
                            style: CustomTextStyle.body1
                                .copyWith(color: AppColor.primarycolor)),
                      ),
                      CupertinoButton(
                          child: Text(
                            "Go To Download",
                            style: CustomTextStyle.body1
                                .copyWith(color: AppColor.primarycolor),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (contex) => MyAudio(status: 1)));
                          }),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
