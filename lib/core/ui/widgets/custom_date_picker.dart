import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<dynamic> customDatePicker( BuildContext context, {int? allowedWeekday}) async {
  DateTime now = DateTime.now();
  DateTime initialDate = now;
  if (allowedWeekday != null && now.weekday != allowedWeekday) {
    int daysUntilNext = (allowedWeekday - now.weekday) % 7;
    if (daysUntilNext <= 0) daysUntilNext += 7;
    initialDate = now.add(Duration(days: daysUntilNext));
  }
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),

    selectableDayPredicate: allowedWeekday != null
        ? (DateTime day) => day.weekday == allowedWeekday
        : (DateTime day) => true,
    builder: (context, child) {
      return Theme(
        data: ThemeData(
          datePickerTheme: DatePickerThemeData(
            headerBackgroundColor: AppColors.primaryColor,
            headerForegroundColor: AppColors.whiteColor,
            backgroundColor: AppColors.whiteColor,
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
      );
    },
  );
}

Future<DateTime?> selectDate(BuildContext context, DateTime? date,{int? allowedWeekday}) async {
  DateTime? picked = await customDatePicker(context,allowedWeekday: allowedWeekday);
  if (picked != null && picked != date) {
    date = picked;
  }
  return date;
}
