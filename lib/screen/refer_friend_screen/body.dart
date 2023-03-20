import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_icon.dart';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/model/user_register_model.dart';
import 'package:elloro/provider/provider.dart';
import 'package:elloro/widget/custom_large_yellow_button.dart';
import 'package:elloro/widget/custom_padding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import "package:sizer/sizer.dart";
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  UserRegisterModel? user;

  NumberFormat format = NumberFormat.simpleCurrency(locale: "mnt");
  late final currency = format.currencySymbol.toString();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).getUser!;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPadding(
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          image(),
          SizedBox(
            height: 2.h,
          ),
          banner(),
          SizedBox(
            height: 1.h,
          ),
          discription(),
          SizedBox(
            height: 3.h,
          ),
          container(),
          SizedBox(
            height: 6.h,
          ),
          referFriendDescription(),
          SizedBox(
            height: 3.5.h,
          ),
          referButton(),
        ],
      ),
    );
  }

  Widget image() {
    return AspectRatio(
      aspectRatio: 17 / 8,
      child: Container(
          // color: Colors.red,
          //height: 45.h,
          //width: 45.w,
          child: Image.asset(Images.referFriend)),
    );
  }

  Widget banner() {
    return Text(
      StringConstant.inviteYourFriends,
      style: CustomTextStyle.headline2,
    );
  }

  Widget discription() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: "You Will receive ",
          style: CustomTextStyle.body4.copyWith(fontSize: 14.sp),
          children: [
            WidgetSpan(
                child: Text(
              format.currencySymbol + "2 ",
              style: TextStyle(color: AppColor.primarycolor, fontSize: 14.sp),
            )),
            TextSpan(
              text:
                  "for each friend who uses your referral code and buys Elloro tokens ",
              style: CustomTextStyle.body4.copyWith(
                fontSize: 14.sp,
              ),
            ),
          ]),
    );
  }

  Widget container() {
    return Container(
      //  padding: EdgeInsets.symmetric(horizontal: 12),
      height: 7.5.h,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.primarycolor.withOpacity(.3)),
          borderRadius: BorderRadius.circular(10),
          color: AppColor.primarycolor.withOpacity(.19)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(
              user?.uniqueId ?? "",
              style: CustomTextStyle.body1,
            ),
          ),
          // VerticalDivider(
          //   color: AppColor.primarycolor,
          // ),
          SizedBox(
            width: 3.w,
          ),
          copyTextContainer(),
        ],
      ),
    );
  }

  Widget referFriendDescription() {
    return Text(
      StringConstant.referFriendTitle,
      textAlign: TextAlign.center,
      style: CustomTextStyle.body4.copyWith(fontSize: 11.sp),
    );
  }

  Widget referButton() {
    return CustomLargeButton(
      onPressed: () async {
        await Share.share(
            '''To register for ELLORO, please use CODE: ${user?.uniqueId ?? ""}\n
ELLORO ~ Mindshift and Wellness.
Don't have Elloro?  Go to your Appstore / Play Store. 
More at: www.elloro.life''');

        //"Please this referral code when you register on the Elloro app: ${user?.uniqueId ?? ""}\nElloro - Mindshift and Wellness Don't have the Elloro app?  Get it from the Appstore or Play Store.   More information at www.elloro.life");
      },
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppIcon.referButtonIcon),
          SizedBox(
            width: 2.w,
          ),
          Text(
            StringConstant.referButtonText,
            style: CustomTextStyle.body2,
          )
        ],
      ),
    );
  }

  Widget copyTextContainer() {
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(
                text: "Use this code when you register on the Elloro app: " +
                    (user?.uniqueId ?? "")))
            .then((_) => Fluttertoast.showToast(msg: "code copied!"));
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: AppColor.primarycolor.withOpacity(.3)),
            color: AppColor.primarycolor.withOpacity(.12),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        width: 20.w,
        height: 7.5.h,
        child: Text(
          StringConstant.copy,
          style: CustomTextStyle.body7,
        ),
      ),
    );
  }
}
