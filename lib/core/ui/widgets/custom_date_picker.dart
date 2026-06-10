import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<DateTime?> customDatePicker(BuildContext context, {bool disablePastDates = false}) async {
  final now = DateTime.now();
  final today = DateTime(
    now.year,
    now.month,
    now.day,
  );
  return await showDatePicker(
    context: context,
    initialDate: today,
    firstDate: disablePastDates ? today : DateTime(1900),
    lastDate: DateTime(2100),
    builder: (context, child) {
      final isTablet = Responsive.isTablet(context);
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
        child: Transform.scale(
            scale: isTablet ? 1.4 : 1,
            child: child!
        ),
      );
    },
  );
}

Future<DateTime?> selectDate(BuildContext context, DateTime? date,{bool disablePastDates = false}) async {
  final pickedDate = await customDatePicker(context, disablePastDates: disablePastDates);
  if (pickedDate != null && pickedDate != date) {
    date = pickedDate;
  }
  return date;
}
