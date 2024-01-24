import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constant.dart';

class ToastHelper {
  static bool isShowingToast = false;

  static void showToast({
    required String message,
    Toast toastLength = Toast.LENGTH_LONG,
    ToastGravity gravity = ToastGravity.TOP_RIGHT,
    int timeInSecForIosWeb = 1,
    Color backgroundColor = mainColor,
    Color textColor = Colors.white,
    double fontSize = 16.0,
  }) {
    if (isShowingToast) {
      Fluttertoast.cancel();
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: timeInSecForIosWeb,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );

    isShowingToast = true;

    Timer(Duration(seconds: timeInSecForIosWeb), () {
      isShowingToast = false;
    });
  }
}

