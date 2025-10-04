import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_switch_widget.dart';
import 'package:centro_partner/core/ui/widgets/coustom_sheet.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/general/ui/change_password_screen.dart';
import 'package:centro_partner/features/general/widget/language_sheet.dart';
import 'package:centro_partner/features/general/widget/settings_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatelessWidget {

  final bool notifications = true;

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomHeader(title: AppLocalization.of(context).translate("settings"),isNavBar: false),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 30.h),
        child: Column(
          children: [
            SettingsWidget(
              onTap: null,
              icon: "",
              title: "notifications",
              trailing: CustomSwitchWidget(activate: notifications),
            ),
            SizedBox(height: 25.h),
            SettingsWidget(
              onTap: () => CustomSheet.show(
                  isDismissible: true,
                  header: Text(AppLocalization.of(context).translate("app_language"),
                    style: AppTheme.textTheme.titleLarge!.copyWith(fontSize: 18.sp),
                  ),
                  padding: 30.w,
                  context: context,
                  child: LanguageSheet()),
              icon: language,
              title: "app_language",
            ),
            SizedBox(height: 25.h),
            SettingsWidget(
              onTap: () => Navigation.push(ChangePasswordScreen()),
              icon: key,
              title: "change_password",
            ),
            SizedBox(height: 30.h),
          ],
        )
      ),
    );
  }
}
