import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/core/ui/shared_widgets/time_picker_widget.dart';

Future<TimeOfDay?> customTimePicker(BuildContext context, {TimeOfDay? timePicker}) async {
  final now = timePicker ?? TimeOfDay.now();
  final roundedInitial = roundToNearestHalfHour(now);

  final picked = await timePickerWidget(
    context: context,
    initialTime: roundedInitial,
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

  if (picked == null) return null;

  return roundToNearestHalfHour(picked);
}

Future<TimeOfDay?> selectTime(BuildContext context, TimeOfDay? time) async {
  final picked = await customTimePicker(context, timePicker: time);
  if (picked != null && picked != time) {
    time = picked;
  }
  return time;
}
