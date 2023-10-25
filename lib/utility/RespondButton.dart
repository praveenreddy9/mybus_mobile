import 'package:flutter/material.dart';

import 'Colors.dart';
import 'Fonts.dart';

class RespondButton extends StatelessWidget {
  // final String child;

  // ContinueButton({});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          side: BorderSide(width: 1, color: white)),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
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
        height: MediaQuery.of(context).size.height * 0.1,
        child: const Text(
          "Respond",
          style: TextStyle(
            fontFamily: ffGSemiBold,
            fontSize: 20.0,
            color: white,
          ),
        ),
      ),
    );
  }
}
