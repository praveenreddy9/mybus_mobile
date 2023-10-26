import 'dart:async';
import 'dart:convert';

// import 'package:cryptology/cryptology.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mybus_mobile/HomePage.dart';
import 'package:mybus_mobile/screens/SettingsPage.dart';
import 'package:mybus_mobile/screens/authentication/LoginPage.dart';
import 'package:mybus_mobile/screens/profileStack/ImagesUpload.dart';
import '/utility/Colors.dart';
import '/utility/Fonts.dart';
import '/utility/ScreenSizes.dart';
import '/utility/Utils.dart';
import '/utility/validations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../../services/config.dart';

class HomePage extends StatefulWidget {
  // const OtpPage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'తెలుగు', 'locale': Locale('tg', 'IN')},
    {'name': 'हिंदी', 'locale': Locale('hi', 'IN')},
    {'name': 'ಕನ್ನಡ', 'locale': Locale('kn', 'IN')},
  ];

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  buildLanguageDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text('Choose Your Language'),
            content: Container(
              width: double.maxFinite,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Text(locale[index]['name']),
                        onTap: () async {
                          var tempLang = index;
                          print(
                              'tempLang=====$tempLang, ${tempLang.runtimeType}');
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString(
                              'language', tempLang.toString());

                          updateLanguage(locale[index]['locale']);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.blue,
                    );
                  },
                  itemCount: locale.length),
            ),
          );
        });
  }

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int? selected = 1;
  int? keyboardVisible = 0;
  final _loginRequest = [];

  String stringResponse = '';
  Map mapResponse = {};
  late var names = [];
  late var totalList = [];
  late var searchData = [];

  String enteredEmail = '';

  var verificationCode;

  String deviceName = '';
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  @override
  void initState() {
    fetchArguments();
    super.initState();
  }

  fetchArguments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tempValue = prefs.getString('language');
    print('stored tempValue====> $tempValue');
  }

  onBackPressed() {
    // Navigator.pop(context, true);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  otpEncrytpion(otpValue) {
    // print('otpValue====> $otpValue');

    final tempKey = encrypt.Key.fromUtf8('1234567890123456');
    final iv = encrypt.IV.fromUtf8('1234567890123456');
    final encrypter =
        encrypt.Encrypter(encrypt.AES(tempKey, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(otpValue, iv: iv);
    // final decrypted = encrypter.decrypt(encrypted, iv: iv);
    // print(encrypted.base64);
    // print(decrypted);
    return encrypted.base64;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: white,
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 1,
                child: Center(
                    child: Container(
                        color: white,
                        child: Column(
                          children: [
                            Container(
                                color: appColor,
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.05,
                                    bottom: MediaQuery.of(context).size.height *
                                        0.01),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        // onBackPressed();
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05),
                                        child:
                                            Icon(Icons.menu, color: titleColor),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        // onBackPressed();
                                        
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8),
                                        child: Icon(Icons.notifications,
                                            color: titleColor),
                                      ),
                                    ),
                                  ],
                                )),
                            ElevatedButton(
                                onPressed: () {
                                  buildLanguageDialog(context);
                                },
                                child: Text('changelang'.tr)),
                            Container(
                              child: Card(
                                elevation: 10,
                                color: white,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    side:
                                        BorderSide(width: 1, color: appColor)),
                                child: Container(
                                  alignment: Alignment.center,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width: MediaQuery.of(context).size.width,
                                  child: const Text(
                                    "PROFILE",
                                    style: TextStyle(
                                      fontFamily: ffGMedium,
                                      fontSize: 14.0,
                                      color: black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Card(
                                elevation: 10,
                                color: timeStampColor,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    side: BorderSide(width: 1, color: white)),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  child: Row(
                                    children: [
                                      //profile tab
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImagesUpload()));
                                        },
                                        child: Container(
                                          child: Card(
                                            elevation: 10,
                                            color: appColor,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                                side: BorderSide(
                                                    width: 1, color: white)),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    reportIncidentStartColor,
                                                    reportIncidentEndColor,
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              child: const Text(
                                                "PROFILE",
                                                style: TextStyle(
                                                  fontFamily: ffGMedium,
                                                  fontSize: 14.0,
                                                  color: white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ))),
              ),
            )));
  }
}
