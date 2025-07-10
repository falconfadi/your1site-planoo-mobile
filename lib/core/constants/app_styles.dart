import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {

  static const String font = 'Montserrat';

  static TextTheme textTheme = TextTheme(
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );

  static TextStyle headlineSmall = const TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w800,
    fontSize: 24,
    color: AppColors.blackColor,
  );

  static TextStyle titleLarge = const TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    color: AppColors.blackColor,
  );

  static TextStyle titleMedium = const TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w600,
    fontSize: 18,
    color: AppColors.blackColor,
  );

  static TextStyle titleSmall = const TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: AppColors.blackColor,
  );

  static TextStyle bodyMedium = const TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: AppColors.blackColor,
  );

  static TextStyle bodySmall = const TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    color: AppColors.blackColor,
  );

  static TextStyle labelLarge = const TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: AppColors.blackColor,
  );

  static TextStyle labelMedium = const TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.blackColor,
  );

  static TextStyle labelSmall = const TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: AppColors.blackColor,
  );
}
