import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<dynamic> customDatePicker(BuildContext context) async {
  return showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
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

Future<DateTime?> selectDate(BuildContext context, DateTime? date) async {
  DateTime? picked = await customDatePicker(context);
  if (picked != null && picked != date) {
    date = picked;
  }
  return date;
}
