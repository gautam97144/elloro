import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_icon.dart';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/model/toekn_history_model.dart';
import 'package:elloro/screen/about_screen/about_screen.dart';
import 'package:elloro/screen/change_password/change_password.dart';
import 'package:elloro/screen/feedback_screen/feedback_screen.dart';
import 'package:elloro/screen/privacy_policy_screen/privacy_policy.dart';
import 'package:elloro/screen/re_download_screen/re_download_screen.dart';
import 'package:elloro/screen/refer_friend_screen/refer_friend_screen.dart';
import 'package:elloro/screen/terms_and_condition_screen/terms_and_condition_screen.dart';
import 'package:elloro/screen/token_history_screen/token_history_screen.dart';
import 'package:elloro/screen/update_Account/update_account.dart';
import 'package:elloro/widget/custom_button.dart';
import 'package:elloro/widget/custom_dialog.dart';
import 'package:elloro/widget/my_popUp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class MyComponant {
  static Widget feedback() {
    return ListTile(
      onTap: () {
        Get.to(FeedBack());
      },
      trailing: Icon(
        Icons.arrow_forward_ios_sharp,
        color: AppColor.grey,
      ),
      leading: SvgPicture.asset(AppIcon.feedbackIcon),
      title: Text(
        StringConstant.feedback,
        style: CustomTextStyle.body1.copyWith(
            fontSize: 14.sp, fontFamily: CustomTextStyle.fontFamilyMontserrat),
      ),
    );
  }

  static Widget changePassword(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChangePassword()));
      },
      leading: SvgPicture.asset(AppIcon.lockIcon),
      trailing: Icon(
        Icons.arrow_forward_ios_sharp,
        color: AppColor.grey,
      ),
      title: Text(
        StringConstant.changePassword,
        style: CustomTextStyle.body1.copyWith(
            fontSize: 14.sp, fontFamily: CustomTextStyle.fontFamilyMontserrat),
      ),
    );
  }

  static Widget accountInfo(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UpdateProfile()));
        //     SharedPreferences preferences = await SharedPreferences.getInstance();
        //
        //     setState(() {
        //       user = UserRegisterModel.fromJson(
        //           jsonDecode(preferences.getString('user') ?? ''));
        //     });
        //
        //     getUserData = await ApiService()
        //         .getUserData(context: context, userRegisterModel: user!);
        //
        //     if (mounted) {
        //       setState(() {});
        //
        //
        // });
      },
      trailing: Icon(
        Icons.arrow_forward_ios_sharp,
        color: AppColor.grey,
      ),
      leading: SvgPicture.asset(AppIcon.infoIcon),
      title: Text(
        StringConstant.accountInfo,
        style: CustomTextStyle.body1.copyWith(
            fontSize: 14.sp, fontFamily: CustomTextStyle.fontFamilyMontserrat),
      ),
    );
  }

  static Widget redownload() {
    return ListTile(
      onTap: () {
        Get.to(ReDownloadScreen());
      },
      trailing: Icon(
        Icons.arrow_forward_ios_sharp,
        color: AppColor.grey,
      ),
      leading: SvgPicture.asset(AppIcon.downloadIcon),
      title: Text(
        StringConstant.redownload,
        style: CustomTextStyle.body1.copyWith(
            fontSize: 14.sp, fontFamily: CustomTextStyle.fontFamilyMontserrat),
      ),
    );
  }

  static Widget about() {
    return ListTile(
      onTap: () {
        Get.to(AboutScreen());
      },
      trailing: Icon(
        Icons.arrow_forward_ios_sharp,
        color: AppColor.grey,
      ),
      leading: SvgPicture.asset(AppIcon.aboutIcon),
      title: Text(
        StringConstant.about,
        style: CustomTextStyle.body1.copyWith(
            fontSize: 14.sp, fontFamily: CustomTextStyle.fontFamilyMontserrat),
      ),
    );
  }

  static Widget referfriend() {
    return ListTile(
      onTap: () {
        Get.to(const ReferFriend());
      },
      trailing: const Icon(
        Icons.arrow_forward_ios_sharp,
        color: AppColor.grey,
      ),
      leading: SvgPicture.asset(AppIcon.referralsIcon),
      title: Text(
        StringConstant.referFriend,
        style: CustomTextStyle.body1.copyWith(
            fontSize: 14.sp, fontFamily: CustomTextStyle.fontFamilyMontserrat),
      ),
    );
  }

  static Widget privacyAndPolicy(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade, child: PrivacyAndPolicy())
            //Get.to(PrivacyAndPolicy()

            );
      },
      trailing: const Icon(
        Icons.arrow_forward_ios_sharp,
        color: AppColor.grey,
      ),
      leading: SvgPicture.asset(AppIcon.privacyIcon),
      title: Text(
        StringConstant.privacyPolicy,
        style: CustomTextStyle.body1.copyWith(
            fontSize: 14.sp, fontFamily: CustomTextStyle.fontFamilyMontserrat),
      ),
    );
  }

  static Widget termsAndCondition() {
    return ListTile(
      onTap: () {
        Get.to(const TermsAndCondition());
      },
      trailing: const Icon(
        Icons.arrow_forward_ios_sharp,
        color: AppColor.grey,
      ),
      leading: SvgPicture.asset(AppIcon.termsAndConditionIcon),
      title: Text(
        StringConstant.TermsAndCondition,
        style: CustomTextStyle.body1.copyWith(
            fontSize: 14.sp, fontFamily: CustomTextStyle.fontFamilyMontserrat),
      ),
    );
  }

  static Widget tokenHistoryData(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PurchaseHistory()));
      },
      trailing: const Icon(
        Icons.arrow_forward_ios_sharp,
        color: AppColor.grey,
      ),
      leading: SvgPicture.asset(AppIcon.resetIcon),
      title: Text(
        StringConstant.purchaseHistory,
        style: CustomTextStyle.body1.copyWith(
            fontSize: 14.sp, fontFamily: CustomTextStyle.fontFamilyMontserrat),
      ),
    );
  }
}
