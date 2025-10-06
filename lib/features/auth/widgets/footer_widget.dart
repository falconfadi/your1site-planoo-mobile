import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FooterWidget extends StatelessWidget {

  final String text;
  final String link;
  final VoidCallback? linkTap;

  const FooterWidget({required this.text,required this.link,this.linkTap,super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text,style: AppTheme.titleLarge),
        SizedBox(width: 4.w),
        InkWell(
          onTap: linkTap,
          child: Text(link,style: AppTheme.headlineSmall.copyWith(
              color: AppColors.primaryColor,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.primaryColor
          )),
        ),
      ],
    );
  }
}