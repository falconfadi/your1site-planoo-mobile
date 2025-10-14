import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRowWidget extends StatelessWidget {

  final String title;
  final String subTitle;
  final CrossAxisAlignment? crossAxisAlignment;

  const CustomRowWidget({super.key,
    required this.title,
    required this.subTitle,
    this.crossAxisAlignment
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      children: [
        Text("$title: ",style: AppTheme.bodyLarge.copyWith(color: AppColors.turquoiseColor)),
        Expanded(child: Text(subTitle,style: AppTheme.labelLarge.copyWith(fontSize: 18.sp))),
      ],
    );
  }
}