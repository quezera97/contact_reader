import 'package:flutter/material.dart';

import '../constant.dart';

Widget fabWidget(BuildContext context, Widget destinationRoute) {
  return FloatingActionButton(
    onPressed: () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => destinationRoute));
    },
    shape: const CircleBorder(),
    foregroundColor: whiteColor,
    backgroundColor: mainColor,
    child: const Icon(Icons.add),
  );
}
