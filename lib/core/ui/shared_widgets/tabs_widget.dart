import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/constants/enum/main_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabsWidget extends StatefulWidget {

  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  const TabsWidget({super.key,required this.selectedTab, required this.onTabChanged});

  @override
  State<TabsWidget> createState() => _TabsWidgetState();
}

class _TabsWidgetState extends State<TabsWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 35.h,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: MainTabs.values.length,
            itemBuilder: (context, index) {
              final tab = MainTabs.values[index];
              return InkWell(
                onTap: () => widget.onTabChanged(index),
                child: Container(
                  margin: EdgeInsets.only(right: 30.w),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: widget.selectedTab == index ?
                      AppColors.blackColor : Colors.transparent),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(AppLocalization.of(context).translate(tab.name),style: AppTheme.labelLarge.copyWith(
                        fontSize: 18.sp,
                          color: widget.selectedTab == index ?
                      AppColors.darkGrayColor : AppColors.mediumGrayColor))
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: AppColors.gray2Color,
        ),
      ],
    );
  }
}
