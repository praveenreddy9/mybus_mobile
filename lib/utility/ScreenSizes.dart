import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//AES/CBC/PKCS7Padding

//1234567890123456

class ScreenSizes {
  // var sHeight = WidgetsBinding.instance.window.physicalSize.height;
  // var sWidth = WidgetsBinding.instance.window.physicalSize.width;
  // print('sHeight==== $sHeight');
  // print('sWidth==== $sWidth');

  static returnHeadSize() {
    //HEAD
    var sWidth = WidgetsBinding.instance.window.physicalSize.width;

    if (sWidth == 1290.0 || sWidth == 1284.0) {
      //iPhone 14 Pro Max,iPhone 14 Plus
      return 0.394;
    } else if (sWidth == 1242.0 || sWidth == 828.0) {
      //iPhone XS Max,iPhone XR
      return 0.390;
    } else if (sWidth == 1170.0 || sWidth == 1179.0) {
      //iPhone 14,iPhone 14 Pro
      return 0.381;
    } else if (sWidth == 750.0 || sWidth == 1125.0) {
      //1080 showing as 1125
      //iPhone SE,iPhone 12 mini,iPhone 11 Pro,iPhone 13 mini
      return 0.375;
    } else {
      return 0.381;
    }
  }

  static returnRightHandSize() {
    //RIGHT_HAND
    var sWidth = WidgetsBinding.instance.window.physicalSize.width;

    if (sWidth == 1290.0 || sWidth == 1284.0) {
      //iPhone 14 Pro Max,iPhone 14 Plus
      return 0.283;
    } else if (sWidth == 1242.0 || sWidth == 828.0) {
      //iPhone XS Max,iPhone XR,iPhone 11
      return 0.275;
    } else if (sWidth == 1170.0 || sWidth == 1179.0) {
      //iPhone 14,iPhone 14 Pro
      return 0.255;
    } else if (sWidth == 750.0 || sWidth == 1125.0) {
      //iPhone SE,iPhone 12 mini,iPhone 11 Pro
      return 0.245;
    } else {
      return 0.255;
    }
  }

  static returnLeftHandSize() {
    var sWidth = WidgetsBinding.instance.window.physicalSize.width;

    if (sWidth == 1290.0 || sWidth == 1284.0) {
      //iPhone 14 Pro Max
      return 0.333;
    } else if (sWidth == 1242.0 || sWidth == 828.0) {
      //iPhone XS Max,iPhone XR,iPhone 11
      return 0.33;
    } else if (sWidth == 1170.0 || sWidth == 1179.0) {
      //iPhone 14,iPhone 14 Pro
      return 0.32;
    } else if (sWidth == 750.0 || sWidth == 1125.0) {
      //iPhone SE,iPhone 12 mini,iPhone 11 Pro
      return 0.32;
    } else {
      return 0.32;
    }
  }

  static returnRightLegSize() {
    var sWidth = WidgetsBinding.instance.window.physicalSize.width;

    if (sWidth == 1290.0 || sWidth == 1284.0) {
      //iPhone 14 Pro Max,iPhone 14 Plus
      return 0.382;
    } else if (sWidth == 1242.0 || sWidth == 828.0) {
      //iPhone XS Max,iPhone XR,iPhone 11
      return 0.378;
    } else if (sWidth == 1170.0 || sWidth == 1179.0) {
      //iPhone 14,iPhone 14 Pro
      return 0.365;
    } else if (sWidth == 750.0 || sWidth == 1125.0) {
      //iPhone SE,iPhone 12 mini,iPhone 11 Pro
      return 0.355;
    } else {
      return 0.365;
    }
  }

  static returnOTPBoxesSize() {
    var sWidth = WidgetsBinding.instance.window.physicalSize.width;

    if (sWidth == 1290.0 || sWidth == 1284.0) {
      //iPhone 14 Pro Max,iPhone 14 Plus
      return 70;
    } else if (sWidth == 1242.0 || sWidth == 828.0) {
      //iPhone XS Max,iPhone XR,iPhone 11
      return 73;
    } else if (sWidth == 1170.0 || sWidth == 1179.0) {
      //iPhone 14,iPhone 14 Pro
      return 70;
    } else if (sWidth == 750.0 || sWidth == 1125.0) {
      //iPhone SE,iPhone 12 mini,iPhone 11 Pro
      return 65;
    } else {
      return 70;
    }
  }

  static returnTicketCardHeight() {
    var sHeight = WidgetsBinding.instance.window.physicalSize.height;

    print('sHeight=== $sHeight');

    if (sHeight == 1290.0 || sHeight == 1284.0) {
      //iPhone 14 Pro Max,iPhone 14 Plus
      return 70;
    } else if (sHeight == 1242.0 || sHeight == 828.0) {
      //iPhone XS Max,iPhone XR,iPhone 11
      return 73;
    } else if (sHeight == 1170.0 || sHeight == 1179.0) {
      //iPhone 14,iPhone 14 Pro
      return 70;
    } else if (sHeight == 750.0 || sHeight == 1125.0) {
      //iPhone SE,iPhone 12 mini,iPhone 11 Pro
      return 65;
    } else {
      return 0.6;
    }
  }
}
