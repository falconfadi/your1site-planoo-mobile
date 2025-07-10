import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/home/ui/trainer/trainer_activity_details_screen.dart';
import 'package:centro_partner/features/home/ui/trainer/trainer_create_activity_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TrainerActivityWidget extends StatelessWidget {

  const TrainerActivityWidget({super.key});

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
            Navigation.push(TrainerCreateActivityScreen(isEdit: true));
            return false;
          }
          return false;
        },
        background: Container(
          color: AppColors.grayColor, // todo change to AppColors.darkGreenColor if it is active
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Icon(/*Icons.toggle_on_outlined */Icons.toggle_off_outlined,size: 30,color: AppColors.whiteColor),
        ),
        secondaryBackground: Container(
          color: AppColors.primaryColor,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Icon(Icons.edit_outlined,size: 30, color: Colors.white),
        ),
        child: InkWell(
          onTap: () => Navigation.push(TrainerActivityDetailsScreen()),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text("activity name",
                        style: AppTheme.bodyMedium,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    // todo if vip or normal
                    SvgPicture.asset(vip,width: 25.w)

                  ],
                ),
                SizedBox(height: 5.h),
                Text("300 \$",
                  style: AppTheme.titleSmall,
                ),
                // todo AppColors.grayColor if deactivate
                Text(AppLocalization.of(context).translate("activate"),style:
                AppTheme.bodySmall.copyWith(fontSize: 14,color: AppColors.darkGreenColor)),
                Text("Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis",
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: AppTheme.labelSmall,
                ),
              ],
            ),
          ),
        )
    );
  }
}
