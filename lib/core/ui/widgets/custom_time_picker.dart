import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<TimeOfDay?> customTimePicker(BuildContext context) async {
  return showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (context, child) {
      return Theme(
        data: ThemeData(
          useMaterial3: false,
          timePickerTheme: TimePickerThemeData(
            backgroundColor: AppColors.whiteColor,
            hourMinuteColor: AppColors.primaryColor.withOpacity(0.1),
            hourMinuteTextColor: AppColors.primaryColor,
            dayPeriodColor: AppColors.primaryColor.withOpacity(0.1),
            dayPeriodTextColor: AppColors.primaryColor,
            dialBackgroundColor: AppColors.primaryColor.withOpacity(0.05),
            dialHandColor: AppColors.primaryColor,
            dialTextColor: AppColors.primaryColor,
            entryModeIconColor: AppColors.primaryColor,
            helpTextStyle: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 16.sp,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: AppColors.primaryColor,
            onPrimary: AppColors.whiteColor,
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(AppColors.primaryColor),
            ),
          ),
        ),
        child: child!,
      );
    },
  );
}

Future<TimeOfDay?> selectTime(BuildContext context, TimeOfDay? time) async {
  TimeOfDay? picked = await customTimePicker(context);
  if (picked != null && picked != time) {
    time = picked;
  }
  return time;
}