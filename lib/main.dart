import 'package:elloro/provider/internet_connectivity.dart';
import 'package:elloro/provider/internet_connectivity_one%20time.dart';
import 'package:elloro/provider/provider.dart';
import 'package:elloro/screen/splash_screen/splash_screen.dart';
import 'package:elloro/screen/localization_screen/transletion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.black));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (context) => InternetConnectivityCheckOneTime()),
            ChangeNotifierProvider(
                create: (context) => InternetConnectivityCheck()),
            ChangeNotifierProvider(create: (context) => UserProvider()),
            // ChangeNotifierProvider(create: (context) => MusicProvider())
          ],
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            translations: TranslationsUtils(),
            locale: Locale(langCode()),

            //theme: ThemeData(primaryColor: AppColor.primarycolor),
            home: SplashScreen(),
          ),
        );
      },
    );
  }

  String langCode() {
    if (WidgetsBinding.instance!.window.locale.countryCode == 'GB') {
      return 'en_GB';
    } else {
      return 'en_US';
    }
  }
}
