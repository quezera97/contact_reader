import 'dart:io';

import 'package:flutter/widgets.dart';

Widget getImageWidget(imageUrl, [double? heightImage, double? widthImage]) {
  if (imageUrl != null) {
    if (imageUrl is String && (imageUrl.startsWith('https://') || imageUrl.startsWith('http://'))) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        height: heightImage ?? 100,
        width: widthImage ?? 100,
      );
    } else if (imageUrl is String && (imageUrl.startsWith('/data') || imageUrl.contains('/data/user'))) {
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        height: heightImage ?? 100,
        width: widthImage ?? 100,
      );
    }
  }
  return Image.asset(
    'asset/user.png',
    fit: BoxFit.cover,
    height: heightImage ?? 100,
    width: widthImage ?? 100,
  );
}
