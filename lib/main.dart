import 'package:flutter/material.dart';
import 'package:mybus_mobile/LocalStrings/index.dart';
import 'HomePage.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: LocaleStringsList(),
      locale: Locale('en', 'IN'),
      title: 'myBus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
