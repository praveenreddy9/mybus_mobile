import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mybus_mobile/HomePage.dart';
import 'package:mybus_mobile/screens/authentication/LoginPage.dart';
import 'package:mybus_mobile/screens/authentication/OtpPage.dart';
import 'package:mybus_mobile/screens/splash/SplashPage.dart';
// import 'package:provider/provider.dart';
import 'LocalStrings/index.dart';
import 'screens/SettingsPage.dart';
import 'utility/CustomAnimation.dart';

Future<void> main() async {
  runApp(
    MyApp(),
  );
  configLoading();
}

// Future<void> main() async {
//   runApp(MultiProvider(
//     providers: [
//       ChangeNotifierProvider<SettingsPage>(
//         create: (context) => SettingsPage(),
//       ),
//     ],
//     child: MyApp(),
//   ));
//   configLoading();
// }

class MyApp extends StatefulWidget {
  @override
  State createState() {
    return MyAppState();
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCube
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    // return MaterialApp(
    //   title: '',
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     platform: TargetPlatform.iOS,
    //   ),
    //   // home: const SplashPage(),
    //   home: SettingsPage(),
    //   builder: EasyLoading.init(),
    //   routes: {
    //     "/SettingsPage": (context) => SettingsPage(),
    //   },
    // );
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: LocaleStringsList(),
      locale: Locale('en', 'IN'),
      title: 'myBus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      builder: EasyLoading.init(),
      routes: {
        "/SplashPage": (context) => SplashPage(),
        "/LoginPage": (context) => LoginPage(),
        "/OtpPage": (context) => OtpPage(),
        "/SettingsPage": (context) => SettingsPage(),
      },
    );
  }
}
