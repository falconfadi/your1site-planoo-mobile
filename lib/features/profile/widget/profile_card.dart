import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';

class ProfileCard extends StatelessWidget {

  final String title;
  final String subtitle;

  const ProfileCard({super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      color: AppColors.whiteColor,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(AppLocalization.of(context).translate(title),style: AppTheme.labelLarge.copyWith(fontSize: 20.sp))),
          SizedBox(width: 5.w),
          Text(subtitle,style: AppTheme.labelLarge.copyWith(color: AppColors.mediumGrayColor,fontSize: 20.sp)),
        ],
      ),
    );
  }
}