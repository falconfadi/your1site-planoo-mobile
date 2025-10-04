import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/general/ui/about_screen.dart';
import 'package:centro_partner/features/general/ui/settings_screen.dart';
import 'package:centro_partner/features/general/ui/terms_and_conditions_screen.dart';
import 'package:centro_partner/features/general/widget/drawer_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerWidget extends StatelessWidget {

  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 0.7.sw,
      child: ListView(
        children: [
          SizedBox(height: 20.h),
          Image.asset(miniLogo,width: 100.w,height: 100.w),
          DrawerItem(
            title: AppLocalization.of(context).translate("settings"),
            iconPath: settings,
            onTap: () => Navigation.push(SettingsScreen()),
          ),
          DrawerItem(
            title: AppLocalization.of(context).translate("about"),
            iconPath: about,
            onTap: () => Navigation.push(AboutScreen()),
          ),
          DrawerItem(
            title: AppLocalization.of(context).translate("terms_and_conditions"),
            iconPath: termsAndCondition,
            onTap: () => Navigation.push(TermsAndConditionsScreen()),
          ),
          DrawerItem(
            title: AppLocalization.of(context).translate("log_out"),
            iconPath: logout,
            onTap: () {
              Dialogs.showQuestion(
                context,
                title: "",
                content: Column(
                  children: [
                    ListTile(
                      title: Text(
                        "${AppLocalization.of(context).translate("are_you_sure")}?",
                        textAlign: TextAlign.center,
                        style: AppTheme.textTheme.headlineSmall!
                            .copyWith(color: AppColors.mediumGrayColor),
                      ),
                    ),
                  ],
                ),
                btnOk: CustomButton(
                  height: 40.h,
                  width: 1.sw,
                  backgroundColor: AppColors.redColor,
                  borderRadius: 8.r,
                  buttonName: AppLocalization.of(context).translate("ok"),
                  textStyle: AppTheme.textTheme.headlineSmall!
                      .copyWith(color: AppColors.whiteColor),
                  function: () {
                    // todo logout api later
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}