import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:centro_partner/core/classes/Keys.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';

class Dialogs {

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar({required BuildContext context,required String message}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: AppColors.mediumGrayColor,
          content: Text(message, style: AppTheme.labelLarge.copyWith(fontSize: 18.sp,color: AppColors.whiteColor),
      )),
    );
  }

  static void showQuestion(BuildContext context, {String? title, Widget? content, Widget? btnOk}) {
    AwesomeDialog(
      dialogBackgroundColor: AppColors.whiteColor,
      context: Keys.navigatorKey.currentContext!,
      dialogType: DialogType.noHeader,
      headerAnimationLoop: false,
      animType: AnimType.topSlide,
      btnCancel: btnOk != null ? CustomButton(
        height: 40.h,
        backgroundColor: AppColors.whiteColor,
        borderRadius: 10.r,
        buttonName: AppLocalization.of(context).translate("cancel"),
        textStyle: AppTheme.headlineSmall.copyWith(color: AppColors.blackColor),
        function: () {
          Navigation.pop();
        },
      ) : null,
      btnOk: btnOk,
      padding: EdgeInsets.symmetric(vertical: content != null ? 0 : 30.h),
      body: Column(
        children: [
          content ?? Column(
            children: [
              Center(
                child: SvgPicture.asset(error),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(title!,textAlign: TextAlign.center,
                  style: AppTheme.titleLarge.copyWith(fontSize: 22.sp),
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
