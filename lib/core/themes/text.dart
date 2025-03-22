import 'package:flutter/material.dart' show FontWeight, TextStyle;
import 'package:parlo/core/themes/color.dart';

class TextStyleManger {
  static const white32Regular = TextStyle(
    color: ColorsManager.white,
    fontSize: 32,
    fontWeight: FontWeight.normal,
  );

  static const white16Regular = TextStyle(
    color: ColorsManager.white,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const white16Medium = TextStyle(
    color: ColorsManager.white,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const dimmed16Regular = TextStyle(
    color: ColorsManager.dimmedText,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const dimmed14Regular = TextStyle(
    color: ColorsManager.dimmedText,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const dimmed14Medium = TextStyle(
    color: ColorsManager.dimmedText,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const primary14Regular = TextStyle(
    color: ColorsManager.primary,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const primary14Bold = TextStyle(
    color: ColorsManager.primary,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  TextStyleManger._();
}
