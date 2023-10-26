import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/services/config.dart';
import '/utility/Colors.dart';
import '/utility/Fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import '/utility/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utility/ContinueButton.dart';

class ImagesUpload extends StatefulWidget {
  const ImagesUpload({Key? key}) : super(key: key);

  @override
  State<ImagesUpload> createState() => _ImagesUploadState();
}

class _ImagesUploadState extends State<ImagesUpload> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List _incidentRequest = [];

  var imageFile;

  String selectedImageOption = '';

  var _firstImage;
  var _secondImage;
  var _thirdImage;

  var fullImageURL;

  var jsonResponse;
  Map mapResponse = {};
  late var names = [];
  late var totalList = [];
  late var searchData = [];

  var imageRespPath;

  String screensCount = '';
  int currentScreenCount = 0;

  @override
  void initState() {
    fetchLocalStorageDate();
    super.initState();
  }

  onBackPressed() {
    // Navigator.pop(context, true);
    Utils.returnHomeNavigation(context);
  }

  void _showSnackBar(String message, BuildContext context, ColorCheck) {
    final snackBar = SnackBar(
        content: Text(message),
        backgroundColor: ColorCheck ? Colors.green : Colors.red,
        duration: Utils.returnToastDuration());

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  fetchLocalStorageDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    screensCount = prefs.getString('screensCount')!;
    var tempScreenValue = prefs.getInt('currentScreenCount')!;
    currentScreenCount = tempScreenValue + 1;
    setState(() {
      screensCount;
      currentScreenCount;
    });
  }

  onNext() async {
    Navigator.pushNamed(context, '/HomePage', arguments: _incidentRequest)
        .then((_) {
      // This block runs when you have returned back to the 1st Page from 2nd.
      setState(() {
        // Call setState to refresh the page.
      });
    });
  }

  onHome() {
    Utils.returnHomeNavigation(context);
  }

  /// Get from gallery
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    // PickedFile pickedFile = await ImagePicker().getImage(
    //   ource: ImageSource.gallery,
    // );
    if (pickedFile != null) {
      // print('imageFile===>$imageFile');
      // print(imageFile["File"]);
      // print('pickedFile in gallery============= > ${pickedFile.path}');

      imageFile = pickedFile.path;
      imageUpload(imageFile);

      // setState(() {
      //   if (selectedImageOption == 'firstUpload') {
      //     _firstImage = File(pickedFile.path);
      //     imageFile = pickedFile.path;
      //     imageUpload(imageFile);
      //   } else if (selectedImageOption == 'secondUpload') {
      //     _secondImage = File(pickedFile.path);
      //   } else if (selectedImageOption == 'thirdUpload') {
      //     _thirdImage = File(pickedFile.path);
      //   }
      // });

      // onBackPressed();
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    // print('pickedFile in camera============= $pickedFile');
    if (pickedFile != null) {
      imageFile = pickedFile.path;
      // onBackPressed();
      imageUpload(imageFile);

      // print('imageFile===>$imageFile');
      // print(imageFile["File"]);
      // print('pickedFile in gallery============= > ${pickedFile.path}');
    }
  }

  Future imageUpload(imagePath) async {
    Utils.returnScreenLoader(context);
    final dio = Dio();

    var objToSend = {
      "image": await MultipartFile.fromFile(imagePath.toString(),
          filename: imagePath.toString(),
          contentType: new MediaType('image', 'jpg')),
    };
    FormData formData = FormData.fromMap(objToSend);

    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Accept": "application/json",
    };

    var url = BASE_URL + UPLOAD_IMAGES;

    Response response =
        await dio.post(url, options: Options(headers: headers), data: formData);

    if (response.statusCode == 200) {
      Navigator.pop(context);
      jsonResponse = response.data;
      // print(jsonResponse['success']);
      // print(jsonResponse['message']);
      // print(jsonResponse['path']);
      if (jsonResponse['success']) {
        imageRespPath = jsonResponse['path'];
        setState(() {
          if (selectedImageOption == 'firstUpload') {
            _firstImage = imageRespPath;
          } else if (selectedImageOption == 'secondUpload') {
            _secondImage = imageRespPath;
          } else if (selectedImageOption == 'thirdUpload') {
            _thirdImage = imageRespPath;
          }
        });
      }
      // onBackPressed();
      _showSnackBar(jsonResponse['message'], context, jsonResponse['success']);
    } else {
      _showSnackBar(response.data, context, false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: white,
        body: Stack(children: [
          Positioned(
              child: Form(
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
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.06,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04,
                                              decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/back.png'),
                                                      fit: BoxFit.fill)),
                                            ),
                                          ),
                                        ],
                                      )),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: MediaQuery.of(context).size.width *
                                            0.1,
                                        bottom:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.1),
                                    child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Upload',
                                        style: TextStyle(
                                          fontFamily: ffGSemiBold,
                                          color: titleColor,
                                          fontSize: 40.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(20),
                                    child: Card(
                                      elevation: 10,
                                      color: white,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          side: BorderSide(
                                              width: 1, color: appColor)),
                                      child: Container(
                                        alignment: Alignment.center,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            const Text(
                                              "PAN Upload",
                                              style: TextStyle(
                                                fontFamily: ffGMedium,
                                                fontSize: 18.0,
                                                color: black,
                                              ),
                                            ),
                                            //upload-1
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1),
                                              child: _firstImage != null
                                                  ? Container(
                                                      child: Stack(
                                                      children: <Widget>[
                                                        Image.network(
                                                          _firstImage,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.38,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.2,
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                        Positioned(
                                                          top: 40,
                                                          right: 50,
                                                          child: InkWell(
                                                              onTap: () {
                                                                deleteOption(
                                                                    _firstImage);
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(6),
                                                                color: Colors
                                                                    .white,
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/delete.png',
                                                                  height: 30,
                                                                  width: 30,
                                                                ),
                                                              )),
                                                        ),
                                                        Positioned(
                                                          top: 90,
                                                          right: 50,
                                                          child: InkWell(
                                                              onTap: () {
                                                                imageFullView(
                                                                    _firstImage);
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(6),
                                                                color: Colors
                                                                    .white,
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/view.png',
                                                                  height: 30,
                                                                  width: 30,
                                                                ),
                                                              )),
                                                        )
                                                      ],
                                                    ))
                                                  : InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedImageOption =
                                                              'firstUpload';
                                                        });
                                                        uploadOption();
                                                      },
                                                      child: DottedBorder(
                                                          dashPattern: [6, 8],
                                                          color: Color.fromRGBO(
                                                              163, 163, 163, 1),
                                                          child: Container(
                                                            color:
                                                                uploadBgColor,
                                                            alignment: Alignment
                                                                .center,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.38,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.2,
                                                            child: Container(
                                                              margin: EdgeInsets.only(
                                                                  left: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0),
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.1,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.1,
                                                              decoration: const BoxDecoration(
                                                                  image: DecorationImage(
                                                                      image: AssetImage(
                                                                          'assets/images/add.png'),
                                                                      fit: BoxFit
                                                                          .fill)),
                                                            ),
                                                          )),
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(20),
                                    child: Card(
                                      elevation: 10,
                                      color: white,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          side: BorderSide(
                                              width: 1, color: appColor)),
                                      child: Container(
                                        alignment: Alignment.center,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Aadhar Upload",
                                              style: TextStyle(
                                                fontFamily: ffGMedium,
                                                fontSize: 18.0,
                                                color: black,
                                              ),
                                            ),
                                            //upload-1
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1),
                                              child: _secondImage != null
                                                  ? Container(
                                                      child: Stack(
                                                      children: <Widget>[
                                                        Image.network(
                                                          _firstImage,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.38,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.2,
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                        Positioned(
                                                          top: 40,
                                                          right: 50,
                                                          child: InkWell(
                                                              onTap: () {
                                                                deleteOption(
                                                                    _secondImage);
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(6),
                                                                color: Colors
                                                                    .white,
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/delete.png',
                                                                  height: 30,
                                                                  width: 30,
                                                                ),
                                                              )),
                                                        ),
                                                        Positioned(
                                                          top: 90,
                                                          right: 50,
                                                          child: InkWell(
                                                              onTap: () {
                                                                imageFullView(
                                                                    _secondImage);
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(6),
                                                                color: Colors
                                                                    .white,
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/view.png',
                                                                  height: 30,
                                                                  width: 30,
                                                                ),
                                                              )),
                                                        )
                                                      ],
                                                    ))
                                                  : InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedImageOption =
                                                              'secondUpload';
                                                        });
                                                        uploadOption();
                                                      },
                                                      child: DottedBorder(
                                                          dashPattern: [6, 8],
                                                          color: Color.fromRGBO(
                                                              163, 163, 163, 1),
                                                          child: Container(
                                                            color:
                                                                uploadBgColor,
                                                            alignment: Alignment
                                                                .center,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.38,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.2,
                                                            child: Container(
                                                              margin: EdgeInsets.only(
                                                                  left: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0),
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.1,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.1,
                                                              decoration: const BoxDecoration(
                                                                  image: DecorationImage(
                                                                      image: AssetImage(
                                                                          'assets/images/add.png'),
                                                                      fit: BoxFit
                                                                          .fill)),
                                                            ),
                                                          )),
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
                  ))),
        ]));
  }

  void uploadOption() {
    showCupertinoModalPopup(
        context: context,
        barrierColor: modalBgDisableColor,
        builder: (BuildContext cont) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.9,

            // color: Colors.white,
            child: CupertinoActionSheet(
              actions: [
                Container(
                  decoration: BoxDecoration(color: white),
                  child: CupertinoActionSheetAction(
                    onPressed: () {},
                    child: Text(
                      'Please select option for upload',
                      style: TextStyle(color: Color.fromRGBO(26, 26, 26, 1)),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: white),
                  child: CupertinoActionSheetAction(
                    onPressed: () {
                      _getFromCamera();
                      onBackPressed();
                    },
                    child: Text('Take a photo',
                        style: TextStyle(color: Color.fromRGBO(26, 26, 26, 1))),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: white),
                  child: CupertinoActionSheetAction(
                    onPressed: () {
                      _getFromGallery();
                      onBackPressed();
                    },
                    child: Text('Choose from Library',
                        style: TextStyle(color: Color.fromRGBO(26, 26, 26, 1))),
                  ),
                ),
              ],
              cancelButton: Container(
                decoration: BoxDecoration(
                  color: appColor,
                  borderRadius: BorderRadius.circular(7.0),
                  boxShadow: [
                    BoxShadow(
                      color: appColor,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: CupertinoActionSheetAction(
                  onPressed: () {
                    onBackPressed();
                  },
                  child: Text('Cancel', style: TextStyle(color: white)),
                ),
              ),
            ),
          );
        });
  }

  void imageFullView(ImageData) {
    showCupertinoModalPopup(
        context: context,
        barrierColor: modalBgDisableColor,
        builder: (BuildContext cont) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.9,

            // color: Colors.white,
            child: CupertinoActionSheet(
              actions: [
                Container(
                  child: Container(
                    padding: EdgeInsets.all(6),
                    color: Colors.white,
                    child: Image.network(
                      ImageData,
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.6,
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              ],
              cancelButton: Container(
                decoration: BoxDecoration(
                  color: appColor,
                  borderRadius: BorderRadius.circular(7.0),
                  boxShadow: [
                    BoxShadow(
                      color: appColor,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: CupertinoActionSheetAction(
                  onPressed: () {
                    onBackPressed();
                  },
                  child: Text('Cancel', style: TextStyle(color: white)),
                ),
              ),
            ),
          );
        });
  }

  void deleteOption(imageURL) {
    showCupertinoModalPopup(
        context: context,
        barrierColor: modalBgDisableColor,
        builder: (BuildContext cont) {
          return CupertinoActionSheet(
            actions: [
              Container(
                decoration: BoxDecoration(color: white),
                child: CupertinoActionSheetAction(
                  onPressed: () {},
                  child: Text('Are you sure you want to delete the file?',
                      style: TextStyle(color: black)),
                ),
              ),
              Container(
                decoration: BoxDecoration(color: white),
                child: CupertinoActionSheetAction(
                  onPressed: () {
                    setState(() {
                      if (imageURL == _firstImage) {
                        _firstImage = null;
                      } else if (imageURL == _secondImage) {
                        _secondImage = null;
                      } else if (imageURL == _thirdImage) {
                        _thirdImage = null;
                      }
                    });
                    onBackPressed();
                  },
                  child: Text('Yes', style: TextStyle(color: black)),
                ),
              ),
              Container(
                decoration: BoxDecoration(color: white),
                child: CupertinoActionSheetAction(
                  onPressed: () {
                    onBackPressed();
                  },
                  child: Text('No', style: TextStyle(color: black)),
                ),
              ),
            ],
            cancelButton: Container(
              decoration: BoxDecoration(
                color: appColor,
                borderRadius: BorderRadius.circular(7.0),
                boxShadow: [
                  BoxShadow(
                    color: appColor,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: CupertinoActionSheetAction(
                onPressed: () {
                  onBackPressed();
                },
                child: Text('Cancel', style: TextStyle(color: white)),
              ),
            ),
          );
        });
  }

  void showCustomDialog(BuildContext context, String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: modalBgDisableColor,
      builder: (BuildContext cxt) {
        return Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Material(
              color: white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        onBackPressed();
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.6),
                        width: MediaQuery.of(context).size.width * 0.05,
                        height: MediaQuery.of(context).size.width * 0.05,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/cancel.png'),
                                fit: BoxFit.fill)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02,
                          left: MediaQuery.of(context).size.width * 0.02,
                          right: MediaQuery.of(context).size.width * 0.02),
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Oops… seems like you have\nselected a future date',
                          style: TextStyle(
                            color: black,
                            fontSize: 15.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        onBackPressed();
                      },
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Try again',
                          style: TextStyle(
                            color: black,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
