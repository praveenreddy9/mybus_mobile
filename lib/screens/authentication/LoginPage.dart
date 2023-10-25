import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mybus_mobile/screens/SettingsPage.dart';
import 'package:mybus_mobile/screens/authentication/OtpPage.dart';
import '/utility/Colors.dart';
import '/utility/Fonts.dart';
import '/utility/Utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class ScreenArguments {
  String title = 'Praveen';
  String message = 'Testing message';

  ScreenArguments(this.title, this.message);
}

class _LoginPageState extends State<LoginPage> {
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

  @override
  void initState() {
    handleLocalLanguage();
    super.initState();
  }

  handleLocalLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tempValue = prefs.getString('language');
    var langParse = int.parse('$tempValue');
    updateLanguage(locale[langParse]['locale']);
  }

  onBackPressed() {
    Navigator.pop(context, true);
  }

  Future onLogin(email) async {
    Utils.returnScreenLoader(context);
    http.Response response;
    // http.get("url")
    // Map map = {"email": "praveen.vangala@whizzard.in"};
    Map map = {"email": email};
    var body = json.encode(map);

    response = await http.post(Uri.parse(BASE_URL + GET_OTP),
        headers: {"Content-Type": "application/json"}, body: body);
    stringResponse = response.body;
    mapResponse = json.decode(response.body);
    print('login response ${response.body}');
    if (response.statusCode == 200) {
      Navigator.pop(context);
      _showSnackBar(mapResponse['message'], context, mapResponse['success']);
      if (mapResponse["success"]) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('loggedEmail', email);
        FocusScope.of(context).unfocus();
        Navigator.pushNamed(context, '/otpPage', arguments: {}).then((_) {
          // This block runs when you have returned back to the 1st Page from 2nd.
          setState(() {
            // Call setState to refresh the page.
          });
        });
      }
    } else {
      _showSnackBar(mapResponse['message'], context, false);
      Navigator.pop(context);
    }
  }

  // onLogin() {
  //   FocusScope.of(context).unfocus();
  //   Navigator.pushNamed(context, '/otpPage', arguments: {}).then((_) {
  //     // This block runs when you have returned back to the 1st Page from 2nd.
  //     setState(() {
  //       // Call setState to refresh the page.
  //     });
  //   });
  // }

  // onSignIn() {
  //   Navigator.pushNamed(context, '/loginPage', arguments: {}).then((_) {
  //     // This block runs when you have returned back to the 1st Page from 2nd.
  //     setState(() {
  //       // Call setState to refresh the page.
  //     });
  //   });
  // }

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
                                  children: [],
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
                                  'Login',
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
                                  'Login using mobile',
                                  style: TextStyle(
                                    fontFamily: ffGRegular,
                                    color: subTitleColor,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.02,
                                  left: MediaQuery.of(context).size.width * 0.1,
                                  right:
                                      MediaQuery.of(context).size.width * 0.1),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 1,
                                      color: border,
                                      style: BorderStyle.solid)),
                              child: TextField(
                                // controller: userController,
                                decoration: const InputDecoration(
                                    labelText: 'Enter Email Address',
                                    labelStyle: TextStyle(
                                        fontFamily: ffGMedium,
                                        fontSize: 15.0,
                                        color: placeHolderColor),
                                    // hintText: 'Sample@email.com',
                                    // hintStyle: TextStyle(
                                    //     fontFamily: ffGMedium,
                                    //     fontSize: 15.0,
                                    //     color: placeHolderColor),
                                    contentPadding: EdgeInsets.all(15),
                                    border: InputBorder.none),
                                onChanged: (value) {
                                  // _loginRequest.username = value;
                                },
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                print('Reached login button');

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OtpPage()));
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
                              child: Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                    margin: EdgeInsets.only(
                                        top: MediaQuery.of(context).size.width *
                                            0.01,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.1),
                                    child: const Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Not Have an account with us?',
                                        style: TextStyle(
                                          fontFamily: 'Helvetica',
                                          color: appColor,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                    margin: EdgeInsets.only(
                                        top: MediaQuery.of(context).size.width *
                                            0.01),
                                    child: InkWell(
                                        onTap: () {
                                          // onSignIn();
                                        },
                                        child: const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Sign Up',
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontFamily: 'Helvetica',
                                              color: black,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ))),
              ),
            )));
  }
}
