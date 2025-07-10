import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/constants/enum/days_enum.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_texts_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/home/ui/court/court_create_workday_screen.dart';
import 'package:centro_partner/features/home/widget/trainer/workday/trainer_workday_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrainerWorkdaysTab extends StatefulWidget {

  TrainerWorkdaysTab({super.key});

  @override
  State<TrainerWorkdaysTab> createState() => _TrainerWorkdaysTabState();
}

class _TrainerWorkdaysTabState extends State<TrainerWorkdaysTab> {

  int openDay = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: CustomTextsWidget(title: "${AppLocalization.of(context).translate("count")}:" , text: "6")),
              CustomButton(
                icon: add,
                iconColor: AppColors.primaryColor,
                width: 10.w,
                height: 20.h,
                backgroundColor: AppColors.whiteColor,
                borderRadius: 0,
                buttonName: null,
                function: () => Navigation.push(CourtCreateWorkdayScreen()),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ExpansionPanelList.radio(
            expandedHeaderPadding: EdgeInsets.zero,
            elevation: 2,
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                openDay = index;
              });
            },
            initialOpenPanelValue: openDay,
            children: DaysEnum.values.asMap().entries.map((entry) {
              int dayIndex = entry.key;
              String dayName = entry.value.name;

              return ExpansionPanelRadio(
                value: dayIndex,
                backgroundColor: AppColors.whiteColor,
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                    title: Text(dayName, style: AppTheme.bodyMedium),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("5", style: AppTheme.bodyMedium.copyWith(color: AppColors.darkGreenColor)),
                      ],
                    ),
                  );
                },
                body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                  child: Column(
                    children: List.generate(5, (index) =>
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: TrainerWorkdayWidget(),
                        ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
