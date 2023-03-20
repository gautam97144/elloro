import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_icon.dart';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(14)),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
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
