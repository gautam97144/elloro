import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/model/get_user_data.dart';
import 'package:elloro/model/user_register_model.dart';
import 'package:elloro/provider/internet_connectivity.dart';
import 'package:elloro/provider/provider.dart';
import 'package:elloro/screen/loader/loader.dart';
import 'package:elloro/screen/version_screen/internet_connectivity/second_screen.dart';
import 'package:elloro/services/auth_service.dart';
import 'package:elloro/widget/custom_large_black_button.dart';
import 'package:elloro/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController uniqueidController = TextEditingController();

  final FocusNode createButtonFocusNode = new FocusNode();

  UserRegisterModel? user;
  bool isLoader = false;
  GetUserData? getUserData;
  String? bannername;
  bool isButtonActive = false;
  bool isImageActive = false;
  File? image;
  String? oldImage;
  bool newImage = false;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      print(image);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
        newImage = true;
        Navigator.pop(context);
        isImageActive = true;
        //  isImageValidate = true;
        // print(isImageValidate);
      });
    } on PlatformException catch (e) {
      print('Failed to Pick Image $e');
    }
  }

  getdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      user = UserRegisterModel.fromJson(
          jsonDecode(preferences.getString('user') ?? ''));
    });

    // print(getdata());

    // print(user!.apiToken.toString());

    // getUserData = await ApiService()
    //     .getUserData(context: context, userRegisterModel: user!);
    // setState(() {});
    //
    nameController.text = user?.name ?? "";
    emailController.text = user?.email ?? "";
    uniqueidController.text = user?.uniqueId ?? "";
    oldImage = user?.image ?? "";
    bannername = user?.name ?? "";

    print(user?.image);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // getdata();

    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    user = Provider.of<UserProvider>(context, listen: false).getUser!;
    //
    nameController.text = user?.name ?? "";
    emailController.text = user?.email ?? "";
    uniqueidController.text = user?.uniqueId ?? "";
    oldImage = user?.image ?? "";
    bannername = user?.name ?? "";
    // // });

    nameController.addListener(() {
      final isButtonActive = nameController.text.isNotEmpty;

      setState(() {
        this.isButtonActive = isButtonActive;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(children: [
        Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Images.uploadAccount),
                    fit: BoxFit.cover)),
            child: Scaffold(
                appBar: AppBar(
                  toolbarHeight: 12.h,
                  title: Text(StringConstant.accountInfo,
                      style: CustomTextStyle.headline2),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                backgroundColor: Colors.transparent,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    uploadImageBanner(),
                    SizedBox(
                      height: 1.h,
                    ),
                    usernameBanner(),
                    SizedBox(
                      height: 5.h,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 24),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                nameBanner(),
                                SizedBox(
                                  height: 1.h,
                                ),
                                nameField(),
                                SizedBox(
                                  height: 3.h,
                                ),
                                emailBanner(),
                                SizedBox(
                                  height: 1.h,
                                ),
                                emailFeild(),
                                SizedBox(
                                  height: 3.h,
                                ),
                                uniqueIdBanner(),
                                SizedBox(height: 1.h),
                                uniqueId(),
                                SizedBox(height: 5.h),
                                editButton(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ))),
        Provider.of<InternetConnectivityCheck>(context, listen: true)
                .isNoInternet
            ? const NoInternetSecond()
            : const SizedBox.shrink(),
        isLoader == true ? const CustomLoader() : const SizedBox.shrink()
      ]),
    );
  }

  Widget nameField() {
    return CustomInPutField(
        fieldController: nameController,
        //  hint: StringConstant.nameHintText,
        hintStyle: CustomTextStyle.body4);
  }

  Widget emailFeild() {
    return CustomInPutField(
        readOnly: true,
        fieldController: emailController,
        hintStyle: CustomTextStyle.body4);
  }

  Widget uniqueId() {
    return CustomInPutField(
        readOnly: true,
        fieldController: uniqueidController,
        hintStyle: CustomTextStyle.body4);
  }

  Widget nameBanner() {
    return Text(
      StringConstant.name,
      style: CustomTextStyle.body1,
    );
  }

  Widget emailBanner() {
    return Text(
      StringConstant.emailAddress,
      style: CustomTextStyle.body1,
    );
  }

  Widget uniqueIdBanner() {
    return Text(
      StringConstant.uniqueId,
      style: CustomTextStyle.body1,
    );
  }

  Widget editButton() {
    return CustomLargeBlackButton(
        focusNode: createButtonFocusNode,
        title: Text(
          StringConstant.edit,
          style: CustomTextStyle.body2.copyWith(color: Colors.black),
        ),
        onPressed: isButtonActive == true || isImageActive == true
            ? () async {
                setState(() {
                  isButtonActive = false;
                  // isImageActive = false;
                  //   nameController.clear();
                });

                FormData data = FormData.fromMap({
                  "image": newImage == true
                      ? await MultipartFile.fromFile(image!.path)
                      : "",
                  "name": nameController.text
                });

                setState(() {
                  isLoader = true;
                });
                UserRegisterModel? updateUserModel = await ApiService()
                    .updateProfile(
                        context: context, data: data, userRegisterModel: user!);

                print(updateUserModel?.toJson().toString());

                // getUserData = await ApiService()
                //     .getUserData(context: context, userRegisterModel: user!);

                setState(() {
                  isLoader = false;
                });
              }
            : null);
  }

  Widget uploadImageBanner() {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: newImage == true
                ? Container(
                    height: 15.h,
                    width: 30.w,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.file(image!).image,
                    )),
                  )
                : CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: '$oldImage',
                    height: 15.h, width: 30.w,
                    errorWidget: (context, url, error) => Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                Images.profileImage,
                              ))),
                    ),

                    placeholder: (context, url) => Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                Images.profileImage,
                              ))),
                    ),
                    //
                  ),
          ),
          Positioned(
              right: -5,
              bottom: 0,
              child: InkWell(
                  onTap: () {
                    bootomsheet();
                    //   PickImage();
                  },
                  child: SvgPicture.asset(Images.uploadLogo)))
        ],
      ),
    );
  }

  Future bootomsheet() {
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

  Widget usernameBanner() {
    return Text(
      bannername ?? "",
      style: CustomTextStyle.body1.copyWith(fontSize: 14.sp),
    );
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
}
