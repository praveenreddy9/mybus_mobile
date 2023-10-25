import 'package:flutter/material.dart';

import 'Colors.dart';
import 'Fonts.dart';

class NextButton extends StatelessWidget {
  // final String child;
  final String buttonText;

  NextButton({required this.buttonText});

  @override
  Widget build(BuildContext context) {
    var setColorStart = buttonText == 'Back' || buttonText == 'Confirm'
        ? checkStatusEndColor
        : reportIncidentStartColor;
    var setColorEnd = buttonText == 'Back' || buttonText == 'Confirm'
        ? checkStatusEndColor
        : reportIncidentEndColor;
    return Container(
      // shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(15)),
      //     side: BorderSide(width: 0, color: white)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          gradient: LinearGradient(
            colors: [
              setColorStart,
              setColorEnd,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.width * 0.479,
        child: Text(
          buttonText,
          style: const TextStyle(
            fontFamily: ffGSemiBold,
            fontSize: 20.0,
            color: white,
          ),
        ),
      ),
    );
  }
}
