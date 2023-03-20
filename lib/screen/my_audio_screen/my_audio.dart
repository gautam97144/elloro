import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_icon.dart';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/model/MusicDataModel.dart';
import 'package:elloro/model/favrouite_audio_model.dart';
import 'package:elloro/model/get_user_data.dart';
import 'package:elloro/model/purchase_list_model.dart';
import 'package:elloro/model/token_model.dart';
import 'package:elloro/model/user_register_model.dart';
import 'package:elloro/provider/internet_connectivity.dart';
import 'package:elloro/provider/internet_connectivity_one%20time.dart';
import 'package:elloro/screen/bottom_navigation/bottom_navigation.dart';
import 'package:elloro/screen/database/database.dart';
import 'package:elloro/screen/music_player/music_player_screen.dart';
import 'package:elloro/screen/music_player_second/music_player_screen.dart';
import 'package:elloro/screen/splash_screen/splash_screen.dart';
import 'package:elloro/screen/update_Account/update_account.dart';
import 'package:elloro/services/auth_service.dart';
import 'package:elloro/widget/custom_black_textfield.dart';
import 'package:elloro/widget/custom_button.dart';
import 'package:elloro/widget/custom_dialog.dart';
import 'package:elloro/widget/custom_profile_picture.dart';
import 'package:elloro/widget/custom_small_black_button.dart';
import 'package:elloro/widget/custom_small_yellow_button.dart';
import 'package:elloro/widget/custom_snackbar.dart';
import 'package:elloro/widget/texteditingcontroller.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class MyAudio extends StatefulWidget {
  int? status;
  MyAudio({Key? key, this.status}) : super(key: key);

  @override
  _MyAudioState createState() => _MyAudioState();
}

class _MyAudioState extends State<MyAudio> {
  UserRegisterModel? user;
  GetUserData? getUserData;
  String? newString;
  String? downloadMessage;
  String? path;
  bool isIndicator = false;
  bool isInternet = false;
  PurchaseList? purchaseList;
  bool isPlayNowButton = false;
  bool isdownload = false;
  bool isCancelButton = false;
  double downloadRatio = 0.0;
  NumberFormat format = NumberFormat.simpleCurrency(locale: "mnt");
  File? _displayImage;
  bool downloading = false;
  double _percentage = 0;
  // int progress = 0;
  CancelToken cancelToken = CancelToken();

  String downloadIndicator = '0 %';
  var progress = 0.0;
  Music? music;
  List<TokenModel>? storeToken;
  int? index;

  FavouriteAudio? favouriteAudio;

  bool isLoader = false;

  // static downloadingcallback(id, status, progress) {
  //   print(progress);
  //
  //   SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");
  //
  //   sendPort?.send([id, status, progress]);
  // }

  ReceivePort _port = ReceivePort();

  gettoken() async {
    await Provider.of<InternetConnectivityCheck>(context, listen: false)
        .checkRealTimeConnectivity();
    await Provider.of<InternetConnectivityCheckOneTime>(context, listen: false)
        .checkOneTimeConnectivity();

    storeToken = await DatabaseHelper.instance.getTokenData();

    SharedPreferences preferences = await SharedPreferences.getInstance();

    user = UserRegisterModel.fromJson(
        jsonDecode(preferences.getString('user').toString()));

    if (mounted) {
      if (!Provider.of<InternetConnectivityCheckOneTime>(context, listen: false)
              .isOneTimeInternet &&
          !Provider.of<InternetConnectivityCheck>(context, listen: false)
              .isNoInternet) {
        getUserData = await ApiService()
            .getUserData(context: context, userRegisterModel: user!);
      }
    }

    if (mounted) {
      if (!Provider.of<InternetConnectivityCheckOneTime>(context, listen: false)
              .isOneTimeInternet &&
          !Provider.of<InternetConnectivityCheck>(context, listen: false)
              .isNoInternet) {
        purchaseList = await ApiService().purchaseCatalogList(
          context: context,
          userRegisterModel: user!,
        );
      }
    }

    if (mounted) {
      if (!Provider.of<InternetConnectivityCheck>(context, listen: false)
              .isNoInternet &&
          !Provider.of<InternetConnectivityCheckOneTime>(context, listen: false)
              .isOneTimeInternet) {
        if (storeToken != null) {
          if (storeToken!.isNotEmpty) {
            await DatabaseHelper.instance.updateData(TokenModel(
              id: 1,
              token: getUserData?.data?.totalToken.toString() ?? "0",
              profileImage: getUserData?.data?.image,
            ));
            setState(() {});
          } else {
            await DatabaseHelper.instance.addTokenData(TokenModel(
                token: getUserData?.data?.totalToken.toString() ?? "0",
                profileImage: getUserData?.data?.image));
          }
        }
      }
    }

    List<Music> musicData = await DatabaseHelper.instance.getMusicData();

    if (purchaseList != null) {
      for (int i = 0; i < purchaseList!.data!.length; i++) {
        for (int j = 0; j < purchaseList!.data![i].data!.length; j++) {
          for (int k = 0; k < musicData.length; k++) {
            if (purchaseList?.data?[i].data?[j].catalogueId ==
                musicData[k].catalogId) {
              if (mounted) {
                setState(() {
                  purchaseList?.data?[i].data?[j].isIndicator = 2;
                  purchaseList?.data?[i].data?[j].isFavrouiteIconVisible = true;
                });
              }
            }
          }
        }
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  // purchaseListData() async {
  //   setState(() {});
  // }

  // checkRealTime() {
  //     }
  //
  // checkOneTime() {
  //
  // }

  // gettoken() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //
  //   user = UserRegisterModel.fromJson(
  //       jsonDecode(preferences.getString('user') ?? ""));
  //   print(user!.apiToken.toString());
  //
  //   print(preferences.getString('user') ?? '');
  //   getUserData = await ApiService()
  //       .getUserData(context: context, userRegisterModel: user!);
  //
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // user = Provider.of<UserProvider>(context, listen: false).getUser!;

    gettoken();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.status == 1) {
          await Provider.of<InternetConnectivityCheckOneTime>(context,
                  listen: false)
              .checkOneTimeConnectivity();

          if (!Provider.of<InternetConnectivityCheckOneTime>(context,
                  listen: false)
              .isOneTimeInternet) {
            Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => SplashScreen()),
                (route) => false);
          } else {}
        } else {
          print("willpop inactive");
        }

        return true;
      },
      child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
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
                      Provider.of<InternetConnectivityCheck>(context,
                                      listen: true)
                                  .isNoInternet ||
                              Provider.of<InternetConnectivityCheckOneTime>(
                                      context,
                                      listen: true)
                                  .isOneTimeInternet
                          ? MyButton().tokenButton(
                              (storeToken != null && storeToken!.isNotEmpty)
                                  ? storeToken![0].token.toString()
                                  : "0")
                          : GestureDetector(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BottomNavigation(
                                              index: index = 1,
                                            )),
                                    (route) => false);
                              },
                              child: MyButton().tokenButton(
                                  getUserData?.data?.totalToken ?? "0"

                                  //user?.totalToken ?? "0"
                                  ),
                            ),
                      SizedBox(width: 3.w),
                      Provider.of<InternetConnectivityCheck>(context,
                                      listen: true)
                                  .isNoInternet ||
                              Provider.of<InternetConnectivityCheckOneTime>(
                                      context,
                                      listen: true)
                                  .isOneTimeInternet
                          ? CachedNetworkImage(
                              imageUrl:
                                  storeToken != null && storeToken!.isNotEmpty
                                      ? storeToken![0].profileImage.toString()
                                      : "",
                              imageBuilder: (ctx, imageProvider) {
                                return CircleAvatar(
                                  backgroundImage: imageProvider,
                                );
                              },
                              placeholder: (ctx, url) => const CircleAvatar(
                                backgroundImage:
                                    AssetImage(Images.profileImage),
                              ),
                              errorWidget: (ctx, url, error) =>
                                  const CircleAvatar(
                                backgroundImage:
                                    AssetImage(Images.profileImage),
                              ),
                            )

                          // CircleAvatar(
                          //         backgroundImage: CachedNetworkImageProvider(
                          //             storeToken != null && storeToken!.isNotEmpty
                          //                 ? storeToken![0].profileImage.toString()
                          //                 : "")
                          //
                          //         // AssetImage(Images.circleAvatar),
                          //         )
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UpdateProfile()));
                              },
                              child: CustomProfilePicture(
                                url: user?.image ?? "",
                              ))
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
                    SizedBox(
                      height: 2.h,
                    ),
                    Provider.of<InternetConnectivityCheck>(context,
                                    listen: true)
                                .isNoInternet ||
                            Provider.of<InternetConnectivityCheckOneTime>(
                                    context,
                                    listen: true)
                                .isOneTimeInternet
                        ? offlineData()
                        : Expanded(
                            child: RefreshIndicator(
                                color: AppColor.primarycolor,
                                backgroundColor: AppColor.black,
                                onRefresh: () async {
                                  List<Music> musicData = await DatabaseHelper
                                      .instance
                                      .getMusicData();
                                  purchaseList = await ApiService()
                                      .purchaseCatalogList(
                                          context: context,
                                          userRegisterModel: user!);
                                  for (int i = 0;
                                      i < purchaseList!.data!.length;
                                      i++) {
                                    for (int j = 0;
                                        j < purchaseList!.data![i].data!.length;
                                        j++) {
                                      for (int k = 0;
                                          k < musicData.length;
                                          k++) {
                                        if (purchaseList?.data?[i].data?[j]
                                                .catalogueId ==
                                            musicData[k].catalogId) {
                                          setState(() {
                                            purchaseList?.data?[i].data?[j]
                                                .isIndicator = 2;
                                            purchaseList?.data?[i].data?[j]
                                                .isFavrouiteIconVisible = true;
                                          });
                                        }
                                      }
                                    }
                                  }

                                  setState(() {});
                                },
                                child:
                                    purchaseList?.data?.length == 0 ||
                                            purchaseList?.data == []
                                        ? const Center(
                                            child: Text(
                                              "You Have No Purchased Audios",
                                              style: TextStyle(
                                                  color: AppColor.grey),
                                            ),
                                          )
                                        : purchaseList?.data == null ||
                                                purchaseList?.data == []
                                            ? Center(
                                                // heightFactor: 1.h,
                                                child: LoadingAnimationWidget
                                                    .staggeredDotsWave(
                                                        color: AppColor
                                                            .primarycolor,
                                                        size: 45),
                                              )
                                            : isLoader == false
                                                ? Visibility(
                                                    visible: true,
                                                    child:
                                                        purchaseList?.data
                                                                    ?.length ==
                                                                0
                                                            ? Center(
                                                                child: Text(
                                                                    "No any Data"),
                                                              )
                                                            : ListView.builder(
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount: purchaseList?.data !=
                                                                            null ||
                                                                        purchaseList?.data !=
                                                                            []
                                                                    ? purchaseList
                                                                        ?.data
                                                                        ?.length
                                                                    : 0,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "${purchaseList?.data?[index].category}",
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: CustomTextStyle.body1.copyWith(
                                                                              fontSize: 18.sp,
                                                                              fontWeight: FontWeight.w900),
                                                                        ),
                                                                        for (int i =
                                                                                0;
                                                                            i < purchaseList!.data![index].data!.length;
                                                                            i++)
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              CachedNetworkImage(
                                                                                imageUrl: "${purchaseList?.data?[index].data?[i].image}",
                                                                                imageBuilder: (context, imageProvider) => Container(width: 80, height: 82, decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), image: DecorationImage(fit: BoxFit.fill, image: imageProvider))),
                                                                                placeholder: (context, url) => Container(
                                                                                  padding: const EdgeInsets.all(10),
                                                                                  width: 80,
                                                                                  height: 82,
                                                                                  decoration: BoxDecoration(
                                                                                    color: AppColor.grey,
                                                                                    borderRadius: BorderRadius.circular(14),
                                                                                  ),
                                                                                  child: Center(
                                                                                    child: Image.asset(
                                                                                      Images.onlyLogo,
                                                                                      scale: 4,
                                                                                      color: AppColor.darkGrey,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                errorWidget: (context, url, error) => Container(
                                                                                  padding: const EdgeInsets.all(10),
                                                                                  width: 80,
                                                                                  height: 82,
                                                                                  decoration: BoxDecoration(
                                                                                    color: AppColor.lightGrey,
                                                                                    borderRadius: BorderRadius.circular(14),
                                                                                  ),
                                                                                  child: Center(
                                                                                    child: Image.asset(
                                                                                      Images.onlyLogo,
                                                                                      scale: 4,
                                                                                      color: AppColor.darkGrey,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),

                                                                              // Container(
                                                                              //   decoration:
                                                                              //   BoxDecoration(borderRadius: BorderRadius.circular(14),
                                                                              //       image: DecorationImage(fit: BoxFit.fill,
                                                                              //
                                                                              //           image: CachedNetworkImageProvider("${purchaseList?.data?[index].data?[i].image}"))),
                                                                              //   width: 80,
                                                                              //   height: 82,
                                                                              // ),

                                                                              SizedBox(
                                                                                width: 2.w,
                                                                              ),
                                                                              Expanded(
                                                                                child: SizedBox(
                                                                                  width: 50,
                                                                                  height: 95,
                                                                                  //width: double.infinity,
                                                                                  //color: Colors.red,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(top: 5),
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      children: [
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Expanded(
                                                                                              child: purchaseList!.data![index].data![i].title!.length >= 28
                                                                                                  ? Text(
                                                                                                      "${purchaseList?.data?[index].data?[i].title?.substring(0, 28)}",
                                                                                                      style: CustomTextStyle.body3.copyWith(fontSize: 12.sp),
                                                                                                      maxLines: 1,
                                                                                                      // overflow:
                                                                                                      //     TextOverflow.ellipsis,
                                                                                                    )
                                                                                                  : Text(
                                                                                                      "${purchaseList?.data?[index].data?[i].title}",
                                                                                                      style: CustomTextStyle.body3.copyWith(fontSize: 12.sp),
                                                                                                      maxLines: 1,
                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                    ),
                                                                                            ),
                                                                                            purchaseList?.data?[index].data?[i].isFavrouiteIconVisible == true
                                                                                                ? Visibility(
                                                                                                    visible: true,
                                                                                                    child: GestureDetector(
                                                                                                        onTap: () async {
                                                                                                          setState(() {
                                                                                                            if (purchaseList?.data?[index].data?[i].favourite == 0) {
                                                                                                              purchaseList?.data?[index].data?[i].favourite = 1;
                                                                                                            } else {
                                                                                                              purchaseList?.data?[index].data?[i].favourite = 0;
                                                                                                            }
                                                                                                          });

                                                                                                          FormData data = FormData.fromMap({
                                                                                                            "catalogue_id": purchaseList?.data?[index].data?[i].catalogueId
                                                                                                          });

                                                                                                          favouriteAudio = await ApiService().favouriteAudio(context: context, userRegisterModel: user!, data: data).whenComplete(() async {});
                                                                                                        },
                                                                                                        child: purchaseList?.data?[index].data?[i].favourite == 0
                                                                                                            ? Icon(
                                                                                                                Icons.favorite_border,
                                                                                                                color: AppColor.grey,
                                                                                                                size: 3.h,
                                                                                                              )
                                                                                                            : Icon(
                                                                                                                Icons.favorite,
                                                                                                                color: AppColor.orange,
                                                                                                                size: 3.h,
                                                                                                              )),
                                                                                                  )
                                                                                                : const SizedBox.shrink()
                                                                                          ],
                                                                                        ),
                                                                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                                          Expanded(
                                                                                            child: Text(
                                                                                              "${purchaseList?.data?[index].data?[i].creatorName}",
                                                                                              style: CustomTextStyle.body4.copyWith(fontSize: 11.sp),
                                                                                              maxLines: 1,
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                            ),
                                                                                          )
                                                                                        ]),
                                                                                        Padding(
                                                                                          padding: (const EdgeInsets.only(top: 5)),
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              Container(
                                                                                                child: Row(
                                                                                                  children: [
                                                                                                    SizedBox(
                                                                                                      width: 9.w,
                                                                                                      height: 3.2.h,
                                                                                                      child: TextButton(
                                                                                                          onPressed: () {
                                                                                                            ///Popup
                                                                                                            showDialog(
                                                                                                              builder: (context) {
                                                                                                                return PopUp(
                                                                                                                    content: SingleChildScrollView(
                                                                                                                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                                                                                                                    Row(
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
                                                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                        children: [
                                                                                                                          CachedNetworkImage(
                                                                                                                            imageUrl: "${purchaseList?.data?[index].data?[i].image}",
                                                                                                                            imageBuilder: (context, imageProvider) {
                                                                                                                              return Container(
                                                                                                                                height: 60,
                                                                                                                                width: 60,
                                                                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), image: DecorationImage(fit: BoxFit.cover, image: imageProvider)),
                                                                                                                              );
                                                                                                                            },
                                                                                                                            placeholder: (context, url) => Container(
                                                                                                                              height: 60,
                                                                                                                              width: 60,
                                                                                                                              decoration: BoxDecoration(color: AppColor.grey, image: const DecorationImage(image: AssetImage(Images.onlyLogo)), borderRadius: BorderRadius.circular(15)),
                                                                                                                            ),
                                                                                                                            errorWidget: (context, url, error) => Container(
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
                                                                                                                                purchaseList!.data![index].data![i].title!.length >= 28
                                                                                                                                    ? Text(
                                                                                                                                        "${purchaseList?.data?[index].data?[i].title?.substring(0, 28)}",
                                                                                                                                        maxLines: 2,
                                                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                                                        style: CustomTextStyle.body3.copyWith(color: AppColor.white),
                                                                                                                                      )
                                                                                                                                    : Text(
                                                                                                                                        "${purchaseList?.data?[index].data?[i].title}",
                                                                                                                                        maxLines: 2,
                                                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                                                        style: CustomTextStyle.body3.copyWith(color: AppColor.white),
                                                                                                                                      ),
                                                                                                                                Padding(
                                                                                                                                  padding: EdgeInsets.only(top: 6),
                                                                                                                                  child: Text(
                                                                                                                                    "${purchaseList?.data?[index].data?[i].creatorName}",
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
                                                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                      children: [
                                                                                                                        GestureDetector(onTap: () {}, child: ratingAndCountOne(index, i)),
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
                                                                                                                              "${purchaseList?.data?[index].data?[i].duration}",
                                                                                                                              style: CustomTextStyle.body1.copyWith(fontSize: 10.sp),
                                                                                                                            )
                                                                                                                          ],
                                                                                                                        ),
                                                                                                                        const Icon(
                                                                                                                          Icons.fiber_manual_record,
                                                                                                                          color: AppColor.white,
                                                                                                                          size: 7,
                                                                                                                        ),
                                                                                                                        GestureDetector(
                                                                                                                          onTap: () {},
                                                                                                                          child: Row(
                                                                                                                            children: [
                                                                                                                              SvgPicture.asset(AppIcon.sizeIcon),
                                                                                                                              SizedBox(
                                                                                                                                width: 1.w,
                                                                                                                              ),
                                                                                                                              Text(
                                                                                                                                "${purchaseList?.data?[index].data?[i].musicFileSize}",
                                                                                                                                style: CustomTextStyle.body1.copyWith(fontSize: 10.sp),
                                                                                                                              )
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        )
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                    SizedBox(height: 2.h),

                                                                                                                    purchaseList!.data![index].data![i].description!.length >= 512
                                                                                                                        ? Text(
                                                                                                                            "${purchaseList?.data?[index].data?[i].description?.substring(0, 512)}",
                                                                                                                            style: CustomTextStyle.body1,
                                                                                                                          )
                                                                                                                        : Text(
                                                                                                                            "${purchaseList?.data?[index].data?[i].description}",
                                                                                                                            style: CustomTextStyle.body1,
                                                                                                                          ),
                                                                                                                    SizedBox(
                                                                                                                      height: 2.h,
                                                                                                                    ),
                                                                                                                    Text(
                                                                                                                      "About ${purchaseList?.data?[index].data?[i].creatorName}",

                                                                                                                      // maxLines: 1,
                                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                                      style: CustomTextStyle.body3,
                                                                                                                    ),
                                                                                                                    SizedBox(
                                                                                                                      height: 1.h,
                                                                                                                    ),

                                                                                                                    purchaseList!.data![index].data![i].description!.length >= 512
                                                                                                                        ? Text(
                                                                                                                            "${purchaseList?.data?[index].data?[i].creatorAbout?.substring(0, 512)}",
                                                                                                                            style: CustomTextStyle.body1,
                                                                                                                            textAlign: TextAlign.start,
                                                                                                                          )
                                                                                                                        : Text(
                                                                                                                            "${purchaseList?.data?[index].data?[i].creatorAbout}",
                                                                                                                            style: CustomTextStyle.body1,
                                                                                                                            textAlign: TextAlign.start,
                                                                                                                          ),
                                                                                                                    //image(),
                                                                                                                    SizedBox(height: 3.h),
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
                                                                                                      width: 1.w,
                                                                                                    ),
                                                                                                    ratingAndCountOne(index, i),
                                                                                                    SizedBox(
                                                                                                      width: 1.w,
                                                                                                    ),
                                                                                                    // volumeSymbol()
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              visibility(index, i, purchaseList?.data?[index].data?[i].catalogueId)
                                                                                            ],
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        SizedBox(
                                                                          height:
                                                                              1.h,
                                                                        ),
                                                                      ]);
                                                                },
                                                              ),
                                                  )
                                                : Visibility(
                                                    child: Center(
                                                    child: LoadingAnimationWidget
                                                        .staggeredDotsWave(
                                                            color: AppColor
                                                                .primarycolor,
                                                            size: 45),
                                                  ))),
                          )

                    // downloadList(),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget visibility(int index, int i, id) {
    if (purchaseList?.data?[index].data?[i].isIndicator == 1) {
      return Visibility(
        visible: true,
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SvgPicture.asset(
              Images.downloadIcon,
              color: AppColor.grey,
            ),
            Text(
              downloadIndicator.toString(),
              style: const TextStyle(color: AppColor.primarycolor),
            ),
          ]),
          SizedBox(
            width: 40.w,
            child: LinearProgressIndicator(
                backgroundColor: AppColor.grey,
                color: AppColor.primarycolor,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColor.primarycolor),
                minHeight: .5.h,
                value: downloadRatio
                //  color: AppColor.primarycolor,
                //backgroundColor: AppColor.grey,
                ),
          ),
        ]),
      );
    }
    if (purchaseList?.data?[index].data?[i].isIndicator == 2 ||
        isPlayNowButton == true) {
      return Visibility(visible: true, child: playButton(index, i, id));
    }
    return SizedBox(
      height: 4.5.h,
      width: 28.w,
      child: TextButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(const StadiumBorder()),
            side: MaterialStateProperty.all(const BorderSide(
                color: AppColor.primarycolor,
                width: 2,
                style: BorderStyle.solid))),
        onPressed: () {
          downloadAudioPopUp(
              context,
              purchaseList!.data![index].data![i].musicFile.toString(),
              purchaseList!.data![index].data![i].title.toString(),
              index,
              i);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(AppIcon.downloadNow),
            Text(
              StringConstant.downloadNow,
              style: CustomTextStyle.body6
                  .copyWith(fontSize: 10.sp)
                  .copyWith(color: AppColor.primarycolor),
            ),
          ],
        ),
      ),
    );
    //Spacer(),
    // Icon(
    //   Icons.cancel_outlined,
    //   color: AppColor.primarycolor,
    //   size: 3.5.h,
    // ),
  }

  Widget playButton(
    int index,
    int i,
    id,
  ) {
    return GestureDetector(
      onTap: () async {
        // FormData data = FormData.fromMap(
        //     {"catalogue_id": purchaseList?.data?[index].data?[i].catalogueId});
        // await ApiService().catalogDetails(
        //     context: context, userRegisterModel: user!, data: data);

        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => MusicPlayerScreen(
                    catalogeListData: purchaseList?.data?[index].data,
                    index: i))).then((value) async {
          purchaseList = await ApiService()
              .purchaseCatalogList(context: context, userRegisterModel: user!);

          List<Music> musicData = await DatabaseHelper.instance.getMusicData();

          if (purchaseList != null) {
            for (int i = 0; i < purchaseList!.data!.length; i++) {
              for (int j = 0; j < purchaseList!.data![i].data!.length; j++) {
                for (int k = 0; k < musicData.length; k++) {
                  if (purchaseList?.data?[i].data?[j].catalogueId ==
                      musicData[k].catalogId) {
                    if (mounted) {
                      setState(() {
                        purchaseList?.data?[i].data?[j].isIndicator = 2;
                        purchaseList?.data?[i].data?[j].isFavrouiteIconVisible =
                            true;
                      });
                    }
                  }
                }
              }
            }
          }

          setState(() {});
        });

        //     .then((value) async {
        //   await ApiService()
        //       .purchaseCatalogList(context: context, userRegisterModel: user!);
        //   if(mounted)
        //   setState(() {});
        // });
      },
      child: SizedBox(
        width: 36.w,
        child: Row(children: [
          Container(
              alignment: Alignment.center,
              height: 4.5.h,
              width: 28.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    Icons.play_circle_filled,
                    color: AppColor.white,
                  ),
                  Text(
                    StringConstant.playNow,
                    style: CustomTextStyle.body1.copyWith(fontSize: 10.sp),
                  )
                ],
              ),
              decoration: const ShapeDecoration(
                shape: StadiumBorder(
                    side: BorderSide(width: 2, color: AppColor.white)),
              )),
          const Spacer(),
          cancleButtonOne(context, index, i, id)
        ]),
      ),
    );
  }

  Widget searchField() {
    return CustomBlackInPutField(
      suffixIcon: GestureDetector(
        onTap: () {
          MyTextController.searchController.clear();
        },
        child: const Icon(
          Icons.cancel_outlined,
          color: AppColor.grey,
          size: 25,
        ),
      ),
      onFieldSubmitted: (value) async {
        await Provider.of<InternetConnectivityCheckOneTime>(context,
                listen: false)
            .checkOneTimeConnectivity();

        await Provider.of<InternetConnectivityCheck>(context, listen: false)
            .checkRealTimeConnectivity();

        if (!Provider.of<InternetConnectivityCheckOneTime>(context,
                    listen: false)
                .isOneTimeInternet ||
            !Provider.of<InternetConnectivityCheck>(context, listen: false)
                .isNoInternet) {
          FormData formData = FormData.fromMap({"search": value});

          setState(() {
            isLoader = true;
          });

          purchaseList = await ApiService().purchaseCatalogList(
              context: context,
              userRegisterModel: user!,
              data: formData,
              controller: value);
          setState(() {
            purchaseList;
          });

          setState(() {
            isLoader = false;
          });
        } else {
          GlobalSnackBar.show(context, "No Internet Connection");
        }
      },
      onChanged: (value) async {
        await Provider.of<InternetConnectivityCheckOneTime>(context,
                listen: false)
            .checkOneTimeConnectivity();

        await Provider.of<InternetConnectivityCheck>(context, listen: false)
            .checkRealTimeConnectivity();

        if (!Provider.of<InternetConnectivityCheckOneTime>(context,
                    listen: false)
                .isOneTimeInternet ||
            !Provider.of<InternetConnectivityCheck>(context, listen: false)
                .isNoInternet) {
          if (value == "") {
            FocusScope.of(context).unfocus();
            purchaseList = await ApiService().purchaseCatalogList(
                context: context, userRegisterModel: user!);
          }
          setState(() {
            purchaseList;
          });
        }
      },
      fieldController: MyTextController.searchController,
      hint: StringConstant.search,
      hintStyle: CustomTextStyle.body1.copyWith(fontWeight: FontWeight.w800),
    );
  }

  Widget categoryBanner() {
    return Text(
      StringConstant.meditation,
      style: CustomTextStyle.body1
          .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w900),
    );
  }

  Widget categoryBannerTwo() {
    return Text(StringConstant.positivity,
        style: CustomTextStyle.body1
            .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w900));
  }

  Widget cancleButtonOne(BuildContext context, index, i, id) {
    return GestureDetector(
      onTap: () {
        removeAudioPopUp(context, index, i, id);
      },
      child: Icon(
        Icons.cancel_outlined,
        color: AppColor.grey,
        size: 3.5.h,
      ),
    );
  }

  Future removeAudioPopUp(BuildContext context, int index, int i, int id) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopUp(
            content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(
            Icons.cancel,
            color: AppColor.orange,
            size: 50,
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            StringConstant.removeAudio,
            style: CustomTextStyle.body3,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 3.h,
          ),
          popButton(index, i, id)
        ]));
      },
    );
  }

  Widget popButton(int index, int i, int id) {
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
            setState(() {
              DatabaseHelper.instance.removeData(id);
              purchaseList?.data?[index].data?[i].isIndicator = 3;
              purchaseList?.data?[index].data?[i].isFavrouiteIconVisible =
                  false;

              // if (purchaseList?.data?[index].data?[i].favourite == 0) {
              //   purchaseList?.data?[index].data?[i].favourite = 1;
              // } else {
              //   purchaseList?.data?[index].data?[i].favourite = 0;
              // }
            });

            FormData data = FormData.fromMap({
              "catalogue_id": purchaseList?.data?[index].data?[i].catalogueId
            });
            if (purchaseList?.data?[index].data?[i].favourite == 1) {
              await ApiService().favouriteAudio(
                  context: context, userRegisterModel: user!, data: data);

              setState(() {
                purchaseList?.data?[index].data?[i].favourite = 0;
              });
            }
            // FormData deleteData = FormData.fromMap({
            //   "catalogue_id": purchaseList?.data?[index].data?[i].catalogueId
            // });
            //
            // await ApiService().purchaseDeleteAudio(
            //     context: context, data: deleteData, userRegisterModel: user!);
            Get.back();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: AppColor.black,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: Text(
                  "Audio deleted!",
                  style: CustomTextStyle.body1
                      .copyWith(color: AppColor.primarycolor),
                )));
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

  Future downloadAudioPopUp(BuildContext context, url, filename, index, i) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return PopUp(
            content: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            height: 3.h,
          ),
          Text(
            StringConstant.downloadAudio,
            style: CustomTextStyle.body3,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 3.h,
          ),
          button(url, filename, index, i)
        ]));
      },
    );
  }

  Widget button(url, filename, index, i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        CoustomSmallBlackButton(
          onPressed: () {
            Get.back();
            setState(() {
              purchaseList?.data?[index].data?[i].isIndicator = 3;
            });
          },
          title: StringConstant.cancel,
          style: CustomTextStyle.body1
              .copyWith(fontFamily: CustomTextStyle.fontFamilyMontserrat),
        ),
        CoustomSmallButton(
          onPressed: () {
            setState(() {
              purchaseList?.data?[index].data?[i].isIndicator = 1;
            });
            permission(url, filename, index, i);
            Get.back();
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

  Widget ratingAndCount() {
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
            "0",
            //purchaseList?.data?[index].data?[i].avgRate??"0"

            style: CustomTextStyle.body4.copyWith(fontSize: 11.sp),
          ),
        ),
      ],
    );
  }

  Widget ratingAndCountOne(int index, int i) {
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
            purchaseList?.data?[index].data?[i].avgRate ?? "0",
            style: CustomTextStyle.body4.copyWith(fontSize: 11.sp),
          ),
        ),
      ],
    );
  }

  Future<void> permission(url, filename, index, i) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      await downloadData(url, filename, index, i);
    } else {
      setState(() {
        purchaseList?.data?[index].data?[i].isIndicator = 3;
      });
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

              if (downloadRatio == 1) {
                downloading = false;

                print(pathone);
                setState(() {
                  purchaseList?.data?[index].data?[i].isIndicator = 2;
                });
                DatabaseHelper.instance.addMusicData(Music(
                  musicTitle: purchaseList?.data?[index].data?[i].title,
                  musicSubtitle: purchaseList?.data?[index].data?[i].subTitle,
                  musicDuration: purchaseList?.data?[index].data?[i].duration,
                  image: purchaseList?.data?[index].data?[i].image,
                  path: pathone,
                  catalogId: purchaseList?.data?[index].data?[i].catalogueId,
                  musicFileSize:
                      purchaseList?.data?[index].data?[i].musicFileSize,
                  creatorAbout:
                      purchaseList?.data?[index].data?[i].creatorAbout,
                  description: purchaseList?.data?[index].data?[i].description,
                  creatorName: purchaseList?.data?[index].data?[i].creatorName,
                  userId: purchaseList?.data?[index].data?[i].userId,
                ));
              }

              downloadIndicator =
                  (downloadRatio * 100).toStringAsFixed(0) + "% Completed";
            });
          }
        }
      }).whenComplete(() async {
        if (mounted) {
          setState(() {
            purchaseList?.data?[index].data?[i].isFavrouiteIconVisible = true;
          });
        }

        downloadIndicator = 0.toString() + "% Completed";
        FormData data = FormData.fromMap(
            {"catalogue_id": purchaseList?.data?[index].data?[i].catalogueId});

        if (mounted) {
          await ApiService().addCatalogueDownload(
              context: context, userRegisterModel: user!, data: data);
        }
      });

      print(response.statusCode);
    } on DioError catch (e) {
      print(e);
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
        purchaseList?.data?[index].data?[i].isIndicator = 3;
      });
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

  Widget offlineData() {
    return Expanded(
      child: FutureBuilder(
          future: DatabaseHelper.instance.getMusicData(),
          builder: (BuildContext context, AsyncSnapshot<List<Music>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text('loading'),
              );
            }
            return snapshot.data!.isEmpty
                ? Center(
                    child: Text(
                      "No Any Downloaded Audio",
                      style:
                          CustomTextStyle.body1.copyWith(color: AppColor.grey),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      List<Music>? musicData = snapshot.data;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: snapshot.data![index].image.toString(),
                            imageBuilder: (context, imageProvider) => Container(
                                width: 80,
                                height: 82,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: imageProvider))),
                            placeholder: (context, url) => Container(
                              child: Image.asset(
                                Images.onlyLogo,
                                color: AppColor.darkGrey,
                              ),
                              padding: const EdgeInsets.all(10),
                              width: 80,
                              height: 82,
                              decoration: BoxDecoration(
                                color: AppColor.grey,
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(Images.onlyLogo,
                                    color: AppColor.darkGrey),
                                width: 80,
                                height: 82,
                                decoration: BoxDecoration(
                                  color: AppColor.grey,
                                  borderRadius: BorderRadius.circular(14),
                                )),
                          ),

//                           Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(14),
//                                 image: DecorationImage(
//                                     fit: BoxFit.fill,
//                                     image: CachedNetworkImageProvider(
//                                         snapshot.data![index].image.toString()
//                                         // music?.image ?? ""
//
//                                         ))),
//                             width: 80,
//                             height: 82,
//
// // child:
// //   //  scale: 7.5,
// // ),
// //color: Colors.red,
//                           ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Expanded(
                            child: SizedBox(
                              width: 50,
                              height: 95,
//width: double.infinity,
//color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: snapshot.data![index]
                                                        .musicTitle!.length >=
                                                    28
                                                ? Text(
                                                    "${snapshot.data?[index].musicTitle?.substring(0, 28)}",
                                                    style: CustomTextStyle.body3
                                                        .copyWith(
                                                            fontSize: 12.sp),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                : Text(
                                                    snapshot.data?[index]
                                                            .musicTitle ??
                                                        "",
                                                    style: CustomTextStyle.body3
                                                        .copyWith(
                                                            fontSize: 12.sp),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ))
                                      ],
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              snapshot.data?[index]
                                                      .creatorName ??
                                                  "",
                                              style: CustomTextStyle.body4
                                                  .copyWith(fontSize: 11.sp),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ]),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 9.w,
                                              height: 3.2.h,
                                              child: TextButton(
                                                  onPressed: () {
// popup
                                                    showDialog(
                                                      builder: (context) {
                                                        return PopUp(
                                                            content:
                                                                SingleChildScrollView(
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Get.back();
                                                                      },
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .clear,
                                                                        color: AppColor
                                                                            .grey,
// size: 3.5.h,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    CachedNetworkImage(
                                                                      imageUrl:
                                                                          snapshot.data?[index].image ??
                                                                              "",
                                                                      imageBuilder:
                                                                          (context,
                                                                              imageProvider) {
                                                                        return Container(
                                                                          height:
                                                                              60,
                                                                          width:
                                                                              60,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                              image: DecorationImage(fit: BoxFit.cover, image: imageProvider)),
                                                                        );
                                                                      },
                                                                      placeholder:
                                                                          (context, url) =>
                                                                              Container(
                                                                        child: Image
                                                                            .asset(
                                                                          Images
                                                                              .onlyLogo,
                                                                          color:
                                                                              AppColor.darkGrey,
                                                                        ),
                                                                        height:
                                                                            60,
                                                                        width:
                                                                            60,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                AppColor.grey,
                                                                            borderRadius: BorderRadius.circular(15)),
                                                                      ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Container(
                                                                        height:
                                                                            60,
                                                                        width:
                                                                            60,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                AppColor.grey,
                                                                            image: const DecorationImage(image: AssetImage(Images.onlyLogo)),
                                                                            borderRadius: BorderRadius.circular(15)),
                                                                      ),
                                                                    ),

                                                                    // Container(
                                                                    //   height:
                                                                    //       60,
                                                                    //   width:
                                                                    //       60,
                                                                    //   decoration: BoxDecoration(
                                                                    //       borderRadius: BorderRadius.circular(15),
                                                                    //       image: DecorationImage(fit: BoxFit.cover, image: CachedNetworkImageProvider(snapshot.data?[index].image ?? "", scale: 10))),
                                                                    // ),
// Image.asset(
//   Images.bannerone,
//   scale: 10,
// ),
                                                                    SizedBox(
                                                                      width:
                                                                          2.w,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          snapshot.data![index].musicTitle!.length >= 28
                                                                              ? Text(
                                                                                  "${snapshot.data?[index].musicTitle?.substring(0, 28)}",
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: CustomTextStyle.body3.copyWith(color: AppColor.white),
                                                                                )
                                                                              : Text(
                                                                                  snapshot.data?[index].musicTitle ?? "",
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: CustomTextStyle.body3.copyWith(color: AppColor.white),
                                                                                ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 6),
                                                                            child:
                                                                                Text(
                                                                              snapshot.data?[index].creatorName ?? "",
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

                                                                SizedBox(
                                                                  height: 2.h,
                                                                ),

                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    ratingAndCount(),
                                                                    const Icon(
                                                                      Icons
                                                                          .fiber_manual_record,
                                                                      color: AppColor
                                                                          .white,
                                                                      size: 7,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        SvgPicture.asset(
                                                                            AppIcon.clockIcon),
                                                                        SizedBox(
                                                                          width:
                                                                              1.w,
                                                                        ),
                                                                        Text(
                                                                          snapshot.data?[index].musicDuration ??
                                                                              "",
                                                                          style: CustomTextStyle
                                                                              .body1
                                                                              .copyWith(fontSize: 10.sp),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    const Icon(
                                                                      Icons
                                                                          .fiber_manual_record,
                                                                      color: AppColor
                                                                          .white,
                                                                      size: 7,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {},
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          SvgPicture.asset(
                                                                              AppIcon.sizeIcon),
                                                                          SizedBox(
                                                                            width:
                                                                                1.w,
                                                                          ),
                                                                          Text(
                                                                            snapshot.data?[index].musicFileSize ??
                                                                                "",
//"${music.}",,,
                                                                            style:
                                                                                CustomTextStyle.body1.copyWith(fontSize: 10.sp),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        2.h),

                                                                snapshot.data![index].description!
                                                                            .length >=
                                                                        512
                                                                    ? Text(
                                                                        "${snapshot.data?[index].description?.substring(0, 512)}",
                                                                        style: CustomTextStyle
                                                                            .body1,
                                                                      )
                                                                    : Text(
                                                                        snapshot.data?[index].description ??
                                                                            "",
                                                                        style: CustomTextStyle
                                                                            .body1,
                                                                      ),
                                                                SizedBox(
                                                                  height: 2.h,
                                                                ),
                                                                Text(
                                                                  "About ${snapshot.data?[index].creatorName}",

// maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      CustomTextStyle
                                                                          .body3,
                                                                ),
                                                                SizedBox(
                                                                  height: 1.h,
                                                                ),
                                                                snapshot.data![index].creatorAbout!
                                                                            .length >=
                                                                        512
                                                                    ? Text(
                                                                        "${musicData?[index].creatorAbout?.substring(0, 512)}",
                                                                        style: CustomTextStyle
                                                                            .body1,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                      )
                                                                    : Text(
                                                                        musicData?[index].creatorAbout ??
                                                                            "",
                                                                        style: CustomTextStyle
                                                                            .body1,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                      ),
//image(),
                                                                SizedBox(
                                                                    height:
                                                                        3.h),
                                                              ]),
                                                        ));
                                                      },
                                                      context: context,
                                                    );
                                                  },
                                                  style: ButtonStyle(
                                                      padding: MaterialStateProperty.all(
                                                          EdgeInsets.all(.2.h)),
                                                      backgroundColor:
                                                          MaterialStateProperty.all(
                                                              Colors.black),
                                                      foregroundColor:
                                                          MaterialStateProperty.all(
                                                              AppColor.grey),
                                                      shape: MaterialStateProperty.all(
                                                          RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(
                                                                  20))),
                                                      side: MaterialStateProperty.all(
                                                          BorderSide(color: AppColor.grey, width: 2, style: BorderStyle.solid))),
                                                  child: const Icon(
                                                    Icons.more_horiz,
                                                    color: AppColor.grey,
                                                  )),
                                            ),
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                            ratingAndCount(),
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                          ],
                                        ),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: playButtonOne(
                                                context,
                                                musicData!,
                                                index,
                                                musicData[index].id!.toInt(),
                                                storeToken != null
                                                    ? storeToken!
                                                    : []))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    });
          }),
    );
  }

  Widget playButtonOne(context, List<Music> music, int index, int id,
      List<TokenModel> tokenModel) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => MusicPlayerScreenTwo(
                    musicdata: music,
                    musicIndex: index,
                    tokenData: tokenModel)));
      },
      child: Container(
          alignment: Alignment.center,
          height: 4.5.h,
          width: 28.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.play_circle_filled,
                color: AppColor.white,
              ),
              Text(
                StringConstant.playNow,
                style: CustomTextStyle.body1.copyWith(fontSize: 10.sp),
              )
            ],
          ),
          decoration: const ShapeDecoration(
            shape: StadiumBorder(
                side: BorderSide(width: 2, color: AppColor.white)),
          )),
    );
  }
}
