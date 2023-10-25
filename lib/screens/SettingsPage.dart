// import 'package:cryptology/cryptology.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mybus_mobile/screens/authentication/LoginPage.dart';
import '/utility/Colors.dart';
import '/utility/Fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  // const OtpPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
    print('stored  lang tempValue====> $tempValue');
  }

  onBackPressed() {
    // Navigator.pop(context, true);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
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
                                  'LANG Selection',
                                  style: TextStyle(
                                    fontFamily: ffGBold,
                                    color: titleColor,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  buildLanguageDialog(context);
                                },
                                child: Text('changelang'.tr)),
                          ],
                        ))),
              ),
            )));
  }
}
