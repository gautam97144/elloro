import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_icon.dart';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/model/MusicDataModel.dart';
import 'package:elloro/model/cataloge_list_model.dart';
import 'package:elloro/model/get_user_data.dart';
import 'package:elloro/model/user_register_model.dart';
import 'package:elloro/provider/internet_connectivity.dart';
import 'package:elloro/provider/internet_connectivity_one%20time.dart';
import 'package:elloro/provider/provider.dart';
import 'package:elloro/screen/bottom_navigation/bottom_navigation.dart';
import 'package:elloro/screen/database/database.dart';
import 'package:elloro/screen/loader/loader.dart';
import 'package:elloro/screen/music_player/music_player_screen.dart';
import 'package:elloro/services/auth_service.dart';
import 'package:elloro/widget/custom_black_textfield.dart';
import 'package:elloro/widget/custom_button.dart';
import 'package:elloro/widget/custom_dialog.dart';
import 'package:elloro/widget/custom_playnow_button.dart';
import 'package:elloro/widget/custom_profile_picture.dart';
import 'package:elloro/widget/custom_small_black_button.dart';
import 'package:elloro/widget/custom_small_yellow_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:numeral/numeral.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../version_screen/internet_connectivity/internet_connectivity_screen.dart';
import 'package:dio/dio.dart';

class MusicCatalog extends StatefulWidget {
  const MusicCatalog({Key? key}) : super(key: key);

  @override
  _MusicCatalogState createState() => _MusicCatalogState();
}

class _MusicCatalogState extends State<MusicCatalog> {
  bool isPopOpen = false;
  bool isPopUplose = false;
  bool isDownloadPopUpOpen = false;
  String downloadIndicator = '0 %';
  double downloadRatio = 0.0;
  String? path;
  bool downloading = false;
  UserRegisterModel? user;
  ScrollController? controller;
  Offset offset = Offset(20, 40);
  GetUserData? getUserData;
  int? index;
  int? catalogeIndex;
  int? catalogi;
  Categories? categories;
  CataLogList? catalogeList;
  bool isLoader = false;
  bool isLinerOpen = false;
  OverlayEntry? entry;
  bool isPlaying = false;
  bool isClosePopup = false;
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPopPlay = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isLoading = false;

  NumberFormat format = NumberFormat.simpleCurrency(locale: "mnt");
  TextEditingController textEditingController = TextEditingController();

  getToken() async {
    user = await Provider.of<UserProvider>(context, listen: false).getUser!;

    await Provider.of<InternetConnectivityCheck>(context, listen: false)
        .checkRealTimeConnectivity();

    await Provider.of<InternetConnectivityCheckOneTime>(context, listen: false)
        .checkOneTimeConnectivity();

    if (mounted) {
      if (!Provider.of<InternetConnectivityCheckOneTime>(context, listen: false)
              .isOneTimeInternet &&
          !Provider.of<InternetConnectivityCheck>(context, listen: false)
              .isNoInternet) {
        getUserData = await ApiService()
            .getUserData(context: context, userRegisterModel: user!);

        catalogeList = await ApiService().catalogeList(
          context: context,
          userRegisterModel: user!,
        );
      }

      if (mounted) {
        setState(() {
          getUserData;
          catalogeList;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(alignment: Alignment.center, children: [
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
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNavigation(
                                      index: index = 1,
                                    )),
                            (route) => false);
                      },
                      child: MyButton()
                          .tokenButton(getUserData?.data?.totalToken ?? "0"),
                    ),
                    SizedBox(width: 3.w),
                    CustomProfilePicture(
                      url: user?.image ?? "",
                    )
                  ],
                ),
              )
            ],
          ),
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 2.h,
                ),
                searchField(),
                // SizedBox(
                //   height: 2.h,
                // ),
                Expanded(
                    child: RefreshIndicator(
                        color: AppColor.primarycolor,
                        backgroundColor: AppColor.black,
                        onRefresh: () async {
                          catalogeList = await ApiService().catalogeList(
                            context: context,
                            userRegisterModel: user!,
                          );
                          getUserData = await ApiService().getUserData(
                              context: context, userRegisterModel: user!);

                          setState(() {
                            getUserData;
                          });
                        },
                        child: catalogeList?.data?.isEmpty == 0
                            ? Center(
                                child: Text(
                                  "No any Data",
                                  style: CustomTextStyle.body1,
                                ),
                              )
                            : catalogeList?.data == null ||
                                    catalogeList?.data == []
                                ? Center(
                                    // heightFactor: 1.h,
                                    child: LoadingAnimationWidget
                                        .staggeredDotsWave(
                                            color: AppColor.primarycolor,
                                            size: 45),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: catalogeList != null
                                        ? catalogeList?.data?.length
                                        : 0,
                                    itemBuilder: (context, index) {
                                      return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 2.h,
                                            ),
                                            Text(
                                              "${catalogeList?.data?[index].category}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: CustomTextStyle.body1
                                                  .copyWith(
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.w900),
                                            ),
                                            for (int i = 0;
                                                i <
                                                    catalogeList!.data![index]
                                                        .categorydata!.length;
                                                i++)
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      //progressbarPopUp(context);
                                                    },
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          "${catalogeList?.data?[index].categorydata?[i].image}",
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                              width: 80,
                                                              height: 82,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              14),
                                                                  image: DecorationImage(
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      image:
                                                                          imageProvider))),
                                                      placeholder:
                                                          (context, url) =>
                                                              Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        width: 80,
                                                        height: 82,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColor.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(14),
                                                        ),
                                                        child: Center(
                                                          child: Image.asset(
                                                            Images.onlyLogo,
                                                            scale: 4,
                                                            color: AppColor
                                                                .darkGrey,
                                                          ),
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        width: 80,
                                                        height: 82,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColor.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(14),
                                                        ),
                                                        child: Center(
                                                          child: Image.asset(
                                                            Images.onlyLogo,
                                                            scale: 4,
                                                            color: AppColor
                                                                .darkGrey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 2.w,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      width: 50,
                                                      height: 95,
                                                      //width: double.infinity,
                                                      //color: Colors.red,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 5),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                    child: catalogeList!.data![index].categorydata![i].title!.length >=
                                                                            28
                                                                        ? Text(
                                                                            "${catalogeList?.data?[index].categorydata?[i].title?.substring(0, 28)}",
                                                                            style:
                                                                                CustomTextStyle.body3.copyWith(fontSize: 12.sp),
                                                                            maxLines:
                                                                                1,
                                                                            // overflow:
                                                                            //     TextOverflow.ellipsis,
                                                                          )
                                                                        : Text(
                                                                            "${catalogeList?.data?[index].categorydata?[i].title}",
                                                                            style:
                                                                                CustomTextStyle.body3.copyWith(fontSize: 12.sp),
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ))
                                                              ],
                                                            ),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      "${catalogeList?.data?[index].categorydata?[i].creatorName}",
                                                                      style: CustomTextStyle
                                                                          .body4
                                                                          .copyWith(
                                                                              fontSize: 11.sp),
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  )
                                                                ]),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  child: Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            9.w,
                                                                        height:
                                                                            3.2.h,
                                                                        child: TextButton(
                                                                            onPressed: () {
                                                                              showDialog(
                                                                                builder: (context) {
                                                                                  return PopUp(
                                                                                      content: SingleChildScrollView(
                                                                                    child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                                        children: [
                                                                                          GestureDetector(
                                                                                            onTap: () {
                                                                                              Get.back();
                                                                                            },
                                                                                            child: const Icon(
                                                                                              Icons.clear,
                                                                                              color: AppColor.grey,
                                                                                              // size: 3.5.h,
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                      Container(
                                                                                        //   color: Colors.red,
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            CachedNetworkImage(
                                                                                              imageUrl: "${catalogeList?.data?[index].categorydata?[i].image}",
                                                                                              imageBuilder: (context, imageProvider) {
                                                                                                return Container(
                                                                                                  height: 60,
                                                                                                  width: 60,
                                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), image: DecorationImage(fit: BoxFit.cover, image: imageProvider)),
                                                                                                );
                                                                                              },
                                                                                              placeholder: (context, url) => Container(
                                                                                                padding: const EdgeInsets.all(10),
                                                                                                height: 60,
                                                                                                width: 60,
                                                                                                decoration: BoxDecoration(color: AppColor.grey, image: const DecorationImage(image: AssetImage(Images.onlyLogo)), borderRadius: BorderRadius.circular(15)),
                                                                                              ),
                                                                                              errorWidget: (context, url, error) => Container(
                                                                                                padding: const EdgeInsets.all(10),
                                                                                                height: 60,
                                                                                                width: 60,
                                                                                                decoration: BoxDecoration(color: AppColor.grey, image: const DecorationImage(image: AssetImage(Images.onlyLogo)), borderRadius: BorderRadius.circular(15)),
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 2.w,
                                                                                            ),
                                                                                            Expanded(
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                children: [
                                                                                                  catalogeList!.data![index].categorydata![i].title!.length >= 28
                                                                                                      ? Text(
                                                                                                          "${catalogeList?.data?[index].categorydata?[i].title?.substring(0, 28)}",
                                                                                                          maxLines: 2,
                                                                                                          overflow: TextOverflow.ellipsis,
                                                                                                          style: CustomTextStyle.body3.copyWith(color: AppColor.white),
                                                                                                        )
                                                                                                      : Text(
                                                                                                          "${catalogeList?.data?[index].categorydata?[i].title}",
                                                                                                          maxLines: 2,
                                                                                                          overflow: TextOverflow.ellipsis,
                                                                                                          style: CustomTextStyle.body3.copyWith(color: AppColor.white),
                                                                                                        ),
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(top: 6),
                                                                                                    child: Text(
                                                                                                      "${catalogeList?.data?[index].categorydata?[i].creatorName}",
                                                                                                      style: CustomTextStyle.body4,
                                                                                                      maxLines: 1,
                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                      //textAlign: TextAlign.center,
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),

                                                                                      SizedBox(
                                                                                        height: 2.h,
                                                                                      ),

                                                                                      Row(
                                                                                        //mainAxisSize: MainAxisSize.max,
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          ratingAndCount(index, i),
                                                                                          const Icon(
                                                                                            Icons.fiber_manual_record,
                                                                                            color: AppColor.white,
                                                                                            size: 7,
                                                                                          ),
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              SvgPicture.asset(AppIcon.clockIcon),
                                                                                              SizedBox(
                                                                                                width: 1.w,
                                                                                              ),
                                                                                              Text(
                                                                                                "${catalogeList?.data?[index].categorydata?[i].duration}",
                                                                                                style: CustomTextStyle.body1.copyWith(fontSize: 10.sp),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                          const Icon(
                                                                                            Icons.fiber_manual_record,
                                                                                            color: AppColor.white,
                                                                                            size: 7,
                                                                                          ),
                                                                                          Row(
                                                                                            children: [
                                                                                              SvgPicture.asset(AppIcon.sizeIcon),
                                                                                              SizedBox(
                                                                                                width: 1.w,
                                                                                              ),
                                                                                              Text(
                                                                                                "${catalogeList?.data?[index].categorydata?[i].musicFileSize}",
                                                                                                style: CustomTextStyle.body1.copyWith(fontSize: 10.sp),
                                                                                              )
                                                                                            ],
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(height: 2.h),

                                                                                      catalogeList!.data![index].categorydata![i].description!.length >= 512
                                                                                          ? Text(
                                                                                              "${catalogeList?.data?[index].categorydata?[i].description?.substring(0, 512)}",
                                                                                              style: CustomTextStyle.body1,
                                                                                            )
                                                                                          : Text(
                                                                                              "${catalogeList?.data?[index].categorydata?[i].description}",
                                                                                              style: CustomTextStyle.body1,
                                                                                            ),
                                                                                      SizedBox(
                                                                                        height: 2.h,
                                                                                      ),
                                                                                      Text(
                                                                                        "About ${catalogeList?.data?[index].categorydata?[i].creatorName}",

                                                                                        // maxLines: 1,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        style: CustomTextStyle.body3,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 1.h,
                                                                                      ),
                                                                                      catalogeList!.data![index].categorydata![i].creatorAbout!.length >= 512
                                                                                          ? Text(
                                                                                              "${catalogeList?.data?[index].categorydata?[i].creatorAbout?.substring(0, 512)}",
                                                                                              style: CustomTextStyle.body1,
                                                                                              textAlign: TextAlign.start,
                                                                                            )
                                                                                          : Text(
                                                                                              "${catalogeList?.data?[index].categorydata?[i].creatorAbout}",
                                                                                              style: CustomTextStyle.body1,
                                                                                              textAlign: TextAlign.start,
                                                                                            ),
                                                                                      //image(),
                                                                                      SizedBox(height: 3.h),

                                                                                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                                        catalogeList?.data?[index].categorydata?[i].isFree == 1 && catalogeList?.data?[index].categorydata?[i].isPurchased == 0
                                                                                            ? GestureDetector(
                                                                                                onTap: () async {
                                                                                                  FormData data = FormData.fromMap({
                                                                                                    "catalogue_id": catalogeList?.data?[index].categorydata?[i].catalogueId,
                                                                                                    "token_price": catalogeList?.data?[index].categorydata?[i].isFree == 1 ? "0" : catalogeList?.data?[index].categorydata?[i].tokenPrice,
                                                                                                  });

                                                                                                  setState(() {
                                                                                                    isLoading = true;
                                                                                                  });

                                                                                                  int? status = await ApiService()
                                                                                                      .purchase(
                                                                                                    context: context,
                                                                                                    data: data,
                                                                                                    userRegisterModel: user!,
                                                                                                    //   message: isPurchasedTrue
                                                                                                  )
                                                                                                      .whenComplete(() {
                                                                                                    Navigator.pop(context);
                                                                                                  });
                                                                                                  setState(() {
                                                                                                    isLoading = false;
                                                                                                  });

                                                                                                  getUserData = await ApiService().getUserData(context: context, userRegisterModel: user!);

                                                                                                  if (status == 1) {
                                                                                                    //Navigator.pop(context);

                                                                                                    if (mounted) {
                                                                                                      setState(() {
                                                                                                        catalogeList?.data?[index].categorydata?[i].isPurchased = 1;
                                                                                                      });
                                                                                                    }
                                                                                                    downloadNowPopUp(context, index, i);
                                                                                                  }
                                                                                                },
                                                                                                child: Container(
                                                                                                  alignment: Alignment.center,
                                                                                                  height: 4.h,
                                                                                                  width: 20.w,
                                                                                                  decoration: const ShapeDecoration(
                                                                                                    shape: StadiumBorder(side: BorderSide(width: 2, color: AppColor.blue)),
                                                                                                  ),
                                                                                                  child: Center(
                                                                                                    child: Text(
                                                                                                      "Free",
                                                                                                      style: TextStyle(color: AppColor.blue, fontSize: 12.sp),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              )
                                                                                            : catalogeList?.data?[index].categorydata?[i].isPurchased == 1
                                                                                                ? Visibility(visible: true, child: MyButton.purchasedButton())
                                                                                                : Visibility(
                                                                                                    visible: true,
                                                                                                    child: GestureDetector(
                                                                                                      onTap: () {
                                                                                                        audioPurchasePopUp(context, index, i);

                                                                                                        if (isClosePopup == true) {
                                                                                                          Navigator.pop(context);
                                                                                                        }
                                                                                                      },
                                                                                                      child: Container(
                                                                                                        alignment: Alignment.center,
                                                                                                        height: 4.h,
                                                                                                        width: 20.w,
                                                                                                        decoration: const ShapeDecoration(
                                                                                                          shape: StadiumBorder(side: BorderSide(width: 2, color: AppColor.blue)),
                                                                                                        ),
                                                                                                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                                                          Text(format.currencySymbol, style: TextStyle(color: AppColor.blue, fontSize: 12.sp)),
                                                                                                          const SizedBox(
                                                                                                            width: 2,
                                                                                                          ),
                                                                                                          Text(
                                                                                                            Numeral(double.parse(catalogeList?.data?[index].categorydata?[i].tokenPrice?.replaceAll(",", "") ?? "0")).value(),
                                                                                                            style: CustomTextStyle.body6.copyWith(fontSize: 12.sp),
                                                                                                          ),
                                                                                                        ]),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                      ])
                                                                                    ]),
                                                                                  ));
                                                                                },
                                                                                context: context,
                                                                              );
                                                                            },
                                                                            style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.all(.2.h)), backgroundColor: MaterialStateProperty.all(Colors.black), foregroundColor: MaterialStateProperty.all(AppColor.grey), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), side: MaterialStateProperty.all(BorderSide(color: AppColor.grey, width: 2, style: BorderStyle.solid))),
                                                                            child: const Icon(
                                                                              Icons.more_horiz,
                                                                              color: AppColor.grey,
                                                                            )),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            1.w,
                                                                      ),
                                                                      ratingAndCount(
                                                                          index,
                                                                          i),
                                                                      SizedBox(
                                                                        width:
                                                                            1.w,
                                                                      ),
                                                                      volumeSymbol(
                                                                          index,
                                                                          i)
                                                                    ],
                                                                  ),
                                                                ),
                                                                catalogeList?.data?[index].categorydata?[i].isFree ==
                                                                            1 &&
                                                                        catalogeList?.data?[index].categorydata?[i].isPurchased ==
                                                                            0
                                                                    ? GestureDetector(
                                                                        onTap:
                                                                            () async {
                                                                          FormData
                                                                              data =
                                                                              FormData.fromMap({
                                                                            "catalogue_id":
                                                                                catalogeList?.data?[index].categorydata?[i].catalogueId,
                                                                            "token_price": catalogeList?.data?[index].categorydata?[i].isFree == 1
                                                                                ? "0"
                                                                                : catalogeList?.data?[index].categorydata?[i].tokenPrice,
                                                                          });

                                                                          setState(
                                                                              () {
                                                                            isLoading =
                                                                                true;
                                                                          });

                                                                          int?
                                                                              status =
                                                                              await ApiService().purchase(
                                                                            context:
                                                                                context,
                                                                            data:
                                                                                data,
                                                                            userRegisterModel:
                                                                                user!,
                                                                            //   message: isPurchasedTrue
                                                                          );
                                                                          setState(
                                                                              () {
                                                                            isLoading =
                                                                                false;
                                                                          });

                                                                          getUserData = await ApiService().getUserData(
                                                                              context: context,
                                                                              userRegisterModel: user!);

                                                                          if (status ==
                                                                              1) {
                                                                            //Navigator.pop(context);

                                                                            if (mounted) {
                                                                              setState(() {
                                                                                catalogeList?.data?[index].categorydata?[i].isPurchased = 1;
                                                                              });
                                                                            }
                                                                            downloadNowPopUp(
                                                                                context,
                                                                                index,
                                                                                i);
                                                                          }
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          height:
                                                                              4.2.h,
                                                                          width:
                                                                              20.w,
                                                                          decoration:
                                                                              const ShapeDecoration(
                                                                            shape:
                                                                                StadiumBorder(side: BorderSide(width: 2, color: AppColor.blue)),
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              "Free",
                                                                              style: TextStyle(color: AppColor.blue, fontSize: 12.sp),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : catalogeList?.data?[index].categorydata?[i].isPurchased ==
                                                                            1
                                                                        ? Visibility(
                                                                            visible:
                                                                                true,
                                                                            child:
                                                                                MyButton.purchasedButton())
                                                                        : Visibility(
                                                                            visible:
                                                                                true,
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {
                                                                                audioPurchasePopUp(context, index, i);
                                                                              },
                                                                              child: Container(
                                                                                alignment: Alignment.center,
                                                                                height: 4.2.h,
                                                                                width: 20.w,
                                                                                decoration: const ShapeDecoration(
                                                                                  shape: StadiumBorder(side: BorderSide(width: 2, color: AppColor.blue)),
                                                                                ),
                                                                                child: Center(
                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                                    Text(format.currencySymbol, style: TextStyle(color: AppColor.blue, fontSize: 12.sp)),
                                                                                    const SizedBox(
                                                                                      width: 2,
                                                                                    ),
                                                                                    Text(
                                                                                      Numeral(double.parse("${catalogeList?.data?[index].categorydata?[i].tokenPrice?.replaceAll(",", "")}")).value(),
                                                                                      style: CustomTextStyle.body6.copyWith(fontSize: 12.sp),
                                                                                    ),
                                                                                  ]),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
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
                                  ))),
              ],
            ),
          )),
        ),
        Provider.of<InternetConnectivityCheck>(context, listen: true)
                    .isNoInternet ||
                Provider.of<InternetConnectivityCheckOneTime>(context,
                        listen: true)
                    .isOneTimeInternet
            ? const InternetConnectivity()
            : const SizedBox.shrink(),
        isPopOpen == true
            ? samplePopUp(catalogeIndex!, catalogi!)
            : const SizedBox.shrink(),
        isDownloadPopUpOpen == true ? container() : const SizedBox.shrink(),
        isLoading == true ? const CustomLoader() : const SizedBox.shrink()
      ]),
    );
  }

  //widget

  Widget catagoriesBanner() {
    return Text(
      StringConstant.meditation,
      style: CustomTextStyle.body1
          .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w900),
    );
  }

  //
  Widget playButton(
    context,
    int index,
    int i,
    //id,
  ) {
    return CustomPlayNowButton(
      onPressed: () async {
        FormData data = FormData.fromMap({
          "catalogue_id":
              catalogeList?.data?[index].categorydata?[i].catalogueId
        });
        await ApiService().catalogDetails(
            context: context, userRegisterModel: user!, data: data);

        Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => MusicPlayerScreen(index: i)))
            .then((value) async {
          await ApiService()
              .purchaseCatalogList(context: context, userRegisterModel: user!);
          setState(() {});
        });
      },
    );
  }

  Widget catagoriesBannerTwo() {
    return Text(
      StringConstant.sleepAnxiety,
      style: CustomTextStyle.body1
          .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w900),
    );
  }

  Widget samplePopUp(int index, int i) {
    return Positioned(
      bottom: 2,
      left: 12,
      right: 12,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: .5.h),
        height: 7.5.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: AppColor.primarycolor,
            borderRadius: BorderRadius.circular(5)),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          CachedNetworkImage(
            imageBuilder: (context, imageProvider) {
              return Container(
                height: 5.h,
                width: 10.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                        fit: BoxFit.cover, image: imageProvider)),
              );
            },
            imageUrl: "${catalogeList?.data?[index].categorydata?[i].image}",
          ),
          SizedBox(
            width: 2.w,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "Play Sample: " +
                            "${catalogeList?.data?[index].categorydata?[i].title}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyle.body1
                            .copyWith(color: Colors.black, fontSize: 12)),
                    SizedBox(
                      height: .5.h,
                    ),
                    Expanded(
                      child: Text(
                        "${catalogeList?.data?[index].categorydata?[i].creatorName}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyle.body1
                            .copyWith(color: Colors.black, fontSize: 12),
                      ),
                    )
                  ]),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      if (isPlaying) {
                        audioPlayer.pause();
                      } else {
                        audioPlayer.play(catalogeList
                                ?.data?[index].categorydata?[i].musicFile ??
                            "");
                      }
                      setState(() {
                        isPlaying = !isPlaying;
                      });
                    },
                    child: isPlaying == false
                        ? Icon(
                            Icons.play_arrow,
                            size: 3.5.h,
                          )
                        : Icon(
                            Icons.pause,
                            size: 3.5.h,
                          )),
                InkWell(
                    onTap: () {
                      setState(() {
                        isPopOpen = false;
                        isPlaying = false;
                        audioPlayer.stop();
                      });
                    },
                    child: Icon(
                      Icons.clear,
                      size: 3.5.h,
                    ))
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget searchField() {
    return CustomBlackInPutField(
      suffixIcon: GestureDetector(
        onTap: () {
          textEditingController.clear();
        },
        child: const Icon(
          Icons.cancel_outlined,
          color: AppColor.grey,
          size: 25,
        ),
      ),
      onChanged: (value) async {
        if (value == "") {
          FocusScope.of(context).unfocus();
          catalogeList = await ApiService()
              .searchcatalog(context: context, userRegisterModel: user!);
        }
        setState(() {
          catalogeList;
        });
      },
      onFieldSubmitted: (value) async {
        print(value);
        FormData formData = FormData.fromMap({"search": value});

        setState(() {
          isLoader = true;
        });

        catalogeList = await ApiService().searchcatalog(
            context: context,
            userRegisterModel: user!,
            data: formData,
            textEditingController: value);

        setState(() {
          catalogeList;
        });
        print(catalogeList.toString() + "hellllllo");

        setState(() {
          isLoader = false;
        });
      },
      fieldController: textEditingController,
      hint: StringConstant.search,
      hintStyle: CustomTextStyle.body1.copyWith(fontWeight: FontWeight.w800),
    );
  }

  Widget volumeSymbol(
    int index,
    int i,
  ) {
    return InkWell(
      onTap: () {
        if (isPlaying == true) {
          setState(() {
            audioPlayer.pause();
          });
        }

        isPlaying = true;

        print(isPlaying);

        audioPlayer.play(
            catalogeList?.data?[index].categorydata?[i].sampleMusicFile ?? "");

        setState(() {
          catalogeIndex = index;
          catalogi = i;
          isPopOpen = true;
        });
        // widget.miniplayer(categories);
        //
      },
      child: CircleAvatar(
        radius: 12,
        backgroundColor: AppColor.white,
        child: Icon(
          Icons.volume_up,
          color: Colors.black,
          size: 18,
        ),
      ),
    );
  }

  Widget image() {
    return AspectRatio(
      aspectRatio: 17 / 7,
      child: Container(
          // color: Colors.red,
          //height: 45.h,
          //width: 45.w,
          child: Image.asset(Images.feedBackImage)),
    );
  }

  Widget rating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(
          5,
          (index) => Row(
            children: [
              Icon(Icons.star, color: AppColor.primarycolor, size: 35),
              SizedBox(
                width: 2.w,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget aboutCreatorMore(int index) {
    return Text(
      "${catalogeList?.data?[index].categorydata?[index].creatorAbout}",
      style: CustomTextStyle.body1,
      textAlign: TextAlign.start,
    );
  }

  Widget ratingAndCount(int index, int i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.star,
          size: 2.2.h,
          color: AppColor.primarycolor,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            catalogeList?.data?[index].categorydata?[i].avgRate ?? "0",
            style: CustomTextStyle.body4.copyWith(fontSize: 11.sp),
          ),
        ),
      ],
    );
  }

  Future audioPurchasePopUp(BuildContext context, int index, int i) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopUp(
            content: Column(mainAxisSize: MainAxisSize.min, children: [
          // const Icon(
          //   Icons.cancel,
          //   color: AppColor.orange,
          //   size: 50,
          // ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            StringConstant.purchaseAudio,
            style: CustomTextStyle.body3,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 3.h,
          ),

          popButton(index, i)
        ]));
      },
    );
  }

  Widget popButton(int index, int i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        CoustomSmallBlackButton(
          onPressed: () {
            Navigator.pop(context);
          },
          title: StringConstant.cancel,
          style: CustomTextStyle.body1
              .copyWith(fontFamily: CustomTextStyle.fontFamilyMontserrat),
        ),
        CoustomSmallButton(
          onPressed: () async {
            Navigator.pop(context);

            FormData data = FormData.fromMap({
              "catalogue_id":
                  catalogeList?.data?[index].categorydata?[i].catalogueId,
              "token_price":
                  catalogeList?.data?[index].categorydata?[i].isFree == 1
                      ? "0"
                      : catalogeList?.data?[index].categorydata?[i].tokenPrice,
            });

            setState(() {
              isLoading = true;
            });

            int? status = await ApiService().purchase(
              context: context,
              data: data,
              userRegisterModel: user!,
              //   message: isPurchasedTrue
            );
            setState(() {
              isLoading = false;
            });

            getUserData = await ApiService()
                .getUserData(context: context, userRegisterModel: user!);

            if (status == 1) {
              //Navigator.pop(context);

              if (mounted) {
                setState(() {
                  catalogeList?.data?[index].categorydata?[i].isPurchased = 1;
                });
              }
              downloadNowPopUp(context, index, i);
            }
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

  Future downloadNowPopUp(BuildContext context, int index, int i) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopUp(
            content: Column(mainAxisSize: MainAxisSize.min, children: [
          // const Icon(
          //   Icons.cancel,
          //   color: AppColor.orange,
          //   size: 50,
          // ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            "Do you want to download this audio now?",
            style: CustomTextStyle.body3,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 3.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              CoustomSmallBlackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                title: "Later",
                style: CustomTextStyle.body1
                    .copyWith(fontFamily: CustomTextStyle.fontFamilyMontserrat),
              ),
              CoustomSmallButton(
                onPressed: () async {
                  Navigator.pop(context);

                  isDownloadPopUpOpen = true;

                  permission(
                      catalogeList
                              ?.data?[index].categorydata?[i].sampleMusicFile ??
                          "",
                      catalogeList?.data?[index].categorydata?[i].title,
                      index,
                      i);
                },
                title: StringConstant.yes,
                style: CustomTextStyle.body1.copyWith(
                    color: AppColor.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: CustomTextStyle.fontFamilyMontserrat),
              )
            ],
          )
        ]));
      },
      //  child:
    );
  }

  Widget container() {
    return Positioned(
      left: 12,
      right: 12,
      child: Container(
        decoration: BoxDecoration(
            color: AppColor.black, borderRadius: BorderRadius.circular(20)),
        padding: isPopUplose == true
            ? EdgeInsets.symmetric(
                horizontal: 4.w,
              )
            : EdgeInsets.symmetric(horizontal: 10.w),
        height: 10.h,
        alignment: Alignment.center,
        width: double.infinity,
        child: isPopUplose == true
            ? Visibility(
                visible: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(
                      flex: 2,
                    ),
                    Text("Download Successfully",
                        style: CustomTextStyle.body1
                            .copyWith(color: AppColor.primarycolor)),
                    const Spacer(),
                    IconButton(
                      iconSize: 3.h,
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isDownloadPopUpOpen = false;
                          isPopUplose = false;
                        });
                      },
                    )
                  ],
                ))
            : Visibility(
                visible: true,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        downloadIndicator.toString(),
                        style: TextStyle(color: AppColor.primarycolor),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      LinearProgressIndicator(
                        value: downloadRatio,
                        backgroundColor: AppColor.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColor.primarycolor),
                      ),
                    ]),
              ),
      ),
    );
  }

  Future<void> permission(url, filename, index, i) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      await downloadData(url, filename, index, i);
    } else {
      print("danied");
    }
  }

  Future downloadData(String url, String filename, int index, int i) async {
    Dio dio = Dio();
    CancelToken cancelToken = CancelToken();
    var directory = await getExternalStorageDirectory();
    path = directory!.path;
    String pathone = "$path/$filename";
    downloading = true;

    try {
      Response response = await dio.download(url, "$path/$filename",
          cancelToken: cancelToken,
          options: Options(), onReceiveProgress: (int recived, int total) {
        if (total != -1) {
          if (!cancelToken.isCancelled) {
            setState(() {
              downloadRatio = (recived / total);

              print(downloadRatio);

              if (downloadRatio == 1) {
                downloading = false;

                print(pathone);
                // setState(() {
                //   catalogeList?.data?[index].categorydata?[i].isIndicator = 1;
                // });
                DatabaseHelper.instance.addMusicData(Music(
                  musicTitle: catalogeList?.data?[index].categorydata?[i].title,
                  musicSubtitle:
                      catalogeList?.data?[index].categorydata?[i].subTitle,
                  musicDuration:
                      catalogeList?.data?[index].categorydata?[i].duration,
                  image: catalogeList?.data?[index].categorydata?[i].image,
                  path: pathone,
                  catalogId:
                      catalogeList?.data?[index].categorydata?[i].catalogueId,
                  musicFileSize:
                      catalogeList?.data?[index].categorydata?[i].musicFileSize,
                  creatorAbout:
                      catalogeList?.data?[index].categorydata?[i].creatorAbout,
                  description:
                      catalogeList?.data?[index].categorydata?[i].description,
                  creatorName:
                      catalogeList?.data?[index].categorydata?[i].creatorName,
                  userId: user?.userId,
                ));
              }

              downloadIndicator =
                  (downloadRatio * 100).toStringAsFixed(0) + "% completed";

              print(downloadIndicator);
            });
          }
        }
      }).whenComplete(() async {
        setState(() {
          isPopUplose = true;
          // catalogeList?.data?[index].categorydata?[i].isIndicator = 1;
        });

        downloadIndicator = 0.toString() + "% completed";
        FormData data = FormData.fromMap({
          "catalogue_id":
              catalogeList?.data?[index].categorydata?[i].catalogueId
        });

        await Provider.of<InternetConnectivityCheck>(context, listen: false)
            .checkRealTimeConnectivity();

        await Provider.of<InternetConnectivityCheckOneTime>(context,
                listen: false)
            .checkOneTimeConnectivity();

        if (!Provider.of<InternetConnectivityCheckOneTime>(context,
                    listen: false)
                .isOneTimeInternet ||
            !Provider.of<InternetConnectivityCheck>(context, listen: false)
                .isNoInternet) {
          await ApiService().addCatalogueDownload(
              context: context, userRegisterModel: user!, data: data);
        } else {
          print("no internet");
        }
      });

      print(response.statusCode);
    } on DioError catch (e) {
      print("hello kem cho");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColor.black,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Text(
            "Download Failed!",
            style: CustomTextStyle.body1.copyWith(color: AppColor.primarycolor),
          )));
      setState(() {
        isPopUplose = false;
        isDownloadPopUpOpen = false;
      });
      //  catalogeList?.data?[index].categorydata?[i].isIndicator = 3;
    }

    // DioError catch (e) {
    //   print(e);
    //   print("no data");
    //   if (cancelToken.isCancelled) {
    //     debugPrint('cancel Request' + e.message);
    //   }
    // } on Exception catch (e) {
    //   print("hello");
    //   print(e);
    //   debugPrint(e.toString());
    // }
  }
}
