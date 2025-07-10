import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/constants/enum/trainer_tabs.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/home/ui/all_media_screen.dart';
import 'package:centro_partner/features/home/ui/trainer/all_trainer_activities_screen.dart';
import 'package:centro_partner/features/home/widget/trainer/trainer_about_tab.dart';
import 'package:centro_partner/features/home/widget/trainer/activity/trainer_activities_tab.dart';
import 'package:centro_partner/features/home/widget/trainer/trainer_media_tab.dart';
import 'package:centro_partner/features/home/widget/trainer/workday/trainer_workdays_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrainerTabsWidget extends StatefulWidget {

  const TrainerTabsWidget({super.key});

  @override
  State<TrainerTabsWidget> createState() => _TrainerTabsWidgetState();
}

class _TrainerTabsWidgetState extends State<TrainerTabsWidget> {

  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                color: AppColors.grayColor,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: TrainerTabs.values.length,
            itemBuilder: (context, index) {
              final tab = TrainerTabs.values[index];
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedTab = index;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 25.w),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: selectedTab == index ?
                      AppColors.blackColor : Colors.transparent),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(AppLocalization.of(context).translate(tab.name),style: AppTheme.labelLarge.copyWith(color: selectedTab == index ?
                      AppColors.darkGrayColor : AppColors.mediumGrayColor))
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 25.h),
        selectedTab == 0 ? Container() : // todo
        selectedTab == 1 ? Container() : // todo
        selectedTab == 2 ? TrainerActivitiesTab() :
        selectedTab == 3 ? TrainerWorkdaysTab() :
        selectedTab == 4 ? TrainerMediaTab() : TrainerAboutTab(),
        SizedBox(height: selectedTab == 4 ? 30.h : 0),
        if(selectedTab != 3 && selectedTab != 5)
          SizedBox(
            width: 100.w,
            height: 40.h,
            child: CustomButton(
              backgroundColor: AppColors.whiteColor,
              borderRadius: 10.r,
              textStyle: AppTheme.titleSmall.copyWith(color: AppColors.blackColor),
              buttonName: AppLocalization.of(context).translate("see_all"),
              function: () {
                if(selectedTab == 0) {
                  // todo go to all appointments screen
                } else if(selectedTab == 1) {
                  // todo go to all subscribers screen
                } else if(selectedTab == 2) {
                  Navigation.push(AllTrainerActivitiesScreen());
                } else if(selectedTab == 4) {
                  Navigation.push(AllMediaScreen());
                }
              },
            ),
          ),
        SizedBox(height: 30.h),
      ],
    );
  }
}
