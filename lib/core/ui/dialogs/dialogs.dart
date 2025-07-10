import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:centro_partner/core/clasess/Keys.dart';
import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';

class Dialogs {

  static showSnackBar({required BuildContext context,required String message}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: AppColors.mediumGrayColor,
          content: Text(message, style: AppTheme.labelMedium.copyWith(color: AppColors.whiteColor),
      )),
    );
  }

  static showQuestion(context, {String? title, Widget? content, Widget? btnOk}) {
    AwesomeDialog(
      dialogBackgroundColor: AppColors.whiteColor,
      dialogBorderRadius: BorderRadius.circular(26.r),
      context: Keys.navigatorKey.currentContext!,
      dialogType: DialogType.noHeader,
      headerAnimationLoop: false,
      animType: AnimType.topSlide,
      btnCancel: btnOk != null ? CustomButton(
        height: 40.h,
        backgroundColor: AppColors.whiteColor,
        borderRadius: 10.r,
        buttonName: AppLocalization.of(context).translate("cancel"),
        textStyle: AppTheme.headlineSmall.copyWith(fontSize: 15, color: AppColors.blackColor),
        function: () {
          Navigation.pop();
        },
      ) : null,
      btnOk: btnOk,
      padding: EdgeInsets.symmetric(vertical: content != null ? 0 : 50.h),
      body: Column(
        children: [
          content ?? Column(
            children: [
              Center(
                child: SvgPicture.asset(error),
              ),
              SizedBox(height: 10.h),
              ListTile(
                title: Text(
                  AppLocalization.of(context).translate("operation_error"),
                  textAlign: TextAlign.center,
                  style: AppTheme.headlineSmall,
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Text(title!,textAlign: TextAlign.center,
                    style: AppTheme.titleLarge.copyWith(color: AppColors.mediumGrayColor),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ],
      ),
    ).show();
  }
}
