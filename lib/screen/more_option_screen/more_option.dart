import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_icon.dart';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/model/get_user_data.dart';
import 'package:elloro/model/token_data.dart';
import 'package:elloro/model/user_register_model.dart';
import 'package:elloro/provider/internet_connectivity.dart';
import 'package:elloro/provider/internet_connectivity_one%20time.dart';
import 'package:elloro/screen/about_screen/about_screen.dart';
import 'package:elloro/screen/change_password/change_password.dart';
import 'package:elloro/screen/database/database.dart';
import 'package:elloro/screen/feedback_screen/feedback_screen.dart';
import 'package:elloro/screen/loader/loader.dart';
import 'package:elloro/screen/login_screen/login_screen.dart';
import 'package:elloro/screen/privacy_policy_screen/privacy_policy.dart';
import 'package:elloro/screen/re_download_screen/re_download_screen.dart';
import 'package:elloro/screen/refer_friend_screen/refer_friend_screen.dart';
import 'package:elloro/screen/terms_and_condition_screen/terms_and_condition_screen.dart';
import 'package:elloro/screen/token_history_screen/token_history_screen.dart';
import 'package:elloro/screen/update_Account/update_account.dart';
import 'package:elloro/screen/version_screen/internet_connectivity/second_screen.dart';
import 'package:elloro/services/auth_service.dart';
import 'package:elloro/widget/custom_dialog.dart';
import 'package:elloro/widget/custom_profile_picture.dart';
import 'package:elloro/widget/custom_small_black_button.dart';
import 'package:elloro/widget/custom_small_yellow_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:numeral/numeral.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class MoreOption extends StatefulWidget {
  const MoreOption({Key? key}) : super(key: key);

  @override
  _MoreOptionState createState() => _MoreOptionState();
}

class _MoreOptionState extends State<MoreOption> {
  UserRegisterModel? user;
  GetUserData? getUserData;
  var directory = getApplicationDocumentsDirectory();
  String? appName;
  String? packageName;
  String? version;
  bool isLoading = false;
  File? file;

  NumberFormat format = NumberFormat.simpleCurrency(locale: "mnt");

  clearData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("user");
  }

  getdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      user = UserRegisterModel.fromJson(
          jsonDecode(preferences.getString('user') ?? ''));
    });

    if (!Provider.of<InternetConnectivityCheckOneTime>(context, listen: false)
            .isOneTimeInternet ||
        !Provider.of<InternetConnectivityCheck>(context, listen: false)
            .isNoInternet) {
      getUserData = await ApiService()
          .getUserData(context: context, userRegisterModel: user!);

      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _initPackageInfo() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    appName = info.appName;
    packageName = info.packageName;
    version = info.version;
  }

  List<TokenData> tokenData = [
    TokenData(
      token: "1",
      tokenPrice: "\$ 1.00",
      buy: "Buy",
    ),
    TokenData(
      token: "5",
      tokenPrice: "\$ 4.75",
      buy: "Buy",
    ),
    TokenData(
      token: "15",
      tokenPrice: "\$ 9.00",
      buy: "Buy",
    ),
    TokenData(
      token: "20",
      tokenPrice: "\$ 17.00",
      buy: "Buy",
    )
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: AppColor.black));

    return Stack(children: [
      Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          titleSpacing: 10,
          elevation: 0,
          backgroundColor: AppColor.black,
          leading: Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Image.asset(
              Images.onlyLogo,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: Row(
                children: [
                  SizedBox(width: 3.w),
                  CustomProfilePicture(url: user?.image ?? ""
                      //"${getUserData?.data?.image}",
                      )
                ],
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tokenBanner(),
              SizedBox(height: 2.h),
              changePassword(context),
              SizedBox(
                height: 1.5.h,
              ),
              accountInfo(context),
              SizedBox(
                height: 1.5.h,
              ),
              redownload(),
              SizedBox(
                height: 1.5.h,
              ),
              referfriend(),
              SizedBox(
                height: 1.5.h,
              ),
              termsAndCondition(),
              SizedBox(
                height: 1.5.h,
              ),
              privacyAndPolicy(context),
              SizedBox(
                height: 1.5.h,
              ),
              about(),
              SizedBox(
                height: 1.5.h,
              ),
              factoryReset(context),
              SizedBox(
                height: 1.5.h,
              ),
              feedback(),
              SizedBox(
                height: 1.5.h,
              ),
              ListTile(
                  onTap: () {
                    logOutPopup(context);
                  },
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: AppColor.primarycolor,
                  ),
                  title: Text(
                    "Logout",
                    style: CustomTextStyle.body1.copyWith(
                        fontSize: 14.sp,
                        fontFamily: CustomTextStyle.fontFamilyMontserrat),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: AppColor.grey,
                  )),
              ListTile(
                onTap: () {
                  //   Navigator.of(context)
                  //       .push(MaterialPageRoute(builder: (context) => Version()));
                },
                leading: const Text(""),
                subtitle: Text(
                  version.toString(),
                  style: CustomTextStyle.body1,
                ),
                title: Text(
                  "Version",
                  style: CustomTextStyle.body1.copyWith(
                      fontSize: 14.sp,
                      fontFamily: CustomTextStyle.fontFamilyMontserrat),
                ),
              ),

              // _infoTile(
              //   packageInfo.appName,
              // ),
              // _infoTile("com.elloro.app", packageInfo.packageName)
            ],
          ),
        )),
      ),
      isLoading == true ? CustomLoader() : SizedBox.shrink(),
      Provider.of<InternetConnectivityCheckOneTime>(context, listen: true)
                  .isOneTimeInternet ||
              Provider.of<InternetConnectivityCheck>(context, listen: true)
                  .isNoInternet
          ? const NoInternetSecond()
          : const SizedBox.shrink()
    ]);
  }

  Widget factoryReset(BuildContext context) {
    return ListTile(
      onTap: () {
        factoryPopUp(context);
      },
      trailing: const Icon(
        Icons.arrow_forward_ios_sharp,
        color: AppColor.grey,
      ),
      leading: SvgPicture.asset(AppIcon.resetIcon),
      title: Text(
        StringConstant.factoryReset,
        style: CustomTextStyle.body1.copyWith(
            fontSize: 14.sp, fontFamily: CustomTextStyle.fontFamilyMontserrat),
      ),
    );
  }

  Future factoryPopUp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopUp(
          content: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    Images.factoryIcon,
                    scale: 8,
                  ),
                  Text(
                    StringConstant.factoryResetTitle,
                    style: CustomTextStyle.body3,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  popButton()
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget popButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        CoustomSmallBlackButton(
          onPressed: () {
            Get.back();
          },
          title: StringConstant.cancel,
          style: CustomTextStyle.body1
              .copyWith(fontFamily: CustomTextStyle.fontFamilyMontserrat),
        ),
        CoustomSmallButton(
          onPressed: () async {
            await DatabaseHelper.instance.deleteData();

            Navigator.pop(context);
          },
          title: StringConstant.yes,
          style: CustomTextStyle.body1.copyWith(
              color: AppColor.black,
              fontWeight: FontWeight.w600,
              fontFamily: CustomTextStyle.fontFamilyMontserrat),
        )
      ],
    );
  }

  Widget tokenBanner() {
    return Stack(clipBehavior: Clip.none, children: [
      IntrinsicHeight(
        child: Container(
            margin: EdgeInsets.only(left: 2.5.h),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [token()],
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [currentBalanceBanner(), buyTokenButton()]),
                  ],
                )

                // Row(
                //
                // )

                ),
            width: double.infinity,
            height: 19.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                    colors: [AppColor.pink, AppColor.primarycolor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight))),
      ),
      Positioned(
          top: -2,
          left: -.4.h,
          child: Image.asset(
            Images.token,
            scale: 3,
          )),
      Positioned(
          top: 1.h,
          left: 10.w,
          child: Text(
            StringConstant.tokenHeading,
            style: CustomTextStyle.body2.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: CustomTextStyle.fontFamilyMontserrat),
          ))
    ]);
  }

  Widget buyTokenButton() {
    return SizedBox(
      height: 5.5.h,
      width: 30.w,
      child: TextButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(AppColor.white.withOpacity(.2)),
              shape: MaterialStateProperty.all(const StadiumBorder()),
              side: MaterialStateProperty.all(const BorderSide(
                  color: AppColor.white, width: 2, style: BorderStyle.solid))),
          onPressed: () {
            buyTokenPopUp(context);
          },
          child: Text(
            StringConstant.buyTokens,
            style: CustomTextStyle.body1.copyWith(
                fontSize: 10.sp,
                fontFamily: CustomTextStyle.fontFamilyMontserrat,
                fontWeight: FontWeight.w600),
          )),
    );
  }

  Widget token() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Text(
        format.currencySymbol.toString(),
        style: CustomTextStyle.headline,
      ),
      Text(
        // user?.totalToken ?? "0",
        "${getUserData?.data?.totalToken ?? 0}",
        // StringConstant.token,
        style: CustomTextStyle.headline.copyWith(fontWeight: FontWeight.bold),
      ),
    ]);
  }

  Widget currentBalanceBanner() {
    return Expanded(
      child: Text(
        StringConstant.currentBalance,
        style: CustomTextStyle.headline2.copyWith(
            fontSize: 16.sp, fontFamily: CustomTextStyle.fontFamilyMontserrat),
      ),
    );
  }

  Future buyTokenPopUp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return PopUp(content: tokenList());
        });
  }

  Future logOutPopup(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return PopUp(
            content: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image.asset(
                    //   Images.factoryIcon,
                    //   scale: 8,
                    // ),
                    Text(
                      StringConstant.logoutPopup,
                      style: CustomTextStyle.body3,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    popUpButton(context)
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget tokenList() {
    return SizedBox(
      width: double.maxFinite,
      child: ListView.builder(
          itemCount: tokenData.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                width: double.infinity,
                height: 6.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.darkGrey),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₮ " + tokenData[index].token.toString(),
                      style: TextStyle(
                          color: AppColor.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp),
                    ),
                    Text(tokenData[index].tokenPrice.toString(),
                        style: CustomTextStyle.body3),
                    GestureDetector(
                      onTap: () async {
                        if (mounted) {
                          setState(() {
                            isLoading = true;
                          });
                        }

                        FormData data =
                            FormData.fromMap({"token": tokenData[index].token});
                        await ApiService()
                            .tokenPurchase(
                                context: context,
                                data: data,
                                userRegisterModel: user!)
                            .then((value) async {
                          getUserData = await ApiService().getUserData(
                              context: context, userRegisterModel: user!);
                        });
                        Navigator.pop(context);

                        if (mounted) {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: Text(
                        tokenData[index].buy.toString(),
                        style: CustomTextStyle.body3,
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget popUpButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        CoustomSmallBlackButton(
          onPressed: () {
            Get.back();
          },
          title: StringConstant.cancel,
          style: CustomTextStyle.body1
              .copyWith(fontFamily: CustomTextStyle.fontFamilyMontserrat),
        ),
        CoustomSmallButton(
          onPressed: () {
            clearData();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false);
          },
          title: StringConstant.yes,
          style: CustomTextStyle.body1.copyWith(
              color: AppColor.black,
              fontWeight: FontWeight.w600,
              fontFamily: CustomTextStyle.fontFamilyMontserrat),
        )
      ],
    );
  }

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

  Widget accountInfo(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => UpdateProfile()))
            .then((value) async {
          await getdata();
        });
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
        Get.to(ReferFriend());
      },
      trailing: Icon(
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
      trailing: Icon(
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
        Get.to(TermsAndCondition());
      },
      trailing: Icon(
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
}
