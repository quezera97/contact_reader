import 'package:flutter/material.dart';
import 'package:contact_reader/constant.dart';

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
          Text(contentAlert ?? '', style: titleTextStyle, textAlign: TextAlign.center),
          gapBetweenDifferentField,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                child: const Text('Yes', style: TextStyle(color: Colors.red, fontSize: 20)),
                onPressed: () {
                  onConfirm?.call();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('No', style: TextStyle(fontSize: 20)),
                onPressed: () {
                  onClosed?.call();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}