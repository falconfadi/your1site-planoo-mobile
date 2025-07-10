import 'package:centro_partner/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomImageEditButton extends StatelessWidget {

  const CustomImageEditButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.r),
        color: AppColors.whiteColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.r),
            color: AppColors.primaryColor,
          ),
          child: Center(
            child: SvgPicture.asset(image),
          ),
        ),
      ),
    );
  }
}
