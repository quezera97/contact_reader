import 'package:contact_reader/constant.dart';
import 'package:flutter/material.dart';

import 'text_style.dart';

class LoadingDataState {
  Widget dataIsLoadingState([String? message_1]) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'asset/loading.gif',
          fit: BoxFit.cover,
          height: 100,
        ),
        Text(message_1 ?? '', style: labelTextStyle(bold: false, color: blackColor, size: 15, spacing: 1)),
      ],
    );
  }

  Widget dataIsEmptyState([String? message_1, String? message_2]) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'asset/no_contact.png',
          fit: BoxFit.cover,
          height: 200,
        ),
        Text(message_1 ?? '', style: labelTextStyle(bold: false, color: blackColor, size: 15, spacing: 1)),
        Text(message_2 ?? '', style: labelTextStyle(bold: false, color: blackColor, size: 15, spacing: 1)),
      ],
    );
  }
}
