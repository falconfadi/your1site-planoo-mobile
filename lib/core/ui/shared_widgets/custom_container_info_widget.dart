import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class CustomContainerInfoWidget extends StatelessWidget {

  String title;
  String? icon;
  TextStyle? textStyle;

  CustomContainerInfoWidget({required this.title,this.icon,this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.blackColor,width: 0.5)
      ),
      child: Padding(
        padding:  EdgeInsets.only(left: 15.w,right: 10.w,top: 15.h,bottom: 15.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                icon != null ? SvgPicture.asset(icon!,color: AppColors.primaryColor) : const Center(),
                SizedBox(width: icon != null ? 5.w : 0),
                Text(title,style: textStyle ?? AppTheme.labelMedium.copyWith(color: AppColors.grayColor)),
              ],
            ),
            SizedBox(width: 20.w),
            const Flexible(child: Icon(Icons.keyboard_arrow_down_outlined,size: 22,color: AppColors.grayColor))
          ],
        ),
      ),
    );
  }
}