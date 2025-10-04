import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTheme {

  static const String font = 'Tajawal';

  static TextTheme textTheme = TextTheme(
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );

  static TextStyle headlineMedium = TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w800,
    fontSize: 20.sp,
    color: AppColors.blackColor,
  );

  static TextStyle headlineSmall = TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w700,
    fontSize: 18.sp,
    color: AppColors.blackColor,
  );

  static TextStyle titleLarge = TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w700,
    fontSize: 16.sp,
    color: AppColors.blackColor,
  );

  static TextStyle titleMedium = TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w700,
    fontSize: 14.sp,
    color: AppColors.blackColor,
  );

  static TextStyle titleSmall = TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w700,
    fontSize: 12.sp,
    color: AppColors.blackColor,
  );

  static TextStyle bodyLarge = TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w500,
    fontSize: 16.sp,
    color: AppColors.blackColor,
  );

  static TextStyle bodyMedium = TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
    color: AppColors.blackColor,
  );

  static TextStyle bodySmall = TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
    color: AppColors.blackColor,
  );

  static TextStyle labelLarge = TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    color: AppColors.blackColor,
  );

  static TextStyle labelMedium = TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    color: AppColors.blackColor,
  );

  static TextStyle labelSmall = TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w400,
    fontSize: 12.sp,
    color: AppColors.blackColor,
  );
}
