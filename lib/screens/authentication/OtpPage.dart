import 'dart:async';
import 'dart:convert';

// import 'package:cryptology/cryptology.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

class OtpPage extends StatefulWidget {
  // const OtpPage({Key? key}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
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
    var tempValue = prefs.getString('loggedEmail');
    enteredEmail = tempValue!;
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceName = iosInfo.name;
    setState(() {
      deviceName;
    });
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

  Future onOTPverify(otpValue) async {
    Utils.returnScreenLoader(context);
    http.Response response;
    var tempEncryption = otpEncrytpion(otpValue);
    Map map = {"email": enteredEmail, "otp": tempEncryption};
    var body = json.encode(map);
    // print('OTP body==== $body');
    response = await http.post(Uri.parse(BASE_URL + LOGIN_USER),
        headers: {"Content-Type": "application/json"}, body: body);

    stringResponse = response.body;
    mapResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      print('login resp ==== $mapResponse');
      _showSnackBar(mapResponse['message'], context, mapResponse['success']);
      Navigator.pop(context);
      if (mapResponse["success"]) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // print('============>');
        FocusScope.of(context).unfocus();
        handlingNavigation();
      }
    } else {
      _showSnackBar(mapResponse['message'], context, false);
      Navigator.pop(context);
    }
  }

  handlingNavigation() {
    if (mapResponse['role'] == 'Staff') {
      Navigator.pushNamed(context, '/ticketStatusPage', arguments: {})
          // Navigator.pushNamed(context, '/ticketsListPage', arguments: {})
          .then((_) {
        // This block runs when you have returned back to the 1st Page from 2nd.
        setState(() {
          // Call setState to refresh the page.
        });
      });
    } else {
      Navigator.pushNamed(context, '/ticketsListPage', arguments: {})
          // Navigator.pushNamed(context, '/ticketsListPage', arguments: {})
          .then((_) {
        // This block runs when you have returned back to the 1st Page from 2nd.
        setState(() {
          // Call setState to refresh the page.
        });
      });
    }
  }

  Future reSendOTP() async {
    Utils.returnScreenLoader(context);
    http.Response response;
    Map map = {"email": enteredEmail};
    var body = json.encode(map);

    response = await http.post(Uri.parse(BASE_URL + GET_OTP),
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      stringResponse = response.body;
      mapResponse = json.decode(response.body);
      _showSnackBar(mapResponse['message'], context, mapResponse['success']);
      Navigator.pop(context);
      if (mapResponse["success"]) {}
    } else {
      _showSnackBar(response.body, context, false);
      Navigator.pop(context);
    }
  }

  void _showSnackBar(String message, BuildContext context, ColorCheck) {
    final snackBar = SnackBar(
        content: Text(message),
        backgroundColor: ColorCheck ? Colors.green : Colors.red,
        duration: Utils.returnToastDuration());

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                                  'OTP',
                                  style: TextStyle(
                                    fontFamily: ffGBold,
                                    color: titleColor,
                                    fontSize: 50.0,
                                  ),
                                ),
                              ),
                            ),
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
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (verificationCode != null) {
                                  if (verificationCode.length == 4) {
                                    if (onlyNumberRegex
                                        .hasMatch(verificationCode)) {
                                      // print('reached final =====');
                                      onOTPverify(verificationCode);
                                    } else {
                                      _showSnackBar("Please enter only numbers",
                                          context, false);
                                    }
                                  } else {
                                    _showSnackBar("Please enter 4 digit OTP",
                                        context, false);
                                  }
                                } else {
                                  _showSnackBar(
                                      "Please enter OTP", context, false);
                                }
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
                                        reSendOTP();
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
