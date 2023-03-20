import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audioplayers_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_icon.dart';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/model/favrouiteList_model.dart';
import 'package:elloro/model/favrouite_audio_model.dart';
import 'package:elloro/model/get_user_data.dart';
import 'package:elloro/model/rating_model.dart';
import 'package:elloro/model/token_model.dart';
import 'package:elloro/model/user_register_model.dart';
import 'package:elloro/provider/provider.dart';
import 'package:elloro/services/auth_service.dart';
import 'package:elloro/widget/custom_button.dart';
import 'package:elloro/widget/custom_dialog.dart';
import 'package:elloro/widget/custom_padding.dart';
import 'package:elloro/widget/custom_profile_picture.dart';
import 'package:elloro/widget/custom_small_yellow_button.dart';
import 'package:elloro/widget/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MusicPlayerScreenThird extends StatefulWidget {
  // List<Music>? musicdata;
  List<TokenModel>? tokenData;
  // int? musicIndex;
  int? index;

  List<FavrouiteMusicList>? catalogeListData;
  MusicPlayerScreenThird({
    Key? key,
    this.catalogeListData,
    //this.musicdata,
    // this.musicIndex,
    this.tokenData,
    this.index,
  }) : super(key: key);

  @override
  _MusicPlayerScreenThirdState createState() => _MusicPlayerScreenThirdState();
}

class _MusicPlayerScreenThirdState extends State<MusicPlayerScreenThird> {
  UserRegisterModel? user;
  GetUserData? getUserData;
  bool isButtonUnVisible = false;
  int value = 3;
  bool isPlaying = true;
  int intialindex = 0;
  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isRepeat = false;
  Color color = AppColor.white;
  bool nextPlay = false;
  List<TokenModel>? tokenData;
  Rating? ratingData;
  FavouriteAudio? favouriteAudio;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();

    if (isPlaying == true) {
      audioPlayer
          .play(widget.catalogeListData![widget.index!].musicFile.toString());
    }

    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.PLAYING;
        });
      }
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    if (mounted) {
      audioPlayer.onAudioPositionChanged.listen((newPosition) {
        if (mounted) {
          setState(() {
            position = newPosition;
          });
        }
      });
    }

    audioPlayer.onPlayerCompletion.listen((state) {
      setState(() {
        // position = Duration.zero;
        isPlaying = false;
      });

      // if (widget.musicIndex! < widget.musicdata!.length - 1) {
      //   widget.musicIndex = widget.musicIndex! + 1;
      //   audioPlayer.play(widget.musicdata![widget.musicIndex!].path.toString());
      // } else {
      //   widget.musicIndex = 0;
      //   audioPlayer.play(widget.musicdata![widget.musicIndex!].path.toString());
      // }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.dispose();
  }

  getToken() async {
    user = Provider.of<UserProvider>(context, listen: false).getUser!;
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    //
    // user = UserRegisterModel.fromJson(
    //     jsonDecode(preferences.getString('user') ?? ""));

    getUserData = await ApiService()
        .getUserData(context: context, userRegisterModel: user!);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider(
                    "${widget.catalogeListData?[widget.index!].image}"),
                fit: BoxFit.cover)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            color: Colors.black.withOpacity(.79),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(
                  StringConstant.play,
                  style: CustomTextStyle.headline2,
                ),
                titleSpacing: 10,
                toolbarHeight: 11.h,
                elevation: 0,
                backgroundColor: Colors.transparent,
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        MyButton()
                            .tokenButton(getUserData?.data?.totalToken ?? "0"),
                        SizedBox(width: 2.w),
                        CustomProfilePicture(
                          url: user?.image ?? "",
                        )
                      ],
                    ),
                  )
                ],
              ),
              body: CustomPadding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [bannerImage(widget.index!)]),
                    SizedBox(
                      height: 4.h,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          nameBanner(),
                        ]),
                    SizedBox(
                      height: 1.h,
                    ),
                    subTitleBanner(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        moreBanner(),
                        SizedBox(
                          width: 2.w,
                        ),
                        starButton(),
                        SizedBox(
                          width: 2.w,
                        ),
                        ratingButton(),
                      ],
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    musicContainer(),
                    Expanded(child: SizedBox())
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  //widget

  Widget bannerImage(int index) {
    return CachedNetworkImage(
      imageBuilder: (context, imageProvider) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
          alignment: Alignment.topRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [favrouiteIcon(index)],
          ),
          width: 65.w,
          height: 30.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              image: DecorationImage(fit: BoxFit.fill, image: imageProvider)),
        );
      },
      imageUrl: widget.catalogeListData?[widget.index!].image ?? "",
      placeholder: (context, url) => Container(
        width: 65.w,
        height: 30.h,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.grey,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Center(
          child: Image.asset(
            Images.onlyLogo,
            color: AppColor.darkGrey,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: 65.w,
        height: 30.h,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.grey,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Center(
          child: Image.asset(
            Images.onlyLogo,
            color: AppColor.darkGrey,
          ),
        ),
      ),
    );

    // Stack(
    //   children: [
    //     Container(
    //       margin: EdgeInsets.symmetric(horizontal: 10.w),
    //       child: AspectRatio(
    //           aspectRatio: 20 / 18,
    //           child: ClipRRect(
    //             borderRadius: BorderRadius.circular(35),
    //             child: CachedNetworkImage(
    //               fit: BoxFit.cover,
    //               imageUrl:
    //                   widget.catalogeListData![widget.index!].image.toString()
    //               //widget.catalogeListData?[widget.index!].image ?? ""
    //               ,
    //               placeholder: (context, url) => CircularProgressIndicator(),
    //             ),
    //           )),
    //     ),
    //     favrouiteIcon(index)
    //   ],
    // );
  }

  Widget musicContainer() {
    return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.5.w),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (position)
                        .toString()
                        .split(".")[0]
                        .toString()
                        .substring(2, 7),
                    style: const TextStyle(color: AppColor.white),
                  ),
                  Text(
                      duration
                          .toString()
                          .split(".")[0]
                          .toString()
                          .substring(2, 7),
                      style: const TextStyle(color: AppColor.white))
                ],
              ),
            ]),
          ),
          Slider(
            min: 0,
            max: duration.inSeconds.toDouble(),
            activeColor: AppColor.primarycolor,
            inactiveColor: AppColor.black,
            value: position.inSeconds.toDouble(),
            thumbColor: AppColor.primarycolor,
            onChanged: (value) async {
              position = Duration(seconds: value.toInt());
              await audioPlayer.seek(position);
            },
          ),
          Expanded(
            child: SizedBox(
              child: musicPlayerButton(),
            ),
          )
        ]),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColor.grey.withOpacity(.12),
        ),
        width: double.infinity,
        height: 23.h,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10));
  }

  Widget ratingButton() {
    return SizedBox(
        child: TextButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
                foregroundColor:
                    MaterialStateProperty.all(AppColor.primarycolor),
                backgroundColor: MaterialStateProperty.all(
                  AppColor.grey.withOpacity(.12),
                )),
            onPressed: () {
              submitRating(context);
            },
            child: Text(
              StringConstant.rateThisAudio,
              style:
                  CustomTextStyle.body1.copyWith(color: AppColor.primarycolor),
            )));
  }

  Widget nameBanner() {
    return Expanded(
        child:
            // widget.catalogeListData![widget.index!].title!.length >= 28
            //     ? SizedBox(
            //   height: 40,
            //   child: Marquee(
            //     fadingEdgeStartFraction: .1,
            //     fadingEdgeEndFraction: .1,
            //     blankSpace: 10,
            //
            //     style: CustomTextStyle.headline2,
            //     //   maxLines: 1,
            //     //overflow: TextOverflow.ellipsis,
            //     text: "${widget.catalogeListData?[widget.index!].title}",
            //   ),
            // )
            //     :
            Text(
      "${widget.catalogeListData?[widget.index!].title}",
      style: CustomTextStyle.headline2,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    )

        // Text(
        //   widget.catalogeListData![widget.index!].title.toString(),
        //   style: CustomTextStyle.headline2,
        //   maxLines: 1,
        //   overflow: TextOverflow.ellipsis,
        // ),
        );
  }

  Widget pauseButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: AppColor.white),
                  bottom: BorderSide(color: AppColor.white),
                  left: BorderSide(color: AppColor.white),
                  right: BorderSide(color: AppColor.white)),
              borderRadius: BorderRadius.circular(50)),
          child: Icon(
            Icons.pause_outlined,
            color: Colors.white,
          )),
    );
  }

  Widget subTitleBanner() {
    return Expanded(
      child: Text(
        widget.catalogeListData![widget.index!].creatorName.toString()
        //widget.catalogeListData?[widget.index!].subTitle ?? ""
        ,
        style: CustomTextStyle.body4,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget musicPlayerButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // SizedBox(
        //   width: 5.w,
        // ),
        CupertinoButton(
          onPressed: () {
            setState(() {
              isRepeat = !isRepeat;
            });

            if (isRepeat == true) {
              audioPlayer.setReleaseMode(ReleaseMode.LOOP);
            } else {
              audioPlayer.setReleaseMode(ReleaseMode.RELEASE);
            }
          },
          child: SvgPicture.asset(AppIcon.loopIcon,
              color:
                  isRepeat == false ? AppColor.white : AppColor.primarycolor),
        ),
        Expanded(child: SizedBox()),
        GestureDetector(
            onTap: () {
              if ((widget.index!) > 0) {
                widget.index = widget.index! - 1;

                audioPlayer.play(
                    //widget.musicdata!.path.toString()
                    widget.catalogeListData![widget.index!].musicFile
                        .toString());
              } else {
                widget.index = widget.catalogeListData!.length - 1;

                audioPlayer.play(widget
                    .catalogeListData![widget.index!].musicFile
                    .toString());
              }

              //else {
              //   widget.index = widget.catalogeListData!.length - 1;
              //   audioPlayer.play(widget
              //       .catalogeListData![widget.index!].musicFile
              //       .toString());
              // }

              // widget.index = widget.index! - 1;

              // setState(() {
              //   widget.catalogeListData;
              // });
              // audioPlayer.play(
              //     widget.catalogeListData?[widget.index!].musicFile ?? "");
            },
            child: Icon(
              Icons.skip_previous,
              color: AppColor.white,
              size: 40,
            )),
        SizedBox(
          width: 3.w,
        ),
        GestureDetector(
          onTap: () {
            if (isPlaying) {
              audioPlayer.pause();
            } else {
              // widget.catalogeListData?[widget.index!].musicFile ?? ""

              audioPlayer.play(
                  widget.catalogeListData![widget.index!].musicFile.toString());
            }
            setState(() {
              isPlaying = !isPlaying;
            });
          },
          child: isPlaying == false
              ? Icon(Icons.play_circle_outlined,
                  color: AppColor.white, size: 60)
              : Icon(
                  Icons.pause_circle_outlined,
                  color: AppColor.white,
                  size: 60,
                ),
        ),
        SizedBox(
          width: 3.w,
        ),
        GestureDetector(
            onTap: () {
              if ((widget.index!) < widget.catalogeListData!.length - 1) {
                widget.index = widget.index! + 1;
                audioPlayer.play(widget
                    .catalogeListData![widget.index!].musicFile
                    .toString());
              } else {
                widget.index = 0;
                audioPlayer.play((widget.catalogeListData![widget.index!])
                    .musicFile
                    .toString());
              }

              //widget.index = widget.index! + 1;

              // setState(() {
              //   widget.catalogeListData;
              // });
              // audioPlayer.play(
              //     widget.catalogeListData?[widget.index!].musicFile ?? "");
            },
            child: Icon(
              Icons.skip_next,
              color: AppColor.white,
              size: 40,
            )),
        Expanded(flex: 3, child: SizedBox())
      ],
    );
  }

  Widget starButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.catalogeListData?[widget.index!].avgRate ?? "0",
              style: TextStyle(color: AppColor.primarycolor, fontSize: 11.sp),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Icon(
                Icons.star,
                size: 2.2.h,
                color: AppColor.primarycolor,
              ),
            )
          ],
        ),
        width: 15.w,
        height: 4.2.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color:
              //Colors.red

              AppColor.grey.withOpacity(.12),
        ),
      ),
    );
  }

  Future submitRating(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUp(
              content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.cancel_outlined,
                        color: AppColor.grey,
                        // size: 3.5.h,
                      ),
                    )
                  ],
                ),
                image(),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  "Give Rating for " +
                      "${widget.catalogeListData?[widget.index!].title}",
                  style: CustomTextStyle.body3.copyWith(color: AppColor.white),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  "${widget.catalogeListData?[widget.index!].creatorName}",
                  style: CustomTextStyle.body4,
                  // textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 3.h,
                ),
                StatefulBuilder(
                  builder: (BuildContext context,
                      void Function(void Function()) setState) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(
                            5,
                            (index) => IconButton(
                                  icon: index < intialindex
                                      ? const Icon(
                                          Icons.star,
                                          size: 30,
                                          color: AppColor.primarycolor,
                                        )
                                      : const Icon(
                                          Icons.star_border,
                                          size: 30,
                                          color: AppColor.primarycolor,
                                        ),
                                  onPressed: () {
                                    setState(() {
                                      intialindex = index + 1;
                                      print(intialindex);
                                    });
                                  },
                                )),
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: 3.5.h,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  CoustomSmallButton(
                    onPressed: () async {
                      if (intialindex != 0) {
                        FormData data = FormData.fromMap({
                          "catalogue_id": widget
                              .catalogeListData?[widget.index!].catalogueId,
                          "rate": intialindex
                        });
                        ratingData = await ApiService().catalogRating(
                            context: context,
                            userRegisterModel: user!,
                            data: data);
                      } else {
                        GlobalSnackBar.show(context, "Please Enter Rating");
                      }
                    },
                    title: StringConstant.submit,
                    style: CustomTextStyle.body1.copyWith(
                        color: AppColor.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: CustomTextStyle.fontFamilyMontserrat),
                  ),
                ])
              ]));
        });
  }

  Widget rating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(
            5,
            (index) => IconButton(
                  icon: index < intialindex
                      ? Icon(
                          Icons.star,
                          size: 27,
                          color: AppColor.primarycolor,
                        )
                      : Icon(
                          Icons.star_border,
                          size: 27,
                          color: AppColor.primarycolor,
                        ),
                  onPressed: () {
                    setState(() {
                      intialindex = index + 1;
                    });
                  },
                )),
      ],
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

  Widget moreBanner() {
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
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                            widget
                                                .catalogeListData![
                                                    widget.index!]
                                                .image
                                                .toString(),
                                            scale: 10))),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    widget.catalogeListData![widget.index!]
                                                .title!.length >=
                                            28
                                        ? Text(
                                            "${widget.catalogeListData?[widget.index!].title?.substring(0, 28)}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: CustomTextStyle.body3
                                                .copyWith(
                                                    color: AppColor.white),
                                          )
                                        : Text(
                                            widget
                                                    .catalogeListData?[
                                                        widget.index!]
                                                    .title ??
                                                "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: CustomTextStyle.body3
                                                .copyWith(
                                                    color: AppColor.white),
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        widget.catalogeListData![widget.index!]
                                            .creatorName
                                            .toString(),
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
                            ratingAndCount(widget.index!),
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
                                  widget
                                      .catalogeListData![widget.index!].duration
                                      .toString(),
                                  style: CustomTextStyle.body1
                                      .copyWith(fontSize: 10.sp),
                                )
                              ],
                            ),
                            Icon(
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
                                  widget.catalogeListData![widget.index!]
                                      .musicFileSize
                                      .toString()

                                  // widget.catalogeListData?[widget.index!]
                                  //         .musicFileSize ??
                                  //     ""
                                  ,
                                  style: CustomTextStyle.body1
                                      .copyWith(fontSize: 10.sp),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 2.h),
                        widget.catalogeListData![widget.index!].description!
                                    .length >=
                                512
                            ? Text(
                                "${widget.catalogeListData?[widget.index!].description?.substring(0, 512)}",
                                style: CustomTextStyle.body1,
                              )
                            : Text(
                                widget.catalogeListData?[widget.index!]
                                        .description ??
                                    "",
                                style: CustomTextStyle.body1,
                              ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          "About ${widget.catalogeListData![widget.index!].creatorName
                          //widget.catalogeListData?[widget.index!].creatorName ?? ""
                          }",

                          // maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyle.body3,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),

                        widget.catalogeListData![widget.index!].creatorAbout!
                                    .length >=
                                512
                            ? Text(
                                "${widget.catalogeListData?[widget.index!].creatorAbout?.substring(0, 512)}",
                                style: CustomTextStyle.body1,
                                textAlign: TextAlign.start,
                              )
                            : Text(
                                widget.catalogeListData?[widget.index!]
                                        .creatorAbout ??
                                    "",
                                style: CustomTextStyle.body1,
                                textAlign: TextAlign.start,
                              ), //image(),
                        SizedBox(height: 3.h),

                        // Row(
                        //     mainAxisAlignment:
                        //     MainAxisAlignment.center,
                        //     children: [
                        //       Container(
                        //         alignment: Alignment.center,
                        //         height: 5.h,
                        //         width: 20.w,
                        //         decoration: const ShapeDecoration(
                        //           shape: StadiumBorder(side: BorderSide(width: 2, color: AppColor.blue)),
                        //         ),
                        //         child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        //           Padding(
                        //             padding: EdgeInsets.only(bottom: 2),
                        //             child: Text(format.currencySymbol, style: TextStyle(color: AppColor.blue, fontSize: 12.sp)),
                        //           ),
                        //           Text(
                        //             " ${catalogeList?.data?[index].categorydata?[i].tokenPrice}",
                        //             style: CustomTextStyle.body6.copyWith(fontSize: 12.sp),
                        //           ),
                        //         ]),
                        //       ),
                        //     ])
                      ]),
                ));
              },
              context: context,
            );

            // MyPopUp().detailPopUp(context);
          },
          style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.all(.2.h)),
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              foregroundColor: MaterialStateProperty.all(AppColor.grey),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
              side: MaterialStateProperty.all(BorderSide(
                  color: AppColor.grey, width: 2, style: BorderStyle.solid))),
          child: Icon(
            Icons.more_horiz,
            color: AppColor.grey,
          )),
    );
  }

  Widget favrouiteIcon(int index) {
    return Container(
      width: 40,
      height: 40,
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: AppColor.black.withOpacity(.5),
          borderRadius: BorderRadius.circular(13)),
      child: InkWell(
          onTap: () async {
            setState(() {
              if (widget.catalogeListData?[index].favourite == 0) {
                widget.catalogeListData?[index].favourite = 1;
              } else {
                widget.catalogeListData?[index].favourite = 0;
              }
            });

            FormData data = FormData.fromMap(
                {"catalogue_id": widget.catalogeListData?[index].catalogueId});
            favouriteAudio = await ApiService().favouriteAudio(
                context: context, userRegisterModel: user!, data: data);
          },
          child: widget.catalogeListData?[index].favourite == 0
              ? const Icon(
                  Icons.favorite_border,
                  size: 25,
                  color: AppColor.white,
                )
              : const Icon(
                  Icons.favorite,
                  size: 25,
                  color: AppColor.orange,
                )),
    );
  }

  Widget ratingAndCount(int index) {
    return Container(
      // color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star,
            size: 2.2.h,
            color: AppColor.primarycolor,
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              widget.catalogeListData?[index].avgRate ?? "0",
              style: CustomTextStyle.body4.copyWith(fontSize: 11.sp),
            ),
          ),
        ],
      ),
    );
  }
}
