import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mybus_mobile/screens/authentication/LoginPage.dart';
import 'package:mybus_mobile/screens/authentication/OtpPage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

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

  String stringResponse = '';
  Map mapResponse = {};
  late var names = [];
  late var totalList = [];
  late var searchData = [];

  @override
  void initState() {
    checkToken();
    super.initState();
  }

  checkToken() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var authtoken = prefs.getString('authtoken');
    // if (authtoken != null) {
    //   // print('token true');
    //   // Timer(
    //   //     const Duration(milliseconds: 500),
    //   //     () => Navigator.pushReplacement(context,
    //   //         MaterialPageRoute(builder: (context) => const HomePage())));

    //   // Navigator.pushReplacement(
    //   //     context, MaterialPageRoute(builder: (context) => const HomePage()));
    // } else {
    //   // print('token false');
    //   // Timer(s
    //   //     const Duration(milliseconds: 500),
    //   //     () => Navigator.pushReplacement(context,
    //   //         MaterialPageRoute(builder: (context) => const DashboardPage())));

    //   // Navigator.pushReplacement(context,
    //   //     MaterialPageRoute(builder: (context) => const DashboardPage()));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.red,
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 1,
                child: Center(
                    child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.3),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.6,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/logo.png'),
                              fit: BoxFit.fill)),
                    ),
                  ],
                )),
              ),
            )));
  }
}
