import 'package:centro_partner/core/constants/enum/days_enum.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_check_box.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_container_info_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/widgets/custom_drop_down.dart';
import 'package:centro_partner/core/ui/widgets/custom_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourtCreateWorkdayScreen extends StatefulWidget {

  bool? isEdit;

  CourtCreateWorkdayScreen({super.key,this.isEdit = false});

  @override
  State<CourtCreateWorkdayScreen> createState() => _CourtCreateWorkdayScreenState();
}

class _CourtCreateWorkdayScreenState extends State<CourtCreateWorkdayScreen> {

  bool isAvailable = true;
  DaysEnum? selectDay;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;
  String selectSlot = "";
  // todo remove later
  List<String> slotsList = [
    "10 minutes",
    "20 minutes",
    "30 minutes",
    "40 minutes",
    "50 minutes",
    "60 minutes",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: CustomHeader(
          title: "",
          isNavBar: false,
          leading: IconButton(
            icon: Icon(Icons.close),
            color: AppColors.blackColor,
            onPressed: () {
              Navigation.pop();
            },
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Text(AppLocalization.of(context).translate("save"),
                      style: AppTheme.titleSmall.copyWith(color: AppColors.primaryColor)),
                ],
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                CustomDropDown(
                  width: 1.sw,
                  height: 56.h,
                  text: AppLocalization.of(context).translate("day"),
                  value: selectDay,
                  onChanged: (newValue) {
                    setState(() {
                      selectDay = newValue as DaysEnum;
                    });
                  },
                  items: DaysEnum.values.map((DaysEnum value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Text(AppLocalization.of(context).translate(value.name), style: AppTheme.labelMedium),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20.h),
                InkWell(
                  onTap: () async {
                    TimeOfDay? selected = await selectTime(context, null);
                    if (selected != null) {
                      setState(() {
                        fromTime = selected;
                      });
                    }
                  },
                  child: CustomContainerInfoWidget(
                    title: fromTime == null ? AppLocalization.of(context).translate("from_time") :
                    fromTime!.format(context).toString(),
                    textStyle: AppTheme.labelMedium.copyWith(color: fromTime == null ?
                    AppColors.grayColor : AppColors.blackColor),
                  ),
                ),
                SizedBox(height: 20.h),
                InkWell(
                  onTap: () async {
                    TimeOfDay? selected = await selectTime(context, null);
                    if (selected != null) {
                      setState(() {
                        toTime = selected;
                      });
                    }
                  },
                  child: CustomContainerInfoWidget(
                    title: toTime == null ? AppLocalization.of(context).translate("to_time") :
                    toTime!.format(context).toString(),
                    textStyle: AppTheme.labelMedium.copyWith(color: toTime == null ?
                    AppColors.grayColor : AppColors.blackColor),
                  ),
                ),
                SizedBox(height: 20.h),
                CustomDropDown(
                  width: 1.sw,
                  height: 56.h,
                  text: AppLocalization.of(context).translate("duration"),
                  value: selectSlot.isEmpty ? null : selectSlot,
                  onChanged: (newValue) {
                    setState(() {
                      selectSlot = newValue;
                    });
                  },
                  items: slotsList.map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Text(value, style: AppTheme.labelMedium),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20.h),
                if(widget.isEdit == false)
                  CustomCheckBox(
                    check: isAvailable,
                    text: AppLocalization.of(context).translate("activate"),
                    onChanged: (value) {
                      isAvailable = !isAvailable;
                      setState(() {});
                    },
                  ),
                SizedBox(height: 50.h),
              ],
            ),
          ),
        )
    );
  }
}
