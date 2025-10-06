import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  final double? width;
  final String? buttonName;
  final TextStyle? textStyle;
  final String? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? borderSideColor;
  final double? borderRadius;
  final VoidCallback? function;
  final EdgeInsets? padding;

  const CustomButton({super.key,
    this.height,
    this.width,
    this.buttonName,
    this.textStyle,
    this.icon,
    this.iconColor,
    required this.backgroundColor,
    this.borderSideColor,
    required this.borderRadius,
    this.function,
    this.padding
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          padding: padding ?? EdgeInsets.only(left: 20.w,right: 20.w,top: 10.h,bottom: 5.h),
          minimumSize: Size(width ?? double.infinity, height ?? 60.h),
          backgroundColor: backgroundColor!,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
            side: BorderSide(color: borderSideColor ?? Colors.transparent, width: 0.5),
          ),
      ),
      onPressed: function,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            SvgPicture.asset(icon!, color: iconColor ?? AppColors.primaryColor),
          SizedBox(width: (buttonName != null) ? 5.w : 0),
          buttonName == null ? Center() :
            Expanded(
              child: Text(
                buttonName!,
                textAlign: TextAlign.center,
                style: textStyle ?? AppTheme.headlineSmall.copyWith(color: AppColors.whiteColor),
              ),
            ),
        ],
      )
    );
  }
}