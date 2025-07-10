import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/home/ui/trainer/trainer_create_workday_screen.dart';
import 'package:centro_partner/features/home/ui/trainer/trainer_workday_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrainerWorkdayWidget extends StatelessWidget {

  const TrainerWorkdayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key("0"), // todo add a id of item
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            // todo activate or deactivate api
            return false;
          } else if (direction == DismissDirection.endToStart) {
            Navigation.push(TrainerCreateWorkdayScreen(isEdit: true));
            return false;
          }
          return false;
        },
        background: Container(
          color: AppColors.grayColor,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Icon(/*Icons.toggle_on_outlined */Icons.toggle_off_outlined,size: 30,color: AppColors.whiteColor),
        ),
        secondaryBackground: Container(
          color: AppColors.primaryColor,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Icon(Icons.edit_outlined,size: 30, color: AppColors.whiteColor),
        ),
        child: InkWell(
          onTap: () => Navigation.push(TrainerWorkdayDetailsScreen()),
          child: Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                    color: AppColors.gray2Color,
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0,1)
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: '10:00:00', // default style
                    style: AppTheme.labelMedium,
                    children: [
                      TextSpan(
                          text: " ${AppLocalization.of(context).translate("to")} ",
                          style: AppTheme.titleSmall.copyWith(color: AppColors.darkGreenColor)
                      ),
                      TextSpan(
                          text: '04:30:00 ',
                          style: AppTheme.labelMedium
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                // todo AppColors.grayColor if deactivate
                Text(AppLocalization.of(context).translate("activate"),style:
                AppTheme.bodySmall.copyWith(fontSize: 14,color: AppColors.darkGreenColor)),
              ],
            ),
          ),
        )
    );
  }
}
