import 'package:flutter/widgets.dart';

TextStyle labelTextStyle({required Color color, required double size, required double spacing, required bool bold}) {
  return TextStyle(
    color: color,
    fontSize: size,
    letterSpacing: spacing,
    fontWeight: bold == true ? FontWeight.bold : null,
  );
}
