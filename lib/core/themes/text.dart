import 'package:flutter/material.dart' show FontWeight, TextStyle;
import 'package:parlo/core/themes/color.dart';

class TextStyleManager {
  static const white32Regular = TextStyle(color: ColorsManager.white, fontSize: 32, fontWeight: FontWeight.normal);

  static const white16Regular = TextStyle(color: ColorsManager.white, fontSize: 16, fontWeight: FontWeight.normal);

  static const white16Medium = TextStyle(color: ColorsManager.white, fontSize: 16, fontWeight: FontWeight.w600);

  static const white16Bold = TextStyle(color: ColorsManager.white, fontSize: 16, fontWeight: FontWeight.bold);

  static const white14Bold = TextStyle(color: ColorsManager.white, fontSize: 14, fontWeight: FontWeight.bold);

  static const white12Bold = TextStyle(color: ColorsManager.white, fontSize: 12, fontWeight: FontWeight.bold);

  static const dimmed16Regular = TextStyle(color: ColorsManager.lightGray, fontSize: 16, fontWeight: FontWeight.normal);

  static const dimmed14Regular = TextStyle(color: ColorsManager.lightGray, fontSize: 14, fontWeight: FontWeight.normal);

  static const dimmed12Regular = TextStyle(color: ColorsManager.lightGray, fontSize: 12, fontWeight: FontWeight.normal);

  static const dimmed14Medium = TextStyle(color: ColorsManager.lightGray, fontSize: 14, fontWeight: FontWeight.w500);

  static const primaryPurple14Regular = TextStyle(
    color: ColorsManager.primaryPurple,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const primaryPurple14Bold = TextStyle(
    color: ColorsManager.primaryPurple,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static const error12Regular = TextStyle(color: ColorsManager.red, fontSize: 12, fontWeight: FontWeight.normal);

  TextStyleManager._();
}
