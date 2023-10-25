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
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.07),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        onBackPressed();
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1),
                                        // width:
                                        //     MediaQuery.of(context).size.width *
                                        //         0.07,
                                        // height:
                                        //     MediaQuery.of(context).size.width *
                                        //         0.05,
                                        child: Image.asset(
                                          'assets/images/back.png',
                                          height: 11.47,
                                          width: 17.2,
                                          color: headerBackIconColor,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02),
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      child: const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Back',
                                          style: TextStyle(
                                            fontFamily: ffGRegular,
                                            color: headerButtonTextColor,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        onBackPressed();
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.58),
                                        // width:
                                        //     MediaQuery.of(context).size.width *
                                        //         0.05,
                                        // height:
                                        //     MediaQuery.of(context).size.width *
                                        //         0.05,
                                        child: Image.asset(
                                          'assets/images/cancel.png',
                                          height: 13.42,
                                          width: 13.43,
                                          color: titleColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.1,
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.15),
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'HOME',
                                  style: TextStyle(
                                    fontFamily: ffGBold,
                                    color: titleColor,
                                    fontSize: 50.0,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  buildLanguageDialog(context);
                                },
                                child: Text('changelang'.tr)),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.03,
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Sent to the registered email',
                                  style: TextStyle(
                                    fontFamily: ffGRegular,
                                    color: subTitleColor,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              width: MediaQuery.of(context).size.width * 0.8,
                              // height: MediaQuery.of(context).size.height * 0.03,
                              child: Row(
                                children: [
                                  OtpTextField(
                                    fillColor: Color.fromRGBO(245, 245, 245, 1),
                                    numberOfFields: 4,
                                    focusedBorderColor:
                                        Color.fromRGBO(219, 219, 219, 1),
                                    borderWidth: 2.0,
                                    borderColor:
                                        Color.fromRGBO(219, 219, 219, 1),
                                    //set to true to show as box or false to show as dash
                                    showFieldAsBox: true,
                                    fieldWidth: ScreenSizes.returnOTPBoxesSize()
                                        .toDouble(),
                                    // deviceName == 'iPhone Xʀ' ? 73 : 70,

                                    textStyle: TextStyle(
                                        fontSize: 30, fontFamily: ffGMedium),

                                    // keyboardType: TextInputType.number,
                                    keyboardType: defaultTargetPlatform ==
                                            TargetPlatform.iOS
                                        ? TextInputType.numberWithOptions(
                                            decimal: true, signed: true)
                                        : TextInputType.number,

                                    //runs when a code is typed in
                                    onCodeChanged: (String code) {
                                      //handle validation or checks here
                                      // print('code===== $code');
                                      setState(() {
                                        verificationCode = '';
                                      });
                                    },
                                    //runs when every textfield is filled
                                    onSubmit: (String otpCode) {
                                      // print('otpCode=== $otpCode');
                                      setState(() {
                                        verificationCode = otpCode;
                                      });
                                      FocusScope.of(context).unfocus();
                                    }, // end onSubmit
                                  ),
                                  // Container(
                                  //   width: 70,
                                  //   height: 70,
                                  //   margin: EdgeInsets.all(4),
                                  //   alignment: Alignment.center,
                                  //   decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(5),
                                  //       color: otpInputBoxColor,
                                  //       border: Border.all(
                                  //           width: 1,
                                  //           color: border,
                                  //           style: BorderStyle.solid)),
                                  //   child: TextField(
                                  //     autofocus: true,
                                  //     keyboardType: defaultTargetPlatform ==
                                  //             TargetPlatform.iOS
                                  //         ? TextInputType.numberWithOptions(
                                  //             decimal: true, signed: true)
                                  //         : TextInputType.number,
                                  //     textAlign: TextAlign.center,
                                  //     style: TextStyle(
                                  //         fontSize: 30, fontFamily: ffGMedium),
                                  //     decoration: const InputDecoration(
                                  //         contentPadding: EdgeInsets.all(4),
                                  //         border: InputBorder.none),
                                  //     onChanged: (value) {
                                  //       _loginRequest.otp1 = value;
                                  //     },
                                  //   ),
                                  // ),
                                  // Container(
                                  //   width: 70,
                                  //   height: 70,
                                  //   margin: EdgeInsets.all(4),
                                  //   alignment: Alignment.center,
                                  //   decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(5),
                                  //       color: otpInputBoxColor,
                                  //       border: Border.all(
                                  //           width: 1,
                                  //           color: border,
                                  //           style: BorderStyle.solid)),
                                  //   child: TextField(
                                  //     autofocus: true,
                                  //     keyboardType: defaultTargetPlatform ==
                                  //             TargetPlatform.iOS
                                  //         ? TextInputType.numberWithOptions(
                                  //             decimal: true, signed: true)
                                  //         : TextInputType.number,
                                  //     textAlign: TextAlign.center,
                                  //     style: TextStyle(
                                  //         fontSize: 30, fontFamily: ffGMedium),
                                  //     decoration: const InputDecoration(
                                  //         contentPadding: EdgeInsets.all(4),
                                  //         border: InputBorder.none),
                                  //     onChanged: (value) {
                                  //       _loginRequest.otp2 = value;
                                  //     },
                                  //   ),
                                  // ),
                                  // Container(
                                  //   width: 70,
                                  //   height: 70,
                                  //   margin: EdgeInsets.all(4),
                                  //   alignment: Alignment.center,
                                  //   decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(5),
                                  //       color: otpInputBoxColor,
                                  //       border: Border.all(
                                  //           width: 1,
                                  //           color: border,
                                  //           style: BorderStyle.solid)),
                                  //   child: TextField(
                                  //     autofocus: true,
                                  //     keyboardType: defaultTargetPlatform ==
                                  //             TargetPlatform.iOS
                                  //         ? TextInputType.numberWithOptions(
                                  //             decimal: true, signed: true)
                                  //         : TextInputType.number,
                                  //     textAlign: TextAlign.center,
                                  //     style: TextStyle(
                                  //         fontSize: 30, fontFamily: ffGMedium),
                                  //     decoration: const InputDecoration(
                                  //         contentPadding: EdgeInsets.all(4),
                                  //         border: InputBorder.none),
                                  //     onChanged: (value) {
                                  //       _loginRequest.otp3 = value;
                                  //     },
                                  //   ),
                                  // ),
                                  // Container(
                                  //   width: 70,
                                  //   height: 70,
                                  //   margin: EdgeInsets.all(4),
                                  //   alignment: Alignment.center,
                                  //   decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(5),
                                  //       color: otpInputBoxColor,
                                  //       border: Border.all(
                                  //           width: 1,
                                  //           color: border,
                                  //           style: BorderStyle.solid)),
                                  //   child: TextField(
                                  //     autofocus: true,
                                  //     keyboardType: defaultTargetPlatform ==
                                  //             TargetPlatform.iOS
                                  //         ? TextInputType.numberWithOptions(
                                  //             decimal: true, signed: true)
                                  //         : TextInputType.number,
                                  //     textAlign: TextAlign.center,
                                  //     style: TextStyle(
                                  //         fontSize: 30, fontFamily: ffGMedium),
                                  //     decoration: const InputDecoration(
                                  //         contentPadding: EdgeInsets.all(4),
                                  //         border: InputBorder.none),
                                  //     onChanged: (value) {
                                  //       _loginRequest.otp4 = value;
                                  //       FocusScope.of(context).unfocus();
                                  //     },
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()));

                                // if (verificationCode != null) {
                                //   if (verificationCode.length == 4) {
                                //     if (onlyNumberRegex
                                //         .hasMatch(verificationCode)) {
                                //       // print('reached final =====');
                                //       onOTPverify(verificationCode);
                                //     } else {
                                //       _showSnackBar("Please enter only numbers",
                                //           context, false);
                                //     }
                                //   } else {
                                //     _showSnackBar("Please enter 4 digit OTP",
                                //         context, false);
                                //   }
                                // } else {
                                //   _showSnackBar(
                                //       "Please enter OTP", context, false);
                                // }
                              },
                              child: Container(
                                margin: keyboardVisible == 1
                                    ? EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.09,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.09)
                                    : EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.09,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.09),
                                child: Card(
                                  // elevation: 10,
                                  // color: appColor,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      side: BorderSide(width: 1, color: white)),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
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
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: const Text(
                                      "LOGIN",
                                      style: TextStyle(
                                        fontFamily: ffGBold,
                                        fontSize: 20.0,
                                        color: white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.03,
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.width * 0.01,
                                  left: MediaQuery.of(context).size.width * 0.1,
                                  right:
                                      MediaQuery.of(context).size.width * 0.1),
                              child: Center(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.width *
                                          0.01),
                                  child: InkWell(
                                      onTap: () {
                                        // reSendOTP();
                                      },
                                      child: const Align(
                                        // alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Resend OTP',
                                          style: TextStyle(
                                            fontFamily: ffGBold,
                                            color:
                                                Color.fromRGBO(246, 0, 11, 1),
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ))),
              ),
            )));
  }
}
