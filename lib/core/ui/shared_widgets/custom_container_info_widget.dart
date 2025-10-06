import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class CustomContainerInfoWidget extends StatelessWidget {

  final double? height;
  final String title;
  final String? icon;
  final TextStyle? textStyle;

  const CustomContainerInfoWidget({super.key, this.height,required this.title,this.icon,this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 60.h,
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.blackColor,width: 0.5)
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 15.w,right: 10.w,top: 5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,style: textStyle ?? AppTheme.labelLarge.copyWith(fontSize: 18.sp,color: AppColors.mediumGrayColor)),
            SizedBox(width: 20.w),
            const Flexible(child: Icon(Icons.keyboard_arrow_down_outlined,color: AppColors.grayColor))
          ],
        ),
      ),
    );
  }
}