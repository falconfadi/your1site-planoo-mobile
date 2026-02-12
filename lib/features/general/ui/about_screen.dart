import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutScreen extends StatelessWidget {

  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomHeader(title: AppLocalization.of(context).translate("about"),isNavBar: false),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 30.h),
        child: Text(AppLocalization.of(context).translate("about_planoo"),
          style: AppTheme.labelLarge,
        ),
      ),
    );
  }
}
