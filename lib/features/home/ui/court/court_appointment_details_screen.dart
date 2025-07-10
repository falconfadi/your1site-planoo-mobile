import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_texts_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/icon_text_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/status_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CourtAppointmentDetailsScreen extends StatelessWidget {

  const CourtAppointmentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomHeader(title: "",isNavBar: false),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Row(
              children: [
                SvgPicture.asset(time,width: 20,color: AppColors.mediumGrayColor,),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'Monday',
                      style: AppTheme.labelMedium,
                      children: [
                        TextSpan(
                            text: " ${AppLocalization.of(context).translate("at")} ",
                            style: AppTheme.titleSmall.copyWith(color: AppColors.darkGreenColor)
                        ),
                        TextSpan(
                            text: '04:30:00',
                            style: AppTheme.labelMedium
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                StatusWidget(statusText: "pending", statusColor: AppColors.primaryColor)
              ],
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: IconTextWidget(
                  icon: appointment,
                  iconSize: 15,
                  text: "30/08/2025"
              ),
            ),
            SizedBox(height: 10.h),
            IconTextWidget(
                icon: money,
                iconSize: 22,
                text: "400"
            ),
            SizedBox(height: 10.h),
            CustomTextsWidget(
              title: "${AppLocalization.of(context).translate("customer")}:",
              text: "maya skef",
            ),
            SizedBox(height: 20.h),
            CustomTextField(
              autoFocus: false,
              enabled: false,
              maxLine: 4,
              filledColor: AppColors.lightGrayColor,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.text,
              labelStyle: AppTheme.labelMedium,
              labelText: "this is note",
            ),
            SizedBox(height: 25.h),
            CustomTextsWidget(
              title: AppLocalization.of(context).translate("activity"),
              titleStyle: AppTheme.titleMedium,
            ),
            SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text("activity name",
                    style: AppTheme.labelMedium,
                  ),
                ),
                SizedBox(width: 5.w),
                // todo if vip or normal
                SvgPicture.asset(vip,width: 25.w)
              ],
            ),
            SizedBox(height: 5.h),
            Text("300 \$",
              style: AppTheme.titleSmall.copyWith(color: AppColors.darkGreenColor),
            ),
            SizedBox(height: 30.h),
            CustomButton(
                width: 1.sw,
                backgroundColor: AppColors.darkGreenColor,
                borderRadius: 10.r,
                buttonName: AppLocalization.of(context).translate("accept"),
                function: () {
                  // todo accept api
                }
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}
