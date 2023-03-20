import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_icon.dart';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/model/user_register_model.dart';
import 'package:elloro/provider/provider.dart';
import 'package:elloro/screen/re_download_screen/body.dart';
import 'package:elloro/widget/custom_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ReDownloadScreen extends StatefulWidget {
  const ReDownloadScreen({Key? key}) : super(key: key);

  @override
  _ReDownloadScreenState createState() => _ReDownloadScreenState();
}

class _ReDownloadScreenState extends State<ReDownloadScreen> {
  UserRegisterModel? user;

  gettoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    user = UserRegisterModel.fromJson(
        jsonDecode(preferences.getString('user') ?? ""));
    print(user?.toString());

    print(preferences.getString('user') ?? '');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // gettoken();
    user = Provider.of<UserProvider>(context, listen: false).getUser!;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: AppColor.black));

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColor.black,
          title: Text(StringConstant.redownload),
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
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 15),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 70,
                      height: 63,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14)),
                      child: Image.asset(
                        Images.music,
                        // scale: 7.5,
                        fit: BoxFit.fill,
                      ),
                      //color: Colors.red,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 7),
                        height: 8.h,
                        //width: double.infinity,
                        // color: Colors.red,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 150,
                                  //color: Colors.red,
                                  child: Text(
                                    "Qabil",
                                    style: CustomTextStyle.body3
                                        .copyWith(fontSize: 12.sp),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Reza Pishro",
                                      style: CustomTextStyle.body4
                                          .copyWith(fontSize: 12.sp)),
                                  Padding(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: reDownloadButton())
                                ]),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 1.h,
                )
              ]);
            },
          ),
        ));
  }

  Widget reDownloadButton() {
    return Container(
      width: 42.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 4.h,
            width: 33.w,
            child: TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(StadiumBorder()),
                  side: MaterialStateProperty.all(BorderSide(
                      color: AppColor.blue,
                      width: 2,
                      style: BorderStyle.solid))),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset(AppIcon.reDownloadIcon),
                  Text(
                    StringConstant.reDownloadText,
                    style: CustomTextStyle.body6.copyWith(fontSize: 10.sp),
                  ),
                ],
              ),
            ),
          ),
          circleButton(),
        ],
      ),
    );
  }

  Widget circleButton() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border(
              top: BorderSide(color: AppColor.grey),
              bottom: BorderSide(color: AppColor.grey),
              left: BorderSide(color: AppColor.grey),
              right: BorderSide(color: AppColor.grey))),
      child: Icon(
        Icons.more_horiz,
        size: 22,
        color: AppColor.grey,
      ),
    );
  }
}
