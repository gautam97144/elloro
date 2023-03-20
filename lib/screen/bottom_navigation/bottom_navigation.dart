import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/app_icon.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/model/cataloge_list_model.dart';
import 'package:elloro/screen/catalog_screen/catalog_screen.dart';
import 'package:elloro/screen/home_screen/home_screen.dart';
import 'package:elloro/screen/more_option_screen/more_option.dart';
import 'package:elloro/screen/my_audio_screen/my_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

class BottomNavigation extends StatefulWidget {
  int? index;
  BottomNavigation({Key? key, this.index}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  Duration? duration;
  Duration position = Duration(seconds: 0);
  int isSelected = 0;
  var list = [];
  bool isPopUpOpen = true;
  bool isPlaying = true;
  Categories? cataLogList;
  bool isOpen = false;

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    list = [
      HomeScreen(),
      MyAudio(),
      MusicCatalog(),
      MoreOption(),
    ];
    widget.index == 1 ? _selectedIndex = 3 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: list[_selectedIndex],
      bottomNavigationBar: SizedBox(
        height: 12.h,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          child: BottomNavigationBar(
            selectedLabelStyle:
                CustomTextStyle.body7.copyWith(fontWeight: FontWeight.w400),
            unselectedLabelStyle: CustomTextStyle.body4,
            selectedItemColor: AppColor.primarycolor,
            unselectedItemColor: AppColor.grey,
            selectedFontSize: 6.sp,
            unselectedFontSize: 6.sp,
            backgroundColor: AppColor.black,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            iconSize: 29,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
                //  var currentPage = pages[index];
              });
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: SvgPicture.asset(
                    AppIcon.bottomFirstIcon,
                    color: _selectedIndex == 0
                        ? AppColor.primarycolor
                        : AppColor.grey,
                  ),
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: SvgPicture.asset(
                      AppIcon.bottomSecondIcon,
                      color: _selectedIndex == 1
                          ? AppColor.primarycolor
                          : AppColor.grey,
                    ),
                  ),
                  label: "My Audios"),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: (SvgPicture.asset(
                      AppIcon.bottomThirdIcon,
                      color: _selectedIndex == 2
                          ? AppColor.primarycolor
                          : AppColor.grey,
                    )),
                  ),
                  label: "catalogue".tr),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: SvgPicture.asset(
                      AppIcon.bottomFourthIcon,
                      color: _selectedIndex == 3
                          ? AppColor.primarycolor
                          : AppColor.grey,
                    ),
                  ),
                  label: "More")
            ],
          ),
        ),
      ),
    );
  }
}
