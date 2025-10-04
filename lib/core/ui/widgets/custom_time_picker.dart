import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<TimeOfDay?> customTimePicker(BuildContext context) async {
  return showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: Theme(
          data: ThemeData(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppColors.whiteColor,
              hourMinuteColor: AppColors.lightPinkColor,
              dayPeriodColor: AppColors.lightPurpleColor,
              dialBackgroundColor: AppColors.lightPinkColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.whiteColor,
            ),
          ),
          child: child!,
        ),
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