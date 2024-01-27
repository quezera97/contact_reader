import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

//padding
const mainScreenPadding = EdgeInsets.all(15.0);

//color
const mainColor = Color.fromARGB(255, 10, 188, 170);
const whiteColor = Colors.white;
const blackColor = Colors.black;

//field
const normalGap = Gap(10);
const gapBetweenField = Gap(25);
const gapBetweenDifferentField = Gap(30);
const heightOfField = 50.0;
const emptySizeBox = SizedBox(height: 0, width: 0);

//check email
bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegex.hasMatch(email);
}
