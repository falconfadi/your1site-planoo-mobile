import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';

class CustomTimePicker extends StatefulWidget {

  final Function(TimeOfDay) onTimeChanged;
  final TimeOfDay? initialTime;

  const CustomTimePicker({super.key, required this.onTimeChanged, this.initialTime});

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {

  late DateTime _time;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _time = DateTime(now.year, now.month, now.day,
      widget.initialTime?.hour ?? now.hour,
      widget.initialTime?.minute ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TimePickerSpinner(
      time: _time,
      is24HourMode: true,
      minutesInterval: 30,
      spacing: 30,
      itemHeight: 50,
      normalTextStyle: AppTheme.bodyLarge.copyWith(fontSize: 18.sp),
      highlightedTextStyle: AppTheme.headlineMedium.copyWith(color: AppColors.primaryColor),
      onTimeChange: (time) {
        setState(() => _time = time);
        widget.onTimeChanged(
          TimeOfDay(hour: time.hour, minute: time.minute),
        );
      },
    );
  }
}

Future<void> showCustomTimePicker({
  required BuildContext context,
  required Function(String) onSaved,
  required String buttonLabel,
  TimeOfDay? initialTime,
}) async {
  TimeOfDay? selectedTime = initialTime;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTimePicker(
              initialTime: initialTime,
              onTimeChanged: (time) => selectedTime = time,
            ),
            SizedBox(height: 20.h),
            CustomButton(
              height: 45.h,
              borderRadius: 10.r,
              backgroundColor: AppColors.primaryColor,
              buttonName: AppLocalization.of(context).translate(buttonLabel),
              function: () {
                if (selectedTime != null) {
                  final formatted =
                      "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";
                  onSaved(formatted);
                }
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      );
    },
  );
}

