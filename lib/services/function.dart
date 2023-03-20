import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:elloro/appconstant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Functions {
  static void toast(String info) {
    Fluttertoast.showToast(
      timeInSecForIosWeb: 1,
      msg: info,
      backgroundColor: AppColor.primarycolor,
      textColor: Colors.black,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static Future<bool> checkConnectivity() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        print("Please turn on mobile data or wifi!");
        Functions.toast("please check you mobile data or wifi connection!");
        return false;
      } else {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        } else {
          print("Please check your internet connectivity!");
          Functions.toast("please check you mobile data or wifi connection!");
          return false;
        }
      }
    } on SocketException catch (_) {
      print("No Internet !");
      Functions.toast("please check you mobile data or wifi connection!");
      return false;
    }
  }
}
