import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';

class SettingsWidget extends StatelessWidget {

  final VoidCallback? onTap;
  final String? icon;
  final String title;
  final Widget? trailing;

  const SettingsWidget({super.key,
    this.onTap,
    required this.icon,
    required this.title,
    this.trailing
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon == "" ? Center() :  Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                  color: AppColors.extraLightGrayColor,
                  shape: BoxShape.circle
              ),
              child: SvgPicture.asset(icon!,color: AppColors.turquoiseColor)
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Text(AppLocalization.of(context).translate(title),
                style: AppTheme.bodyLarge.copyWith(fontSize: 18.sp)
            ),
          ),
          trailing ?? Icon(Icons.keyboard_arrow_right_outlined)
        ],
      ),
    );
  }
}