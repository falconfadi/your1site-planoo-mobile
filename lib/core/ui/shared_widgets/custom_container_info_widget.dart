import 'package:centro_partner/core/classes/app_storage.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
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
    final isTablet = Responsive.isTablet(context);
    return Container(
      height: height,
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.mediumGrayColor,width: 0.5)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Padding(
            padding: EdgeInsets.only(left: AppStorage.languageCode == "ar" ?
            0 : 15.w, right: AppStorage.languageCode == "ar" ? 15.w : 0 ,
                bottom: 10.h,
                top: isTablet ? 18.h : 15.h),
            child: Text(title,style: textStyle ?? AppTheme.labelLarge.copyWith(fontSize: 18.sp,color: AppColors.mediumGrayColor)),
          )),
          SizedBox(width: 10.w),
          Padding(
            padding: EdgeInsets.only(
                right: AppStorage.languageCode == "ar" ? 0 : 10.h,
                left: AppStorage.languageCode == "ar" ? 10.h : 0,
                top: 5.h),
            child: Icon(Icons.keyboard_arrow_down_outlined,color: AppColors.grayColor,size: isTablet ? 20.sp : null),
          )
        ],
      ),
    );
  }
}