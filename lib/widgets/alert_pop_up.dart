import 'package:flutter/material.dart';
import 'package:contact_reader/constant.dart';

import 'text_style.dart';

class AlertPopUp extends StatelessWidget {
  final String? titleAlert;
  final String? contentAlert;
  final VoidCallback? onClosed;

  const AlertPopUp({
    super.key,
    this.titleAlert,
    this.contentAlert,
    this.onClosed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(titleAlert ?? '', textAlign: TextAlign.center, style: labelTextStyle(bold: true, color: blackColor, size: 18, spacing: 1.1)),
          titleAlert == '' ? emptySizeBox : normalGap,
          Text(contentAlert ?? '', textAlign: TextAlign.center, style: labelTextStyle(bold: false, color: blackColor, size: 15, spacing: 1)),
          gapBetweenDifferentField,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: const Text('OK', style: TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.of(context).pop();
                  onClosed?.call();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
