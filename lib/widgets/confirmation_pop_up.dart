import 'package:flutter/material.dart';
import 'package:contact_reader/constant.dart';

import 'text_style.dart';

class ConfirmationPopUp extends StatelessWidget {
  final String? titleAlert;
  final String? contentAlert;
  final VoidCallback? onConfirm;
  final VoidCallback? onClosed;

  const ConfirmationPopUp({
    super.key,
    this.titleAlert,
    this.contentAlert,
    this.onConfirm,
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                child: const Text('Yes', style: TextStyle(color: Colors.red, fontSize: 20)),
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm?.call();
                },
              ),
              TextButton(
                child: const Text('No', style: TextStyle(fontSize: 20)),
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
