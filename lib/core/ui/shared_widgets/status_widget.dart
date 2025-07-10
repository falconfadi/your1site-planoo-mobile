import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';

class StatusWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final String statusText;
  final Color statusColor;

  StatusWidget({
    this.width,
    this.height,
    required this.statusText,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(5.r),
        boxShadow: [
          BoxShadow(
              color: AppColors.grayColor,
              spreadRadius: 0,
              blurRadius: 3,
              offset: const Offset(0,0)
          )
        ],
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
          child: Text(statusText,
            style: AppTheme.bodyMedium.copyWith(fontSize: 14,color: statusColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
