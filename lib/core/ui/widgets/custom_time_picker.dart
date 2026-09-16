import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTimePicker extends StatefulWidget {
  final TimeOfDay? initialTime;
  final TimeOfDay? minTime;
  final Function(TimeOfDay) onChanged;

  const CustomTimePicker({
    super.key,
    required this.onChanged,
    this.initialTime,
    this.minTime,
  });

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {

  late int selectedHour;
  late int selectedMinute;

  final FixedExtentScrollController hourController = FixedExtentScrollController();
  final FixedExtentScrollController minuteController = FixedExtentScrollController();

  @override
  void initState() {
    super.initState();
    selectedHour = widget.initialTime?.hour ?? widget.minTime?.hour ?? 0;
    selectedMinute = widget.initialTime?.minute ?? 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      hourController.jumpToItem(selectedHour);
      minuteController.jumpToItem(selectedMinute ~/ 30);
    });
  }

  bool isValidHour(int hour) {
    if (widget.minTime == null) return true;
    return hour >= widget.minTime!.hour;
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 150.h,
          width: 100.w,
          child: ListWheelScrollView.useDelegate(
            controller: hourController,
            itemExtent: isTablet ? 80 : 50,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              if (!isValidHour(index)) {
                hourController.jumpToItem(widget.minTime!.hour);
                return;
              }
              selectedHour = index;
              widget.onChanged(
                TimeOfDay(hour: selectedHour, minute: selectedMinute),
              );
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: 24,
              builder: (context, index) {
                final disabled = !isValidHour(index);

                return Center(
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: AppTheme.headlineSmall.copyWith(
                      color: disabled ? AppColors.mediumGrayColor : AppColors.blackColor,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Text(":", style: AppTheme.headlineSmall.copyWith(fontSize: 20)),
        SizedBox(
          height: 150.h,
          width: 100.w,
          child: ListWheelScrollView.useDelegate(
            controller: minuteController,
            itemExtent: isTablet ? 80 : 50,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              selectedMinute = index * 30;

              widget.onChanged(
                TimeOfDay(hour: selectedHour, minute: selectedMinute),
              );
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: 2,
              builder: (context, index) {
                final value = index * 30;

                return Center(
                  child: Text(
                    value.toString().padLeft(2, '0'),
                    style: AppTheme.headlineSmall
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> showCustomTimePicker({
  required BuildContext context,
  required String buttonLabel,
  required TimeOfDay? minTime,
  required TimeOfDay? initialTime,
  required Function(TimeOfDay) onSaved,
}) async {
  TimeOfDay selected = initialTime ?? minTime ?? const TimeOfDay(hour: 0, minute: 0);

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
              minTime: minTime,
              onChanged: (t) => selected = t,
            ),
            SizedBox(height: 50.h),
            CustomButton(
              height: 45.h,
              borderRadius: 10.r,
              backgroundColor: AppColors.primaryColor,
              buttonName: AppLocalization.of(context).translate(buttonLabel),
              function: () {
                if (minTime != null) {
                  final sel = selected.hour * 60 + selected.minute;
                  final min = minTime.hour * 60 + minTime.minute;

                  if (sel < min) return;
                }
                onSaved(selected);
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


