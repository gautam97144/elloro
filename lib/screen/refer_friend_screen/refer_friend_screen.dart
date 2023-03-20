import 'dart:convert';
import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/model/user_register_model.dart';
import 'package:elloro/provider/internet_connectivity.dart';
import 'package:elloro/provider/provider.dart';
import 'package:elloro/screen/refer_friend_screen/body.dart';
import 'package:elloro/screen/version_screen/internet_connectivity/second_screen.dart';
import 'package:elloro/widget/custom_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReferFriend extends StatefulWidget {
  const ReferFriend({Key? key}) : super(key: key);

  @override
  _ReferFriendState createState() => _ReferFriendState();
}

class _ReferFriendState extends State<ReferFriend> {
  UserRegisterModel? user;

  gettoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      user = UserRegisterModel.fromJson(
          jsonDecode(preferences.getString('user') ?? ""));
      print(user?.toString());
    });

    print(preferences.getString('user') ?? '');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).getUser!;

    // gettoken();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColor.black,
          title: Text(
            StringConstant.referFriend,
            style: CustomTextStyle.headline2,
          ),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 10),
                child: Row(children: [
                  CustomProfilePicture(
                    url: user?.image ?? "",
                  ),
                ])),
          ],
        ),
        backgroundColor: Colors.black,
        body: const SafeArea(child: Body()),
      ),
      Provider.of<InternetConnectivityCheck>(context, listen: true).isNoInternet
          ? const NoInternetSecond()
          : const SizedBox.shrink()
    ]);
  }
}
