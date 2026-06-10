import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/utils/navigation/navigation.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBackIconWidget extends StatelessWidget {

  const CustomBackIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    return InkWell(
      onTap: () => Navigation.pop(),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(8.r)
        ),
        child: Icon(Icons.arrow_back_ios_new_rounded,size: isTablet ? 15.sp : 18),
      ),
    );
  }
}