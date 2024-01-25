import 'dart:async';

import 'package:flutter/material.dart';

import '../constant.dart';
import 'my_contact.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {
  ImageProvider preloadImage = const AssetImage('asset/contact.png');

  @override
  void initState() {
    super.initState();
    _startTime();
  }

  _startTime() async {
    var duration = const Duration(seconds: 4);
    return Timer(duration, routeDashboard);
  }

  routeDashboard() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyContact()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: mainColor,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: preloadImage,
                  width: 100,
                  height: 100,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
