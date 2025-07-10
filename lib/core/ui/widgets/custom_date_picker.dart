import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<dynamic> customDatePicker(BuildContext context, {bool isDateOfBirth = false}) async {
  return showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: isDateOfBirth ? DateTime.now() : DateTime(1900),
    lastDate: isDateOfBirth ? DateTime( DateTime.now().year,12,31) : DateTime.now(),
    builder: (context, child) {
      return Theme(
        data: ThemeData(
          useMaterial3: false,
          datePickerTheme: DatePickerThemeData(
            headerBackgroundColor: AppColors.primaryColor,
            headerForegroundColor: AppColors.whiteColor,
            backgroundColor: AppColors.whiteColor,
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
              foregroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
                return AppColors.primaryColor;
              }),
            ),
          ),
        ),
        child: child!,
      );
    },
  );
}

Future<DateTime?> selectDate(BuildContext context, DateTime? date,{bool isDateOfBirth = false}) async {
  DateTime? picked = await customDatePicker(context,isDateOfBirth: isDateOfBirth);
  if (picked != null && picked != date) {
    date = picked;
  }
  return date;
}
