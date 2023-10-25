// FilterTextButtons
import 'package:flutter/material.dart';

import 'Colors.dart';
import 'Fonts.dart';

class FilterTextButtons extends StatelessWidget {
  // final String child;
  final String buttonText;
  final String filterValue;

  FilterTextButtons({required this.buttonText, required this.filterValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.01,
          left: MediaQuery.of(context).size.width * 0.015),
      child: Chip(
        // avatar: CircleAvatar(
        //   backgroundColor: filterValue == buttonText ? appColor : white,
        //   // child: const Text('AB'),
        // ),

        backgroundColor: filterValue == buttonText ? appColor : white,
        // elevation: 6.0,
        // shadowColor: appColor,
        padding: EdgeInsets.all(8.0),
        shape: StadiumBorder(
            side: BorderSide(
          width: 1,
          color: Colors.redAccent,
        )),

        label: Text(
          buttonText,
          style: TextStyle(
            fontFamily: ffGBold,
            color: filterValue == buttonText ? white : appColor,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}
