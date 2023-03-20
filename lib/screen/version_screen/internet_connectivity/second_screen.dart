import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/provider/internet_connectivity_one%20time.dart';
import 'package:elloro/screen/splash_screen/splash_screen.dart';
import 'package:elloro/widget/custom_padding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class NoInternetSecond extends StatefulWidget {
  const NoInternetSecond({Key? key}) : super(key: key);

  @override
  State<NoInternetSecond> createState() => _NoInternetSecondState();
}

class _NoInternetSecondState extends State<NoInternetSecond> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("hhhjh");
    //  checkrealTimeConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CustomPadding(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Spacer(),
                AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      Images.noInternet,
                      // color: AppColor.primarycolor,
                    )),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  "Oops!",
                  style: CustomTextStyle.body1
                      .copyWith(color: AppColor.grey, fontSize: 22.sp),
                ),
                Text("No Internet Connection Found Check Your Connection",
                    textAlign: TextAlign.center,
                    style:
                        CustomTextStyle.body1.copyWith(color: AppColor.grey)),
                SizedBox(
                  height: 3.h,
                ),
                CupertinoButton(
                    color: AppColor.primarycolor,
                    onPressed: () async {
                      await Provider.of<InternetConnectivityCheckOneTime>(
                              context,
                              listen: false)
                          .checkOneTimeConnectivity();

                      if (!Provider.of<InternetConnectivityCheckOneTime>(
                              context,
                              listen: false)
                          .isOneTimeInternet) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SplashScreen()),
                            (route) => false);
                      }
                    },
                    child: Text(
                      "Retry",
                      style: CustomTextStyle.body1.copyWith(
                          color: AppColor.black, fontWeight: FontWeight.w700),
                    )),
                Spacer()
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
