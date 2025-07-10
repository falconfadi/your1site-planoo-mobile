import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextsWidget extends StatelessWidget {

  final String title;
  final TextStyle? titleStyle;
  final String? text;
  final TextStyle? textStyle;

  CustomTextsWidget({
    required this.title,
    this.titleStyle,
    this.text,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,style: titleStyle ?? AppTheme.titleLarge.copyWith(fontSize: 14)),
        SizedBox(width: text == null ? 0 : 10.w),
        if(text != null)
          Expanded(
            child: Text(text!,style: textStyle ??
                AppTheme.bodySmall.copyWith(fontSize: 14,color: AppColors.darkGrayColor)),
          )
      ],
    );
  }
}
