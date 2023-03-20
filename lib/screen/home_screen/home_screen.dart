import 'package:audioplayers/audioplayers.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_icon.dart';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/model/MusicDataModel.dart';
import 'package:elloro/model/favrouiteList_model.dart';
import 'package:elloro/model/favrouite_audio_model.dart';
import 'package:elloro/model/get_user_data.dart';
import 'package:elloro/model/recent_audio_model.dart';
import 'package:elloro/model/recommendation_list_model.dart';
import 'package:elloro/model/token_model.dart';
import 'package:elloro/model/user_register_model.dart';
import 'package:elloro/provider/internet_connectivity.dart';
import 'package:elloro/provider/internet_connectivity_one%20time.dart';
import 'package:elloro/provider/provider.dart';
import 'package:elloro/screen/bottom_navigation/bottom_navigation.dart';
import 'package:elloro/screen/database/database.dart';
import 'package:elloro/screen/loader/loader.dart';
import 'package:elloro/screen/music_player/music_player_fourth.dart';
import 'package:elloro/screen/music_player_second/music_player_screen.dart';
import 'package:elloro/screen/music_player_third/music_player_third.dart';
import 'package:elloro/screen/update_Account/update_account.dart';
import 'package:elloro/services/auth_service.dart';
import 'package:elloro/widget/custom_button.dart';
import 'package:elloro/widget/custom_dialog.dart';
import 'package:elloro/widget/custom_playnow_button.dart';
import 'package:elloro/widget/custom_profile_picture.dart';
import 'package:elloro/widget/custom_small_black_button.dart';
import 'package:elloro/widget/custom_small_yellow_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';
import 'package:numeral/numeral.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:dio/dio.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserRegisterModel? user;
  List<TokenModel>? storeToken;
  bool isLoading = false;
  RecommendationList? recommendationList;
  GetUserData? getUserData;
  int? index;
  FavrouiteList? favrouiteList;
  FavouriteAudio? favouriteAudio;
  RecentAudio? recentAudioList;
  double downloadRatio = 0.0;
  String downloadIndicator = '0 %';
  bool downloading = false;
  String? path;
  bool isPopUplose = false;
  bool isDownloadPopUpOpen = false;
  bool isPopOpen = false;
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int? recomIndex;

  NumberFormat format = NumberFormat.simpleCurrency(locale: "mnt");

  getToken() async {
    storeToken = await DatabaseHelper.instance.getTokenData();

    user = Provider.of<UserProvider>(context, listen: false).getUser!;

    await Provider.of<InternetConnectivityCheck>(context, listen: false)
        .checkRealTimeConnectivity();

    await Provider.of<InternetConnectivityCheckOneTime>(context, listen: false)
        .checkOneTimeConnectivity();

    if (!Provider.of<InternetConnectivityCheckOneTime>(context, listen: false)
            .isOneTimeInternet &&
        !Provider.of<InternetConnectivityCheck>(context, listen: false)
            .isNoInternet) {
      getUserData = await ApiService()
          .getUserData(context: context, userRegisterModel: user!);
    }
    if (mounted) {
      setState(() {});
    }

    if (mounted) {
      if (!Provider.of<InternetConnectivityCheckOneTime>(context, listen: false)
              .isOneTimeInternet &&
          !Provider.of<InternetConnectivityCheck>(context, listen: false)
              .isNoInternet) {
        favrouiteList = await ApiService()
            .favouriteAudioList(context: context, userRegisterModel: user!);
        if (mounted) {
          setState(() {});
        }
      }
    }

    if (mounted) {
      if (!Provider.of<InternetConnectivityCheckOneTime>(context, listen: false)
              .isOneTimeInternet ||
          !Provider.of<InternetConnectivityCheck>(context, listen: false)
              .isNoInternet) {
        recommendationList = await ApiService().fetchRecommendationList(
            context: context, userRegisterModel: user!);
        if (mounted) {
          setState(() {});
        }
      }
    }

    if (mounted) {
      if (!Provider.of<InternetConnectivityCheckOneTime>(context, listen: false)
              .isOneTimeInternet &&
          !Provider.of<InternetConnectivityCheck>(context, listen: false)
              .isNoInternet) {
        recentAudioList = await ApiService()
            .recentAudio(context: context, userRegisterModel: user!);
        if (mounted) {
          setState(() {});
        }
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

    if (recentAudioList != null) {
      for (int i = 0; i < recentAudioList!.data!.length; i++) {
        for (int k = 0; k < musicData.length; k++) {
          print(musicData[k].catalogId);
          if (recentAudioList?.data?[i].catalogueId == musicData[k].catalogId) {
            if (mounted) {
              setState(() {
                recentAudioList?.data?[i].isIndicator = 2;
                recentAudioList?.data?[i].isFavouriteIconVisible = true;
              });
            }
          }
        }
      }
    }

    // SharedPreferences preferences = await SharedPreferences.getInstance();
    //
    // user = UserRegisterModel.fromJson(
    //     jsonDecode(preferences.getString('user') ?? ""));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: AppColor.black));
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

                                // "${getUserData?.data?.totalToken ?? 0}"
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
                              backgroundImage: AssetImage(Images.profileImage),
                            ),
                            errorWidget: (ctx, url, error) =>
                                const CircleAvatar(
                              backgroundImage: AssetImage(Images.profileImage),
                            ),
                          )

                        // AssetImage(Images.circleAvatar),

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
                  child: Provider.of<InternetConnectivityCheck>(context,
                                  listen: true)
                              .isNoInternet ||
                          Provider.of<InternetConnectivityCheckOneTime>(context,
                                  listen: true)
                              .isOneTimeInternet
                      ? offlineData()
                      : recentAudioList?.data == null ||
                              favrouiteList?.data == null
                          ? const CustomLoader()
                          : SingleChildScrollView(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Text(
                                      StringConstant.recommendations,
                                      style: CustomTextStyle.body1.copyWith(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    SizedBox(
                                        height: 35.h, child: recommendation()),
                                    categoryBanner(),
                                    SizedBox(
                                      height: 2.h,
                                    ),

                                    favoriteListOfMusic(),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    favrouiteList!.data!.isEmpty &&
                                            recentAudioList!.data!.isEmpty
                                        ? Center(
                                            child: RichText(
                                            text: TextSpan(
                                                text: "No current ",
                                                style: CustomTextStyle.body1,
                                                children: [
                                                  TextSpan(
                                                    text: 'favourite'.tr,
                                                    style:
                                                        CustomTextStyle.body1,
                                                  ),
                                                  TextSpan(
                                                    text: " or Recent audios",
                                                    style:
                                                        CustomTextStyle.body1,
                                                  )
                                                ]),
                                          ))
                                        : const SizedBox.shrink(),
                                    recent(),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    listOfRecentAudio(),
                                    // shimar()

                                    // musicTileOne()
                                  ]),
                            )))),
      isPopOpen == true ? samplePopUp(recomIndex!) : const SizedBox.shrink(),
      isDownloadPopUpOpen == true ? container() : const SizedBox.shrink(),
      isLoading == true ? const CustomLoader() : const SizedBox.shrink()
    ]);
  }

  Widget shimar() {
    return Shimmer.fromColors(
        child: Container(
          color: Colors.white,
          width: 50,
          height: 50,
        ),
        direction: ShimmerDirection.ltr,
        baseColor: Colors.grey.withOpacity(.2),
        highlightColor: Colors.grey.withOpacity(.3));
  }

  Widget samplePopUp(int index) {
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
            imageUrl: "${recommendationList?.data?[index].image}",
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
                            "${recommendationList?.data?[index].title}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyle.body1
                            .copyWith(color: Colors.black, fontSize: 12)),
                    SizedBox(
                      height: .5.h,
                    ),
                    Expanded(
                      child: Text(
                        "${recommendationList?.data?[index].creatorName}",
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
                        audioPlayer.play(
                            recommendationList?.data?[index].musicFile ?? "");
                      }
                      setState(() {
                        isPlaying = !isPlaying;
                      });
                    },
                    child:
                        //cataLogList?.musicFile == null
                        //     ? CircularProgressIndicator()
                        //     :
                        isPlaying == false
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

  Widget container() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Align(
        alignment: Alignment.center,
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
                      Spacer(
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
                          style: const TextStyle(color: AppColor.primarycolor),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        LinearProgressIndicator(
                          value: downloadRatio,
                          backgroundColor: AppColor.grey,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColor.primarycolor),
                        ),
                      ]),
                ),
        ),
      ),
    );
  }

  Future audioPurchasePopUp(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopUp(
            content: Column(mainAxisSize: MainAxisSize.min, children: [
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
          popButton(
            index,
          )
        ]));
      },
    );
  }

  Widget popButton(int index) {
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
              "catalogue_id": recommendationList?.data?[index].catalogueId,
              "token_price": recommendationList?.data?[index].tokenPrice,
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
                  recommendationList?.data?[index].isPurchased = 1;
                });
              }

              downloadFromRecommendation(index);
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

  Future downloadFromRecommendation(int index) {
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
                  // setState(() {
                  //   catalogeList?.data?[index].categorydata?[i].isIndicator = 1;
                  // });

                  isDownloadPopUpOpen = true;

                  permissionForRecommendation(
                    recommendationList?.data?[index].musicFile ?? "",
                    recommendationList?.data?[index].title,
                    index,
                  );
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

  Widget recommendation() {
    return Container(
      height: 180,
      width: double.infinity,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: recommendationList?.data != null
            ? recommendationList?.data?.length
            : 0,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Row(children: [
            Container(
              //color: Colors.red,
              height: 30.h,
              width: 145,
              child: Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: recommendationList?.data?[index].image ?? "",
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 7),
                        width: 145,
                        height: 145,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                fit: BoxFit.cover, image: imageProvider)),
                        // child: Image.asset(
                        //   Images.bannerone,
                        //   fit: BoxFit.fitWidth,
                        // ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.white,
                                  child: InkWell(
                                    onTap: () {
                                      if (isPlaying == true) {
                                        setState(() {
                                          audioPlayer.pause();
                                        });
                                      }

                                      isPlaying = true;

                                      audioPlayer.play(recommendationList
                                              ?.data?[index].musicFile ??
                                          "");
                                      setState(() {
                                        recomIndex = index;
                                        isPopOpen = true;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.volume_up,
                                      size: 23,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    errorWidget: (ctx, url, error) {
                      return Container(
                          padding: const EdgeInsets.all(20),
                          width: 145,
                          height: 145,
                          decoration: BoxDecoration(
                              color: AppColor.grey,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                              child: Image.asset(
                            Images.onlyLogo,
                            scale: 4,
                            color: AppColor.darkGrey,
                          )));
                    },
                    placeholder: (ctx, url) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        width: 145,
                        height: 145,
                        decoration: BoxDecoration(
                            color: AppColor.grey,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                            child: Image.asset(
                          Images.onlyLogo,
                          scale: 4,
                          color: AppColor.darkGrey,
                        )),
                      );
                    },
                  ),
                  aboutMusic(index),
                ],
              ),
            ),
            SizedBox(
              width: 3.5.w,
            )
          ]);
        },
      ),
    );
  }

  Widget aboutMusic(int index) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 1.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  recommendationList?.data?[index].title ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyle.body4
                      .copyWith(color: AppColor.white, fontSize: 14.sp),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Expanded(
            child: Text(
              recommendationList?.data?[index].creatorName ?? "",
              style: CustomTextStyle.body4,
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
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
                            showDialog(
                              builder: (context) {
                                return PopUp(
                                    content: SingleChildScrollView(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          // mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
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
                                            //mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl:
                                                    "${recommendationList?.data?[index].image}",
                                                imageBuilder:
                                                    (context, imageProvider) {
                                                  return Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image:
                                                                imageProvider)),
                                                  );
                                                },
                                                placeholder: (context, url) =>
                                                    Container(
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                      color: AppColor.grey,
                                                      image:
                                                          const DecorationImage(
                                                              image: AssetImage(
                                                                  Images
                                                                      .onlyLogo)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                      color: AppColor.grey,
                                                      image:
                                                          const DecorationImage(
                                                              image: AssetImage(
                                                                  Images
                                                                      .onlyLogo)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    recommendationList!
                                                                .data![index]
                                                                .title!
                                                                .length >=
                                                            28
                                                        ? Text(
                                                            "${recommendationList?.data?[index].title?.substring(0, 28)}",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: CustomTextStyle
                                                                .body3
                                                                .copyWith(
                                                                    color: AppColor
                                                                        .white),
                                                          )
                                                        : Text(
                                                            "${recommendationList?.data?[index].title}",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: CustomTextStyle
                                                                .body3
                                                                .copyWith(
                                                                    color: AppColor
                                                                        .white),
                                                          ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6),
                                                      child: Text(
                                                        "${recommendationList?.data?[index].creatorName}",
                                                        style: CustomTextStyle
                                                            .body4,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  //  Navigator.push(context, MaterialPageRoute(builder: (context) => DataList()));
                                                },
                                                child:
                                                    ratingAndCountTwo(index)),
                                            const Icon(
                                              Icons.fiber_manual_record,
                                              color: AppColor.white,
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
                                                  width: 1.w,
                                                ),
                                                Text(
                                                  "${recommendationList?.data?[index].duration}",
                                                  style: CustomTextStyle.body1
                                                      .copyWith(
                                                          fontSize: 10.sp),
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
                                                SvgPicture.asset(
                                                    AppIcon.sizeIcon),
                                                SizedBox(
                                                  width: 1.w,
                                                ),
                                                Text(
                                                  "${recommendationList?.data?[index].musicFileSize}",
                                                  style: CustomTextStyle.body1
                                                      .copyWith(
                                                          fontSize: 10.sp),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 2.h),
                                        recommendationList!.data![index]
                                                    .description!.length >=
                                                512
                                            ? Text(
                                                "${recommendationList?.data?[index].description?.substring(0, 512)}",
                                                style: CustomTextStyle.body1,
                                              )
                                            : Text(
                                                "${recommendationList?.data?[index].description}",
                                                style: CustomTextStyle.body1,
                                              ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        Text(
                                          "About ${recommendationList?.data?[index].creatorName}",

                                          // maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: CustomTextStyle.body3,
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),

                                        recommendationList!.data![index]
                                                    .creatorAbout!.length >=
                                                512
                                            ? Text(
                                                "${recommendationList?.data?[index].creatorAbout?.substring(0, 512)}",
                                                style: CustomTextStyle.body1,
                                                textAlign: TextAlign.start,
                                              )
                                            : Text(
                                                "${recommendationList?.data?[index].creatorAbout}",
                                                style: CustomTextStyle.body1,
                                                textAlign: TextAlign.start,
                                              ),
                                        //image(),
                                        SizedBox(height: 3.h),

                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              recommendationList?.data?[index]
                                                              .isFree ==
                                                          1 &&
                                                      recommendationList
                                                              ?.data?[index]
                                                              .isPurchased ==
                                                          0
                                                  ? GestureDetector(
                                                      onTap: () async {
                                                        //  Navigator.pop(context);
                                                        FormData data =
                                                            FormData.fromMap({
                                                          "catalogue_id":
                                                              recommendationList
                                                                  ?.data?[index]
                                                                  .catalogueId,
                                                          "token_price": recommendationList
                                                                      ?.data?[
                                                                          index]
                                                                      .isFree ==
                                                                  1
                                                              ? "0"
                                                              : recommendationList
                                                                  ?.data?[index]
                                                                  .tokenPrice,
                                                        });

                                                        setState(() {
                                                          isLoading = true;
                                                        });

                                                        int? status =
                                                            await ApiService()
                                                                .purchase(
                                                          context: context,
                                                          data: data,
                                                          userRegisterModel:
                                                              user!,
                                                          //   message: isPurchasedTrue
                                                        )
                                                                .whenComplete(
                                                                    () {
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                        setState(() {
                                                          isLoading = false;
                                                        });

                                                        getUserData =
                                                            await ApiService()
                                                                .getUserData(
                                                                    context:
                                                                        context,
                                                                    userRegisterModel:
                                                                        user!);

                                                        if (status == 1) {
                                                          //Navigator.pop(context);

                                                          if (mounted) {
                                                            setState(() {
                                                              recommendationList
                                                                  ?.data?[index]
                                                                  .isPurchased = 1;
                                                            });
                                                          }

                                                          downloadFromRecommendation(
                                                              index);
                                                        }
                                                      },
                                                      child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: 3.6.h,
                                                          width: 14.w,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: AppColor
                                                                      .blue),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          32)),
                                                          child: Center(
                                                            child: Text("Free",
                                                                style: TextStyle(
                                                                    color:
                                                                        AppColor
                                                                            .blue,
                                                                    fontSize:
                                                                        10.sp)),
                                                          )),
                                                    )
                                                  : recommendationList
                                                              ?.data?[index]
                                                              .isPurchased ==
                                                          1
                                                      ? Visibility(
                                                          visible: true,
                                                          child: MyButton
                                                              .purchasedButton())
                                                      : Visibility(
                                                          visible: true,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              audioPurchasePopUp(
                                                                  context,
                                                                  index);

                                                              // if (isClosePopup == true) {
                                                              //   Navigator.pop(context);
                                                              // }
                                                            },
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 4.h,
                                                              width: 20.w,
                                                              decoration:
                                                                  const ShapeDecoration(
                                                                shape: StadiumBorder(
                                                                    side: BorderSide(
                                                                        width:
                                                                            2,
                                                                        color: AppColor
                                                                            .blue)),
                                                              ),
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                        format
                                                                            .currencySymbol,
                                                                        style: TextStyle(
                                                                            color:
                                                                                AppColor.blue,
                                                                            fontSize: 12.sp)),
                                                                    const SizedBox(
                                                                      width: 2,
                                                                    ),
                                                                    Text(
                                                                      Numeral(double.parse(recommendationList?.data?[index].tokenPrice?.replaceAll(",", "") ??
                                                                              "0"))
                                                                          .value(),
                                                                      style: CustomTextStyle
                                                                          .body6
                                                                          .copyWith(
                                                                              fontSize: 12.sp),
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
                            //  MyPopUp().specialOfferPopUp(context);
                          },
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.all(.2.h)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black),
                              foregroundColor:
                                  MaterialStateProperty.all(AppColor.grey),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              side: MaterialStateProperty.all(const BorderSide(
                                color: AppColor.grey,
                                width: 2,
                              ))),
                          child: const Icon(
                            Icons.more_horiz,
                            color: AppColor.grey,
                          )

                          // Text(
                          //   "...",
                          //   style: CustomTextStyle.body4
                          //       .copyWith(fontSize: 15, fontWeight: FontWeight.w900),
                          // ),
                          ),
                    ),
                    SizedBox(
                      width: 1.w,
                    ),
                    ratingAndCountTwo(index),
                  ],
                ),
              ),
              recommendationList?.data?[index].isFree == 1 &&
                      recommendationList?.data?[index].isPurchased == 0
                  ? GestureDetector(
                      onTap: () async {
                        // Navigator.pop(context);

                        FormData data = FormData.fromMap({
                          "catalogue_id":
                              recommendationList?.data?[index].catalogueId,
                          "token_price":
                              recommendationList?.data?[index].isFree == 1
                                  ? "0"
                                  : recommendationList?.data?[index].tokenPrice,
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

                        getUserData = await ApiService().getUserData(
                            context: context, userRegisterModel: user!);

                        if (status == 1) {
                          //Navigator.pop(context);

                          if (mounted) {
                            setState(() {
                              recommendationList?.data?[index].isPurchased = 1;
                            });
                          }

                          downloadFromRecommendation(index);
                        }
                      },
                      child: Container(
                          alignment: Alignment.center,
                          height: 3.6.h,
                          width: 14.w,
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColor.blue),
                              borderRadius: BorderRadius.circular(32)),
                          child: Center(
                            child: Text("Free",
                                style: TextStyle(
                                    color: AppColor.blue, fontSize: 10.sp)),
                          )),
                    )
                  : recommendationList?.data?[index].isPurchased == 1
                      ? purchasedButton()
                      : priceBanner(index),
            ],
          )
        ],
      ),
    );
  }

  Widget purchasedButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      height: 3.6.h,
      width: 14.w,
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.white),
          borderRadius: BorderRadius.circular(32)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(
            Icons.check_circle_outlined,
            size: 10,
            color: Colors.white,
          ),
          Text(
            StringConstant.purchased,
            style: CustomTextStyle.body6
                .copyWith(fontSize: 5.5.sp)
                .copyWith(color: AppColor.white),
          ),
        ],
      ),
    );
  }

  Widget ratingAndCount(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          Icons.star,
          size: 2.2.h,
          color: AppColor.primarycolor,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            favrouiteList?.data?[index].avgRate ?? "0",
            style: CustomTextStyle.body4.copyWith(fontSize: 11.sp),
          ),
        ),
      ],
    );
  }

  Widget ratingAndCountTwo(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          Icons.star,
          size: 2.2.h,
          color: AppColor.primarycolor,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            recommendationList?.data?[index].avgRate ?? "0",
            style: CustomTextStyle.body4.copyWith(fontSize: 11.sp),
          ),
        ),
      ],
    );
  }

  Widget ratingAndCountOne(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          Icons.star,
          size: 2.2.h,
          color: AppColor.primarycolor,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            recentAudioList?.data?[index].avgRate ?? "0",
            style: CustomTextStyle.body4.copyWith(fontSize: 11.sp),
          ),
        ),
      ],
    );
  }

  Widget moreBanner(int index, BuildContext context) {
    return SizedBox(
      width: 9.w,
      height: 3.2.h,
      child: TextButton(
          onPressed: () {
            showDialog(
              builder: (context) {
                return PopUp(
                    content: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          // mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.clear,
                                color: AppColor.grey,
                                // size: 3.5.h,
                              ),
                            )
                          ],
                        ),
                        Row(
                          //mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  "${recommendationList?.data?[index].image}",
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: imageProvider)),
                                );
                              },
                              placeholder: (context, url) => Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    color: AppColor.grey,
                                    image: const DecorationImage(
                                        image: AssetImage(Images.onlyLogo)),
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    color: AppColor.grey,
                                    image: const DecorationImage(
                                        image: AssetImage(Images.onlyLogo)),
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  recommendationList!
                                              .data![index].title!.length >=
                                          28
                                      ? Text(
                                          "${recommendationList?.data?[index].title?.substring(0, 28)}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: CustomTextStyle.body3
                                              .copyWith(color: AppColor.white),
                                        )
                                      : Text(
                                          "${recommendationList?.data?[index].title}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: CustomTextStyle.body3
                                              .copyWith(color: AppColor.white),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      "${recommendationList?.data?[index].creatorName}",
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
                          //mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                                  "${recommendationList?.data?[index].duration}",
                                  style: CustomTextStyle.body1
                                      .copyWith(fontSize: 10.sp),
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
                                  "${recommendationList?.data?[index].sampleMusicFile}",
                                  style: CustomTextStyle.body1
                                      .copyWith(fontSize: 10.sp),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "${recommendationList?.data?[index].description}",
                          style: CustomTextStyle.body1,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          "About ${recommendationList?.data?[index].creatorName}",
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyle.body3,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),

                        Text(
                          "${recommendationList?.data?[index].creatorAbout}",
                          style: CustomTextStyle.body1,
                          textAlign: TextAlign.start,
                        ),
                        //image(),
                        SizedBox(height: 3.h),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: true,
                                child: GestureDetector(
                                  onTap: () {
                                    //audioPurchasePopUp(context, index, i);

                                    // if (isClosePopup == true) {
                                    //   Navigator.pop(context);
                                    // }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 4.h,
                                    width: 20.w,
                                    decoration: const ShapeDecoration(
                                      shape: StadiumBorder(
                                          side: BorderSide(
                                              width: 2, color: AppColor.blue)),
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(format.currencySymbol,
                                              style: TextStyle(
                                                  color: AppColor.blue,
                                                  fontSize: 12.sp)),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            Numeral(double.parse(
                                                    "${recommendationList?.data?[index].tokenPrice?.replaceAll(",", "")}"))
                                                .value(),
                                            style: CustomTextStyle.body6
                                                .copyWith(fontSize: 12.sp),
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
            //  MyPopUp().specialOfferPopUp(context);
          },
          style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.all(.2.h)),
              backgroundColor: MaterialStateProperty.all(Colors.black),
              foregroundColor: MaterialStateProperty.all(AppColor.grey),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
              side: MaterialStateProperty.all(BorderSide(
                color: AppColor.grey,
                width: 2,
              ))),
          child: const Icon(
            Icons.more_horiz,
            color: AppColor.grey,
          )

          // Text(
          //   "...",
          //   style: CustomTextStyle.body4
          //       .copyWith(fontSize: 15, fontWeight: FontWeight.w900),
          // ),
          ),
    );
  }

  Widget categoryBanner() {
    return favrouiteList?.data?.length == 0 || favrouiteList?.data == []
        ? Visibility(
            visible: false,
            child: Text(
              'favourite'.tr,
              style: CustomTextStyle.body1
                  .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w900),
            ),
          )
        : Visibility(
            visible: true,
            child: Text(
              'favourite'.tr,
              style: CustomTextStyle.body1
                  .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w900),
            ));
  }

  Widget recent() {
    return recentAudioList?.data?.length == 0 || recentAudioList?.data == []
        ? Text(
            "",
            style: CustomTextStyle.body1
                .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w900),
          )
        : Text(
            StringConstant.recent,
            style: CustomTextStyle.body1
                .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w900),
          );
  }

  Widget listOfRecentAudio() {
    return recentAudioList?.data == null || recentAudioList?.data == []
        ? CircularProgressIndicator(
            color: AppColor.primarycolor,
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: recentAudioList?.data != null
                ? recentAudioList?.data?.length
                : 0,
            itemBuilder: (context, index) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: "${recentAudioList?.data?[index].image}",
                          imageBuilder: (context, imageProvider) => Container(
                              width: 80,
                              height: 82,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  image: DecorationImage(
                                      fit: BoxFit.fill, image: imageProvider))),
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
                              padding: EdgeInsets.only(top: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: recentAudioList!.data![index]
                                                    .title!.length >=
                                                28
                                            ? Text(
                                                "${recentAudioList?.data?[index].title?.substring(0, 28)}",
                                                style: CustomTextStyle.body3
                                                    .copyWith(fontSize: 12.sp),
                                                maxLines: 1,
                                                // overflow:
                                                //     TextOverflow.ellipsis,
                                              )
                                            : Text(
                                                "${recentAudioList?.data?[index].title}",
                                                style: CustomTextStyle.body3
                                                    .copyWith(fontSize: 12.sp),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                      ),
                                      // GestureDetector(

                                      //
                                      recentAudioList?.data?[index]
                                                  .isFavouriteIconVisible ==
                                              true
                                          ? Visibility(
                                              visible: true,
                                              child: GestureDetector(
                                                onTap: () async {
                                                  setState(() {
                                                    if (recentAudioList
                                                            ?.data?[index]
                                                            .favourite ==
                                                        0) {
                                                      recentAudioList
                                                          ?.data?[index]
                                                          .favourite = 1;
                                                    } else {
                                                      recentAudioList
                                                          ?.data?[index]
                                                          .favourite = 0;
                                                    }
                                                  });

                                                  FormData data =
                                                      FormData.fromMap({
                                                    "catalogue_id":
                                                        recentAudioList
                                                            ?.data?[index]
                                                            .catalogueId
                                                  });

                                                  await ApiService()
                                                      .favouriteAudio(
                                                          context: context,
                                                          userRegisterModel:
                                                              user!,
                                                          data: data)
                                                      .then((value) async {
                                                    favrouiteList =
                                                        await ApiService()
                                                            .favouriteAudioList(
                                                                context:
                                                                    context,
                                                                userRegisterModel:
                                                                    user!);
                                                    setState(() {});
                                                  });
                                                },
                                                child: recentAudioList
                                                            ?.data?[index]
                                                            .favourite ==
                                                        0
                                                    ? Icon(
                                                        Icons.favorite_border,
                                                        color: AppColor.grey,
                                                        size: 3.h,
                                                      )
                                                    : Icon(
                                                        Icons.favorite,
                                                        color: AppColor.orange,
                                                        size: 3.h,
                                                      ),
                                              ),
                                            )
                                          : SizedBox.shrink()
                                      // )
                                    ],
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${recentAudioList?.data?[index].creatorName}",
                                            style: CustomTextStyle.body4
                                                .copyWith(fontSize: 11.sp),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ]),
                                  Padding(
                                    padding: (EdgeInsets.only(top: 5)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .clear,
                                                                          color:
                                                                              AppColor.grey,
                                                                          // size: 3.5.h,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    //   color: Colors.red,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        CachedNetworkImage(
                                                                          imageUrl:
                                                                              "${recentAudioList?.data?[index].image}",
                                                                          imageBuilder:
                                                                              (context, imageProvider) {
                                                                            return Container(
                                                                              height: 60,
                                                                              width: 60,
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), image: DecorationImage(fit: BoxFit.cover, image: imageProvider)),
                                                                            );
                                                                          },
                                                                          placeholder: (context, url) =>
                                                                              Container(
                                                                            height:
                                                                                60,
                                                                            width:
                                                                                60,
                                                                            decoration: BoxDecoration(
                                                                                color: AppColor.grey,
                                                                                image: const DecorationImage(image: AssetImage(Images.onlyLogo)),
                                                                                borderRadius: BorderRadius.circular(15)),
                                                                          ),
                                                                          errorWidget: (context, url, error) =>
                                                                              Container(
                                                                            height:
                                                                                60,
                                                                            width:
                                                                                60,
                                                                            decoration: BoxDecoration(
                                                                                color: AppColor.grey,
                                                                                image: const DecorationImage(image: AssetImage(Images.onlyLogo)),
                                                                                borderRadius: BorderRadius.circular(15)),
                                                                          ),
                                                                        ),
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
                                                                              recentAudioList!.data![index].title!.length >= 28
                                                                                  ? Text(
                                                                                      "${recentAudioList?.data?[index].title?.substring(0, 28)}",
                                                                                      maxLines: 2,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: CustomTextStyle.body3.copyWith(color: AppColor.white),
                                                                                    )
                                                                                  : Text(
                                                                                      "${recentAudioList?.data?[index].title}",
                                                                                      maxLines: 2,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: CustomTextStyle.body3.copyWith(color: AppColor.white),
                                                                                    ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 6),
                                                                                child: Text(
                                                                                  "${recentAudioList?.data?[index].creatorName}",
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
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      ratingAndCountOne(
                                                                          index),
                                                                      const Icon(
                                                                        Icons
                                                                            .fiber_manual_record,
                                                                        color: AppColor
                                                                            .white,
                                                                        size: 7,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          SvgPicture.asset(
                                                                              AppIcon.clockIcon),
                                                                          SizedBox(
                                                                            width:
                                                                                1.w,
                                                                          ),
                                                                          Text(
                                                                            "${recentAudioList?.data?[index].duration}",
                                                                            style:
                                                                                CustomTextStyle.body1.copyWith(fontSize: 10.sp),
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
                                                                            SvgPicture.asset(AppIcon.sizeIcon),
                                                                            SizedBox(
                                                                              width: 1.w,
                                                                            ),
                                                                            Text(
                                                                              "${recentAudioList?.data?[index].musicFileSize}",
                                                                              style: CustomTextStyle.body1.copyWith(fontSize: 10.sp),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          2.h),
                                                                  recentAudioList!
                                                                              .data![index]
                                                                              .description!
                                                                              .length >=
                                                                          512
                                                                      ? Text(
                                                                          "${recentAudioList?.data?[index].description?.substring(0, 512)}",
                                                                          style:
                                                                              CustomTextStyle.body1,
                                                                        )
                                                                      : Text(
                                                                          "${recentAudioList?.data?[index].description}",
                                                                          style:
                                                                              CustomTextStyle.body1,
                                                                        ),
                                                                  SizedBox(
                                                                    height: 2.h,
                                                                  ),
                                                                  Text(
                                                                    "About ${recentAudioList?.data?[index].creatorName ?? ""}",

                                                                    // maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: CustomTextStyle
                                                                        .body3,
                                                                  ),
                                                                  SizedBox(
                                                                    height: 1.h,
                                                                  ),

                                                                  recentAudioList!
                                                                              .data![index]
                                                                              .creatorAbout!
                                                                              .length >=
                                                                          512
                                                                      ? Text(
                                                                          "${recentAudioList?.data?[index].creatorAbout?.substring(0, 512)}",
                                                                          style:
                                                                              CustomTextStyle.body1,
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                        )
                                                                      : Text(
                                                                          recentAudioList?.data?[index].creatorAbout ??
                                                                              "",
                                                                          style:
                                                                              CustomTextStyle.body1,
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
                                                        padding:
                                                            MaterialStateProperty.all(
                                                                EdgeInsets.all(
                                                                    .2.h)),
                                                        backgroundColor:
                                                            MaterialStateProperty.all(
                                                                Colors.black),
                                                        foregroundColor:
                                                            MaterialStateProperty.all(
                                                                AppColor.grey),
                                                        shape: MaterialStateProperty.all(
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(20))),
                                                        side: MaterialStateProperty.all(BorderSide(color: AppColor.grey, width: 2, style: BorderStyle.solid))),
                                                    child: Icon(
                                                      Icons.more_horiz,
                                                      color: AppColor.grey,
                                                    )),
                                              ),
                                              SizedBox(
                                                width: 1.w,
                                              ),
                                              ratingAndCountOne(index),
                                              SizedBox(
                                                width: 1.w,
                                              ),
                                            ],
                                          ),
                                        ),
                                        visibility(index)

                                        //playButtonOne(index)
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
                      height: 1.h,
                    ),
                  ]);
            },
          );
  }

  Widget favoriteListOfMusic() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: favrouiteList?.data != null ? favrouiteList?.data?.length : 0,
      itemBuilder: (context, index) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: "${favrouiteList?.data?[index].image}",
                imageBuilder: (context, imageProvider) => Container(
                    width: 80,
                    height: 82,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        image: DecorationImage(
                            fit: BoxFit.fill, image: imageProvider))),
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
                    padding: EdgeInsets.only(top: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child:
                                  favrouiteList!.data![index].title!.length >=
                                          28
                                      ? Text(
                                          "${favrouiteList?.data?[index].title?.substring(0, 28)}",
                                          style: CustomTextStyle.body3
                                              .copyWith(fontSize: 12.sp),
                                          maxLines: 1,
                                          // overflow:
                                          //     TextOverflow.ellipsis,
                                        )
                                      : Text(
                                          "${favrouiteList?.data?[index].title}",
                                          style: CustomTextStyle.body3
                                              .copyWith(fontSize: 12.sp),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                            ),
                            GestureDetector(
                                onTap: () async {
                                  if (mounted) {
                                    setState(() {
                                      if (favrouiteList
                                              ?.data?[index].favourite ==
                                          0) {
                                        favrouiteList?.data?[index].favourite =
                                            1;
                                      } else {
                                        favrouiteList?.data?[index].favourite =
                                            0;
                                      }
                                    });
                                  }

                                  FormData data = FormData.fromMap({
                                    "catalogue_id":
                                        favrouiteList?.data?[index].catalogueId
                                  });

                                  favouriteAudio = await ApiService()
                                      .favouriteAudio(
                                          context: context,
                                          userRegisterModel: user!,
                                          data: data)
                                      .then((value) async {
                                    recentAudioList = await ApiService()
                                        .recentAudio(
                                            context: context,
                                            userRegisterModel: user!);

                                    List<Music> musicData = await DatabaseHelper
                                        .instance
                                        .getMusicData();

                                    if (recentAudioList != null) {
                                      for (int i = 0;
                                          i < recentAudioList!.data!.length;
                                          i++) {
                                        for (int k = 0;
                                            k < musicData.length;
                                            k++) {
                                          print(musicData[k].catalogId);
                                          if (recentAudioList
                                                  ?.data?[i].catalogueId ==
                                              musicData[k].catalogId) {
                                            setState(() {
                                              recentAudioList
                                                  ?.data?[i].isIndicator = 2;
                                              recentAudioList?.data?[i]
                                                      .isFavouriteIconVisible =
                                                  true;
                                            });
                                          }
                                        }
                                      }
                                    }
                                  });
                                  setState(() {
                                    favrouiteList?.data?.removeAt(index);
                                  });
                                },
                                child:
                                    favrouiteList?.data?[index].favourite == 0
                                        ? Icon(
                                            Icons.favorite_border,
                                            color: AppColor.grey,
                                            size: 3.h,
                                          )
                                        : Icon(
                                            Icons.favorite,
                                            color: AppColor.orange,
                                            size: 3.h,
                                          ))
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "${favrouiteList?.data?[index].creatorName}",
                                  style: CustomTextStyle.body4
                                      .copyWith(fontSize: 11.sp),
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
                                                          MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Icon(
                                                                Icons.clear,
                                                                color: AppColor
                                                                    .grey,
                                                                // size: 3.5.h,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Container(
                                                          //   color: Colors.red,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              CachedNetworkImage(
                                                                imageUrl:
                                                                    "${favrouiteList?.data?[index].image}",
                                                                imageBuilder:
                                                                    (context,
                                                                        imageProvider) {
                                                                  return Container(
                                                                    height: 60,
                                                                    width: 60,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                15),
                                                                        image: DecorationImage(
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            image: imageProvider)),
                                                                  );
                                                                },
                                                                placeholder:
                                                                    (context,
                                                                            url) =>
                                                                        Container(
                                                                  height: 60,
                                                                  width: 60,
                                                                  decoration: BoxDecoration(
                                                                      color: AppColor
                                                                          .grey,
                                                                      image: const DecorationImage(
                                                                          image: AssetImage(Images
                                                                              .onlyLogo)),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15)),
                                                                ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Container(
                                                                  height: 60,
                                                                  width: 60,
                                                                  decoration: BoxDecoration(
                                                                      color: AppColor
                                                                          .grey,
                                                                      image: const DecorationImage(
                                                                          image: AssetImage(Images
                                                                              .onlyLogo)),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15)),
                                                                ),
                                                              ),

                                                              // Image.asset(
                                                              //   Images.bannerone,
                                                              //   scale: 10,
                                                              // ),
                                                              SizedBox(
                                                                width: 2.w,
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    favrouiteList!.data![index].title!.length >=
                                                                            28
                                                                        ? Text(
                                                                            "${favrouiteList?.data?[index].title?.substring(0, 28)}",
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                CustomTextStyle.body3.copyWith(color: AppColor.white),
                                                                          )
                                                                        : Text(
                                                                            "${favrouiteList?.data?[index].title}",
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                CustomTextStyle.body3.copyWith(color: AppColor.white),
                                                                          ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              6),
                                                                      child:
                                                                          Text(
                                                                        "${favrouiteList?.data?[index].creatorName}",
                                                                        style: CustomTextStyle
                                                                            .body4,
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
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
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            ratingAndCount(
                                                                index),
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
                                                                    AppIcon
                                                                        .clockIcon),
                                                                SizedBox(
                                                                  width: 1.w,
                                                                ),
                                                                Text(
                                                                  "${favrouiteList?.data?[index].duration}",
                                                                  style: CustomTextStyle
                                                                      .body1
                                                                      .copyWith(
                                                                          fontSize:
                                                                              10.sp),
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
                                                              onTap: () {},
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(
                                                                      AppIcon
                                                                          .sizeIcon),
                                                                  SizedBox(
                                                                    width: 1.w,
                                                                  ),
                                                                  Text(
                                                                    "${favrouiteList?.data?[index].musicFileSize}",
                                                                    style: CustomTextStyle
                                                                        .body1
                                                                        .copyWith(
                                                                            fontSize:
                                                                                10.sp),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(height: 2.h),

                                                        favrouiteList!
                                                                    .data![
                                                                        index]
                                                                    .description!
                                                                    .length >=
                                                                512
                                                            ? Text(
                                                                "${favrouiteList?.data?[index].description?.substring(0, 512)}",
                                                                style:
                                                                    CustomTextStyle
                                                                        .body1,
                                                              )
                                                            : Text(
                                                                "${favrouiteList?.data?[index].description}",
                                                                style:
                                                                    CustomTextStyle
                                                                        .body1,
                                                              ),
                                                        SizedBox(
                                                          height: 2.h,
                                                        ),
                                                        Text(
                                                          "About ${favrouiteList?.data?[index].creatorName ?? ""}",

                                                          // maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: CustomTextStyle
                                                              .body3,
                                                        ),
                                                        SizedBox(
                                                          height: 1.h,
                                                        ),

                                                        favrouiteList!
                                                                    .data![
                                                                        index]
                                                                    .creatorAbout!
                                                                    .length >=
                                                                512
                                                            ? Text(
                                                                "${favrouiteList?.data?[index].creatorAbout?.substring(0, 512)}",
                                                                style:
                                                                    CustomTextStyle
                                                                        .body1,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                              )
                                                            : Text(
                                                                favrouiteList
                                                                        ?.data?[
                                                                            index]
                                                                        .creatorAbout ??
                                                                    "",
                                                                style:
                                                                    CustomTextStyle
                                                                        .body1,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                              ),
                                                        //image(),
                                                        SizedBox(height: 3.h),
                                                      ]),
                                                ));
                                              },
                                              context: context,
                                            );
                                          },
                                          style: ButtonStyle(
                                              padding: MaterialStateProperty.all(
                                                  EdgeInsets.all(.2.h)),
                                              backgroundColor: MaterialStateProperty.all(
                                                  Colors.black),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      AppColor.grey),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20))),
                                              side: MaterialStateProperty.all(
                                                  const BorderSide(color: AppColor.grey, width: 2, style: BorderStyle.solid))),
                                          child: const Icon(
                                            Icons.more_horiz,
                                            color: AppColor.grey,
                                          )),
                                    ),
                                    SizedBox(
                                      width: 1.w,
                                    ),
                                    ratingAndCount(index),
                                    SizedBox(
                                      width: 1.w,
                                    ),
                                    // volumeSymbol()
                                  ],
                                ),
                              ),
                              playButton(index)
                              // visibility(index, i)
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
            height: 1.h,
          ),
        ]);
      },
    );
  }

  Widget playButtonOne(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MusicPlayerScreenFour(
                      catalogeListData: recentAudioList?.data,
                      index: index,
                    ))).then((value) async {
          favrouiteList = await ApiService()
              .favouriteAudioList(context: context, userRegisterModel: user!);

          recentAudioList = await ApiService()
              .recentAudio(context: context, userRegisterModel: user!);

          List<Music> musicData = await DatabaseHelper.instance.getMusicData();

          if (recentAudioList != null) {
            for (int i = 0; i < recentAudioList!.data!.length; i++) {
              for (int k = 0; k < musicData.length; k++) {
                print(musicData[k].catalogId);
                if (recentAudioList?.data?[i].catalogueId ==
                    musicData[k].catalogId) {
                  setState(() {
                    recentAudioList?.data?[i].isIndicator = 2;
                    recentAudioList?.data?[i].isFavouriteIconVisible = true;
                  });
                }
              }
            }
          }
        });
      },
      child: Container(
          alignment: Alignment.center,
          height: 4.5.h,
          width: 28.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
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

  Widget playButton(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MusicPlayerScreenThird(
                      catalogeListData: favrouiteList?.data,
                      index: index,
                    ))).then((value) async {
          favrouiteList = await ApiService()
              .favouriteAudioList(context: context, userRegisterModel: user!);

          recentAudioList = await ApiService()
              .recentAudio(context: context, userRegisterModel: user!);

          List<Music> musicData = await DatabaseHelper.instance.getMusicData();

          if (recentAudioList != null) {
            for (int i = 0; i < recentAudioList!.data!.length; i++) {
              for (int k = 0; k < musicData.length; k++) {
                print(musicData[k].catalogId);
                if (recentAudioList?.data?[i].catalogueId ==
                    musicData[k].catalogId) {
                  setState(() {
                    recentAudioList?.data?[i].isIndicator = 2;
                    recentAudioList?.data?[i].isFavouriteIconVisible = true;
                  });
                }
              }
            }
          }

          setState(() {});
        });
      },
      child: Row(children: [
        Container(
            alignment: Alignment.center,
            height: 4.5.h,
            width: 28.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
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
        // Spacer(),
        // cancleButton(),
      ]),
    );
  }

  Widget cancleButton() {
    return Icon(
      Icons.cancel_outlined,
      color: AppColor.grey,
      size: 3.5.h,
    );
  }

  Widget priceBanner(int index) {
    return InkWell(
      onTap: () {
        audioPurchasePopUp(context, index);
      },
      child: Container(
        alignment: Alignment.center,
        height: 3.6.h,
        width: 14.w,
        decoration: BoxDecoration(
            border: Border.all(color: AppColor.blue),
            borderRadius: BorderRadius.circular(32)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(format.currencySymbol,
                style: TextStyle(color: AppColor.blue, fontSize: 10.sp)),
          ),
          const SizedBox(
            width: 1,
          ),
          Text(
            Numeral(double.parse(recommendationList?.data?[index].tokenPrice
                        ?.replaceAll(",", "") ??
                    "0"))
                .value(),
            style: CustomTextStyle.body6,
          ),
        ]),
      ),
    );
  }

  Future downloadAudioPopUp(BuildContext context, url, filename, index) {
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
          button(url, filename, index)
        ]));
      },
    );
  }

  Widget button(
    url,
    filename,
    index,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        CoustomSmallBlackButton(
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              recentAudioList?.data?[index].isIndicator = 3;
            });
          },
          title: StringConstant.cancel,
          style: CustomTextStyle.body1
              .copyWith(fontFamily: CustomTextStyle.fontFamilyMontserrat),
        ),
        CoustomSmallButton(
          onPressed: () {
            setState(() {
              recentAudioList?.data?[index].isIndicator = 1;
            });
            permission(url, filename, index);
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

  Future<void> permission(url, filename, index) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      await downloadData(url, filename, index);
    } else {
      setState(() {
        recentAudioList?.data?[index].isIndicator = 3;
      });
    }
  }

  //=====permission for recommendation download==========

  Future<void> permissionForRecommendation(url, filename, index) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      await downloadDataForRecommendation(url, filename, index);
    } else {
      print("permission denied + recommendation");
    }
  }

  Future downloadDataForRecommendation(
      String url, String filename, int index) async {
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
                  musicTitle: recommendationList?.data?[index].title,
                  musicSubtitle: recommendationList?.data?[index].subTitle,
                  musicDuration: recommendationList?.data?[index].duration,
                  image: recommendationList?.data?[index].image,
                  path: pathone,
                  catalogId: recommendationList?.data?[index].catalogueId,
                  musicFileSize: recommendationList?.data?[index].musicFileSize,
                  creatorAbout: recommendationList?.data?[index].creatorAbout,
                  description: recommendationList?.data?[index].description,
                  creatorName: recommendationList?.data?[index].creatorName,
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
        FormData data = FormData.fromMap(
            {"catalogue_id": recommendationList?.data?[index].catalogueId});

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

  Future downloadData(
    String url,
    String filename,
    int index,
  ) async {
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

              //print(downloadRatio);

              if (downloadRatio == 1) {
                downloading = false;

                print(pathone);
                setState(() {
                  recentAudioList?.data?[index].isIndicator = 2;
                });
                DatabaseHelper.instance.addMusicData(Music(
                  musicTitle: recentAudioList?.data?[index].title,
                  musicSubtitle: recentAudioList?.data?[index].subTitle,
                  musicDuration: recentAudioList?.data?[index].duration,
                  image: recentAudioList?.data?[index].image,
                  path: pathone,
                  catalogId: recentAudioList?.data?[index].catalogueId,
                  musicFileSize: recentAudioList?.data?[index].musicFileSize,
                  creatorAbout: recentAudioList?.data?[index].creatorAbout,
                  description: recentAudioList?.data?[index].description,
                  creatorName: recentAudioList?.data?[index].creatorName,
                  userId: user?.userId,
                ));
              }

              downloadIndicator =
                  (downloadRatio * 100).toStringAsFixed(0) + "% completed";
            });
          }
        }
      }).whenComplete(() async {
        if (mounted) {
          setState(() {
            recentAudioList?.data?[index].isFavouriteIconVisible = true;
          });
        }

        downloadIndicator = 0.toString() + "% completed";
        //   FormData data = FormData.fromMap(
        //       {"catalogue_id": purchaseList?.data?[index].data?[i].catalogueId});
        //
        //   await ApiService().addCatalogueDownload(
        //       context: context, userRegisterModel: user!, data: data);
      });

      print(response.statusCode);
    } on DioError catch (e) {
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
        recentAudioList?.data?[index].isIndicator = 3;
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

  Widget visibility(int index) {
    if (recentAudioList?.data?[index].isIndicator == 1) {
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
              style: TextStyle(color: AppColor.primarycolor),
            ),
          ]),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Container(
              width: 40.w,
              child: LinearProgressIndicator(
                  backgroundColor: AppColor.grey,
                  color: AppColor.primarycolor,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColor.primarycolor),
                  minHeight: .5.h,
                  value: downloadRatio
                  //  color: AppColor.primarycolor,
                  //backgroundColor: AppColor.grey,
                  ),
            ),
          ),
        ]),
      );
    }
    if (recentAudioList?.data?[index].isIndicator == 2) {
      return Visibility(visible: true, child: playButtonOne(index)
          // playButton(context, index, i, id)
          );
    }
    return SizedBox(
      height: 4.5.h,
      width: 28.w,
      child: TextButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(StadiumBorder()),
            side: MaterialStateProperty.all(BorderSide(
                color: AppColor.primarycolor,
                width: 2,
                style: BorderStyle.solid))),
        onPressed: () {
          downloadAudioPopUp(
            context,
            recentAudioList!.data![index].musicFile.toString(),
            recentAudioList!.data![index].title.toString(),
            index,
          );
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

  Widget offlineData() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 2.h,
      ),
      Text(
        "Recents",
        style: CustomTextStyle.body1
            .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w900),
      ),
      FutureBuilder(
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
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          List<Music>? musicData = snapshot.data;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CachedNetworkImage(
                                imageUrl:
                                    snapshot.data![index].image.toString(),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                        width: 80,
                                        height: 82,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: imageProvider))),
                                placeholder: (context, url) => Container(
                                  padding: EdgeInsets.all(10),
                                  width: 80,
                                  height: 82,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.scaleDown,
                                        scale: 5,
                                        colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.2),
                                            BlendMode.dstATop),
                                        image: AssetImage(Images.onlyLogo)),
                                    color: AppColor.grey,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                    width: 80,
                                    height: 82,
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                          image: AssetImage(Images.onlyLogo)),
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
                                child: Container(
                                  width: 50,
                                  height: 95,
//width: double.infinity,
//color: Colors.red,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: snapshot
                                                            .data![index]
                                                            .musicTitle!
                                                            .length >=
                                                        28
                                                    ? Text(
                                                        "${snapshot.data?[index].musicTitle?.substring(0, 28)}",
                                                        style: CustomTextStyle
                                                            .body3
                                                            .copyWith(
                                                                fontSize:
                                                                    12.sp),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )
                                                    : Text(
                                                        snapshot.data?[index]
                                                                .musicTitle ??
                                                            "",
                                                        style: CustomTextStyle
                                                            .body3
                                                            .copyWith(
                                                                fontSize:
                                                                    12.sp),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                                      .copyWith(
                                                          fontSize: 11.sp),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            ]),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Row(
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
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              Icons.clear,
                                                                              color: AppColor.grey,
// size: 3.5.h,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      Container(
//   color: Colors.red,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            CachedNetworkImage(
                                                                              imageUrl: snapshot.data?[index].image ?? "",
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
                                                                              width: 2.w,
                                                                            ),
                                                                            Expanded(
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  snapshot.data![index].musicTitle!.length >= 28
                                                                                      ? Text(
                                                                                          "${snapshot.data?[index].musicTitle?.substring(0, 28)}",
                                                                                          maxLines: 2,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: CustomTextStyle.body3.copyWith(color: AppColor.white),
                                                                                        )
                                                                                      : Text(
                                                                                          snapshot.data?[index].musicTitle ?? "",
                                                                                          maxLines: 2,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: CustomTextStyle.body3.copyWith(color: AppColor.white),
                                                                                        ),
                                                                                  Padding(
                                                                                    padding: EdgeInsets.only(top: 6),
                                                                                    child: Text(
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
                                                                      ),

                                                                      SizedBox(
                                                                        height:
                                                                            2.h,
                                                                      ),

                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          // ratingAndCount(),
                                                                          const Icon(
                                                                            Icons.fiber_manual_record,
                                                                            color:
                                                                                AppColor.white,
                                                                            size:
                                                                                7,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SvgPicture.asset(AppIcon.clockIcon),
                                                                              SizedBox(
                                                                                width: 1.w,
                                                                              ),
                                                                              Text(
                                                                                snapshot.data?[index].musicDuration ?? "",
                                                                                style: CustomTextStyle.body1.copyWith(fontSize: 10.sp),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          const Icon(
                                                                            Icons.fiber_manual_record,
                                                                            color:
                                                                                AppColor.white,
                                                                            size:
                                                                                7,
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {},
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                SvgPicture.asset(AppIcon.sizeIcon),
                                                                                SizedBox(
                                                                                  width: 1.w,
                                                                                ),
                                                                                Text(
                                                                                  snapshot.data?[index].musicFileSize ?? "",
//"${music.}",,,
                                                                                  style: CustomTextStyle.body1.copyWith(fontSize: 10.sp),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              2.h),

                                                                      snapshot.data![index].description!.length >=
                                                                              512
                                                                          ? Text(
                                                                              "${snapshot.data?[index].description?.substring(0, 512)}",
                                                                              style: CustomTextStyle.body1,
                                                                            )
                                                                          : Text(
                                                                              snapshot.data?[index].description ?? "",
                                                                              style: CustomTextStyle.body1,
                                                                            ),
                                                                      SizedBox(
                                                                        height:
                                                                            2.h,
                                                                      ),
                                                                      Text(
                                                                        "About ${snapshot.data?[index].creatorName}",

// maxLines: 1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: CustomTextStyle
                                                                            .body3,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            1.h,
                                                                      ),

                                                                      snapshot.data![index].creatorAbout!.length >=
                                                                              512
                                                                          ? Text(
                                                                              "${snapshot.data![index].creatorAbout?.substring(0, 512)}",
                                                                              style: CustomTextStyle.body1,
                                                                              textAlign: TextAlign.start,
                                                                            )
                                                                          : Text(
                                                                              snapshot.data![index].creatorAbout ?? "",
                                                                              style: CustomTextStyle.body1,
                                                                              textAlign: TextAlign.start,
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
                                                                EdgeInsets.all(
                                                                    .2.h)),
                                                            backgroundColor:
                                                                MaterialStateProperty.all(
                                                                    Colors
                                                                        .black),
                                                            foregroundColor:
                                                                MaterialStateProperty.all(
                                                                    AppColor
                                                                        .grey),
                                                            shape: MaterialStateProperty.all(
                                                                RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(20))),
                                                            side: MaterialStateProperty.all(BorderSide(color: AppColor.grey, width: 2, style: BorderStyle.solid))),
                                                        child: const Icon(
                                                          Icons.more_horiz,
                                                          color: AppColor.grey,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    width: 1.w,
                                                  ),
                                                  // ratingAndCount(),
                                                  SizedBox(
                                                    width: 1.w,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4),
                                                child: CustomPlayNowButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                MusicPlayerScreenTwo(
                                                                  musicdata:
                                                                      musicData,
                                                                  musicIndex:
                                                                      index,
                                                                  tokenData:
                                                                      storeToken,
                                                                )));
                                                  },
                                                )
                                                // playButtonOne(
                                                //     context,
                                                //     musicData!,
                                                //     index,
                                                //     musicData[index].id!.toInt(),
                                                //     storeToken!)
                                                )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
                  );
          }),
    ]);
  }
}
