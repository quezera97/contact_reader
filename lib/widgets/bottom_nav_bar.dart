import 'package:flutter/material.dart';

import '../constant.dart';

Widget bottomNavBar(BuildContext context) {
  return BottomAppBar(
    height: 35,
    shape: const CircularNotchedRectangle(),
    color: mainColor,
    child: IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      child: const Row(
        children: <Widget>[
          emptySizeBox,
        ],
      ),
    ),
  );
}
