import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';

class ProfileCard extends StatelessWidget {

  VoidCallback onTap;
  String icon;
  Color? iconColor;
  String title;
  String? subtitle;
  bool? withDropDownIcon;

  ProfileCard({
    required this.onTap,
    required this.icon,
    this.iconColor,
    required this.title,
    this.subtitle,
    this.withDropDownIcon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 1.sw,
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.w),
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(10.r)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldColor,
                  shape: BoxShape.circle
                ),
                child: SvgPicture.asset(icon,width: 30.h,height: 30.h,color: iconColor ?? AppColors.mediumGrayColor)
            ),
            SizedBox(width: 15.w),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalization.of(context).translate(title),style: AppTheme.bodyMedium),
                  subtitle == null ? Center() :
                  Text(AppLocalization.of(context).translate(subtitle!),style: AppTheme.labelSmall.copyWith(color: AppColors.mediumGrayColor)),
                ],
              ),
            ),
            if(withDropDownIcon != null)
              Icon(Icons.keyboard_arrow_down_outlined)
          ],
        ),
      ),
    );
  }
}