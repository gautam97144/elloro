import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_icon.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/model/user_register_model.dart';
import 'package:elloro/provider/internet_connectivity.dart';
import 'package:elloro/screen/loader/loader.dart';
import 'package:elloro/screen/privacy_policy_screen/privacy_policy.dart';
import 'package:elloro/screen/terms_and_condition_screen/terms_and_condition_screen.dart';
import 'package:elloro/screen/version_screen/internet_connectivity/second_screen.dart';
import 'package:elloro/services/auth_service.dart';
import 'package:elloro/validation/validation.dart';
import 'package:elloro/widget/custom_dialog.dart';
import 'package:elloro/widget/texteditingcontroller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/screen/forgot_password/forgot_password.dart';
import 'package:elloro/screen/login_screen/login_screen.dart';
import 'package:elloro/widget/custom_large_yellow_button.dart';
import 'package:elloro/widget/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import '../controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GetController getController = Get.put(GetController());

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController referralController = TextEditingController();

  final FocusNode referralFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  UserRegisterModel? userRegisterModel;
  bool obscureTextNewPassword = true;
  bool value = false;
  bool isImageValidate = false;
  bool isConfirmTermsAndPoclicy = false;
  bool isLoader = false;
  bool isCheck = false;

  File? image;
  final formKey = GlobalKey<FormState>();

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      print(image);
      if (image == null) return;

      final imagetemporary = File(image.path);
      setState(() {
        this.image = imagetemporary;
        Navigator.pop(context);
        isImageValidate = true;
        print(isImageValidate);
      });
    } on PlatformException catch (e) {
      print('Failed to Pick Image $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MyTextController.nameController.clear();
    MyTextController.passwordController.clear();
    MyTextController.emailController.clear();
    MyTextController.referralCodeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(children: [
          Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                toolbarHeight: 11.h,
                backgroundColor: Colors.black,
                title: Text(
                  StringConstant.registration,
                  style: CustomTextStyle.headline2,
                ),
              ),
              body: SafeArea(
                  child: Form(
                key: formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        uploadImageBanner(),
                        SizedBox(
                          height: 3.5.h,
                        ),
                        Text(
                          StringConstant.name,
                          style: CustomTextStyle.body1,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        nameField(),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          StringConstant.emailAddress,
                          style: CustomTextStyle.body1,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        emailAddress(),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          StringConstant.password + " (Minimum 8 character)",
                          style: CustomTextStyle.body1,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        passwordField(),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          StringConstant.referralCode,
                          style: CustomTextStyle.body1,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        referralField(),
                        SizedBox(
                          height: 2.h,
                        ),
                        termsAndCondition(),
                        SizedBox(
                          height: 2.h,
                        ),
                        registerButton(),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [alreadyAccountBanner()])
                      ],
                    ),
                  ),
                ),
              ))),
          Provider.of<InternetConnectivityCheck>(context, listen: true)
                  .isNoInternet
              ? const NoInternetSecond()
              : const SizedBox.shrink(),
          isLoader == true ? const CustomLoader() : const SizedBox.shrink()
        ]));
  }

  Widget uploadImageBanner() {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          image == null
              ? Container(
                  height: 15.h,
                  width: 30.w,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(Images.profileImage)),
                    // border: Border.all(color: AppColor.primarycolor),
                    borderRadius: BorderRadius.circular(22),
                  ),
                )
              : Container(
                  height: 15.h,
                  width: 30.w,
                  decoration: BoxDecoration(
                      color: AppColor.grey,
                      borderRadius: BorderRadius.circular(22),
                      image: DecorationImage(
                          image: Image.file(
                            image!,
                            fit: BoxFit.fill,
                          ).image,

                          // image: image == null
                          //     ?
                          //                     //     :

                          fit: BoxFit.cover)),
                ),
          Positioned(
              right: -5,
              bottom: 0,
              child: InkWell(
                  onTap: () {
                    bottomSheet();
                  },
                  child: SvgPicture.asset(Images.uploadLogo)))
        ],
      ),
    );
  }

  Widget nameField() {
    return CustomInPutField(
        validator: (value) => Validation.nameValidation(value!),
        fieldController: MyTextController.nameController,
        hint: StringConstant.nameHintText,
        hintStyle: CustomTextStyle.body4);
  }

  Widget emailAddress() {
    return CustomInPutField(
        validator: (value) => Validation.emailValidation(value!),
        fieldController: MyTextController.emailController,
        hint: StringConstant.emailHintText,
        hintStyle: CustomTextStyle.body4);
  }

  Widget passwordField() {
    return CustomInPutField(
        validator: (value) => Validation.validatePassword(value!),
        fieldController: MyTextController.passwordController,
        suffixIcon: suffixIconOfNewPassword(),
        focusNode: passwordFocusNode,
        obscureText: obscureTextNewPassword,
        hint: StringConstant.passwordHintText,
        onEditingComplete: () {
          FocusScope.of(context).requestFocus(referralFocusNode);
        },
        hintStyle: CustomTextStyle.body4);
  }

  Widget referralField() {
    return TextFormField(
      controller: MyTextController.referralCodeController,
      style: CustomTextStyle.body5,
      cursorColor: AppColor.primarycolor,
      focusNode: referralFocusNode,
      decoration: InputDecoration(
        hintText: StringConstant.referralCodeHintText,
        hintStyle: CustomTextStyle.body4,
        suffixIcon: referralcodeIcon(),

        filled: true,
        fillColor: AppColor.grey.withOpacity(.12),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColor.grey.withOpacity(.22))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColor.primarycolor)),
        // hintText: widget.hint,
        // hintStyle: widget.hintStyle,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey)),
        //  focusColor: AppColor.primarycolor
      ),
    );
  }

  Widget registerButton() {
    return CustomLargeButton(
      onPressed: () async {
        // if (image == null) {
        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //       backgroundColor: Colors.red,
        //       content: Text(
        //         "please select your profile picture",
        //       )));
        // }
        if (isCheck == false) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "please confirm terms and condition",
              )));
        }

        if (formKey.currentState!.validate() &&
            // image != null &&
            isCheck == true) {
          FormData userData = FormData.fromMap({
            "name": MyTextController.nameController.text,
            "email": MyTextController.emailController.text,
            "password": MyTextController.passwordController.text,
            "referral_code": MyTextController.referralCodeController.text,
            "image":
                image == null ? "" : await MultipartFile.fromFile(image!.path),
            "device_token": "aaa"
          });

          setState(() {
            isLoader = true;
          });
          userRegisterModel =
              await ApiService().userRegister(context: context, data: userData);

          print(userRegisterModel?.toJson().toString());

          setState(() {
            isLoader = false;
          });
        }
      },
      title: Text(
        StringConstant.ragistor,
        style: CustomTextStyle.body2,
      ),
    );
  }

  Widget alreadyAccountBanner() {
    return RichText(
      text: TextSpan(
          text: StringConstant.alreadyAccount,
          style: CustomTextStyle.body3.copyWith(color: AppColor.white),
          children: [
            TextSpan(
                text: " " + StringConstant.login,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        )
                      },
                style: CustomTextStyle.body3
                    .copyWith(color: AppColor.primarycolor))
          ]),
    );
  }

  Widget suffixIconOfNewPassword() {
    return IconButton(
      color: AppColor.grey,
      icon: obscureTextNewPassword == true
          ? Icon(
              Icons.visibility_off,
            )
          : Icon(
              Icons.visibility,
            ),
      onPressed: () {
        setState(() {
          obscureTextNewPassword = !obscureTextNewPassword;
        });
      },
    );
  }

  Widget termsAndCondition() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isCheck = !isCheck;
            });
          },
          child: isCheck == false
              ? const Icon(
                  Icons.check_box_outline_blank,
                  color: AppColor.primarycolor,
                )
              : const Icon(
                  Icons.check_box_outlined,
                  color: AppColor.primarycolor,
                ),
        ),
        SizedBox(
          width: 2.w,
        ),
        RichText(
          text: TextSpan(
              text: StringConstant.confirm,
              style: CustomTextStyle.body4.copyWith(color: AppColor.white),
              children: [
                TextSpan(
                    text: StringConstant.terms,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.to(() => TermsAndCondition()),
                    style: CustomTextStyle.body4.copyWith(
                        color: AppColor.primarycolor,
                        decoration: TextDecoration.underline)),
                TextSpan(
                    text: " " + StringConstant.and,
                    recognizer: TapGestureRecognizer()..onTap = () => {},
                    style:
                        CustomTextStyle.body4.copyWith(color: AppColor.white)),
                TextSpan(
                    text: StringConstant.privacy,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.to(() => PrivacyAndPolicy()),
                    style: CustomTextStyle.body4.copyWith(
                        color: AppColor.primarycolor,
                        decoration: TextDecoration.underline))
              ]),
        )
      ],
    );
  }

  Future bottomSheet() {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        backgroundColor: AppColor.primarycolor,

        // Colors.white,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              height: 16.h,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.clear,
                        ),
                      )
                    ],
                  ),
                  Row(children: [
                    const Icon(Icons.image_outlined),
                    SizedBox(width: 2.w),
                    InkWell(
                      onTap: () {
                        permissionHandlerStorage();
                      },
                      child: Text(
                        "Gallery",
                        style:
                            CustomTextStyle.body1.copyWith(color: Colors.black),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 3.h,
                  ),
                  Row(children: [
                    const Icon(Icons.camera_alt_outlined),
                    SizedBox(
                      width: 2.w,
                    ),
                    InkWell(
                      onTap: () {
                        permissionHandlerCamera();
                      },
                      child: Text(
                        "Camera",
                        style:
                            CustomTextStyle.body1.copyWith(color: Colors.black),
                      ),
                    ),
                  ]),
                ],
              ),
            );
          });
        });
  }

  Future<void> permissionHandlerCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      await pickImage(ImageSource.camera);
      // Navigator.pop(context);
    } else {
      print("denied");
    }
  }

  Future<void> permissionHandlerStorage() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      await pickImage(ImageSource.gallery);
      // Navigator.pop(context);
    } else {
      print("denied");
    }
  }

  Widget referralcodeIcon() {
    return IconButton(
      color: AppColor.grey,
      icon: SvgPicture.asset(
        AppIcon.referIcon,
      ),
      onPressed: () {
        referralButtonPopUp();
      },
    );
  }

  cleardata() {
    MyTextController.passwordController.clear();
    MyTextController.emailController.clear();
    MyTextController.referralCodeController.clear();
    MyTextController.nameController.clear();
    image = null;

    isCheck = false;
  }

  Future referralButtonPopUp() {
    return showDialog(
        context: context,
        builder: (context) {
          return PopUp(
            content: Text(
              "Enter a referral code if you have one",
              style: CustomTextStyle.body1,
            ),
          );
        });
  }
}
