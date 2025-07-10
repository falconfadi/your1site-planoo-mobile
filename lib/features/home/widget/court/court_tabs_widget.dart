import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/constants/enum/court_tabs.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/home/ui/all_media_screen.dart';
import 'package:centro_partner/features/home/ui/court/all_court_activities_screen.dart';
import 'package:centro_partner/features/home/ui/court/all_court_appointments_screen.dart';
import 'package:centro_partner/features/home/widget/court/appointment/court_appointments_tab.dart';
import 'package:centro_partner/features/home/widget/court/court_about_tab.dart';
import 'package:centro_partner/features/home/widget/court/workday/court_workdays_tab.dart';
import 'package:centro_partner/features/home/widget/court/activity/court_activities_tab.dart';
import 'package:centro_partner/features/home/widget/court/court_media_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourtTabsWidget extends StatefulWidget {

  const CourtTabsWidget({super.key});

  @override
  State<CourtTabsWidget> createState() => _CourtTabsWidgetState();
}

class _CourtTabsWidgetState extends State<CourtTabsWidget> {

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
            itemCount: CourtTabs.values.length,
            itemBuilder: (context, index) {
              final tab = CourtTabs.values[index];
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
                      // todo change condition when location is empty and selectedTab == 5
                      if(index == 5)
                       Icon(Icons.circle,size: 10,color: AppColors.redColor),
                      SizedBox(width: index == 5 ? 5.w : 0),
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
        selectedTab == 0 ? CourtAppointmentsTab() :
        selectedTab == 1 ? CourtActivitiesTab() :
        selectedTab == 2 ? CourtWorkdaysTab() :
        selectedTab == 3 ? Container() :
        selectedTab == 4 ? CourtMediaTab() : CourtAboutTab(),
        SizedBox(height: selectedTab == 4 ? 30.h : 0),
        if(selectedTab != 2 && selectedTab != 5)
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
                  Navigation.push(AllCourtAppointmentsScreen());
                } else if(selectedTab == 1) {
                  Navigation.push(AllCourtActivitiesScreen());
                } else if(selectedTab == 3) {
                  // todo go to all courses screen
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
