import 'package:flutter/material.dart';

import '../constant.dart';

class ButtonWidget {
  Widget roundedButtonWidget(String textButton, width, VoidCallback functionCallBack) {
    return SizedBox(
      width: width,
      height: heightOfField,
      child: ElevatedButton(
        onPressed: functionCallBack,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          backgroundColor: mainColor,
        ),
        child: Text(
          textButton,
          style: const TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget normalButtonWidget(String textButton, Color color, bool isSolid, VoidCallback functionCallBack) {
    return SizedBox(
      child: ElevatedButton(
        onPressed: functionCallBack,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSolid ? color : Colors.transparent,
          side: BorderSide(color: color), // Set border color
        ),
        child: Text(
          textButton,
          style: const TextStyle(
            color:Colors.white, // Set text color
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}