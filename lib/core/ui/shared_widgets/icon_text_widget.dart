import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';

class IconTextWidget extends StatelessWidget {

  final String icon;
  final double? iconSize;
  final String text;
  final TextStyle? textStyle;
  final Color? iconColor;
  final int maxLine;

  const IconTextWidget({super.key,
    required this.icon,
    this.iconSize,
    required this.text,
    this.textStyle,
    this.iconColor,
    this.maxLine = 1
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(icon,width: iconSize,color: iconColor ?? AppColors.blackColor),
        SizedBox(width: 5.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 5.sp),
            child: Text(text,
                maxLines: maxLine,
                overflow: maxLine <=1 ? TextOverflow.ellipsis : null,
                style: textStyle ?? AppTheme.labelLarge),
          ),
        )
      ],
    );
  }
}
