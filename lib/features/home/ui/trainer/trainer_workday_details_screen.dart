import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_texts_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/home/ui/trainer/trainer_create_workday_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrainerWorkdayDetailsScreen extends StatelessWidget {

  const TrainerWorkdayDetailsScreen({super.key});

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text("Day",
                    style: AppTheme.titleSmall,
                  ),
                ),
                SizedBox(width: 10.h),
                SizedBox(
                  width: 30.w,
                  child: PopupMenuButton(
                    offset: const Offset(0,40),
                    onSelected: (value) {},
                    color: AppColors.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    ),
                    elevation: 10,
                    shadowColor: AppColors.gray2Color,
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                          value: "",
                          height: 50.h,
                          child: Center(
                            child: Text(
                              AppLocalization.of(context).translate("edit"),
                              style: AppTheme.labelSmall,
                            ),
                          ),
                          onTap: () => Navigation.push(TrainerCreateWorkdayScreen(isEdit: true))
                      ),
                      PopupMenuItem(
                          value: "",
                          height: 50.h,
                          child: Center(
                            child: Text(
                              AppLocalization.of(context).translate("delete"),
                              style: AppTheme.labelSmall.copyWith(color: AppColors.redColor),
                            ),
                          ),
                          onTap: () {
                            Dialogs.showQuestion(context,
                              title: "",content: Column(
                                children: [
                                  ListTile(
                                    title: Text("${AppLocalization.of(context).translate("are_you_sure")}?",textAlign: TextAlign.center,
                                      style: AppTheme.titleSmall.copyWith(color: AppColors.mediumGrayColor),
                                    ),
                                  ),
                                ],
                              ),
                              btnOk: CustomButton(
                                height: 40.h,
                                width: 1.sw,
                                backgroundColor: AppColors.whiteColor,
                                borderRadius: 8.r,
                                buttonName: AppLocalization.of(context).translate("ok"),
                                textStyle: AppTheme.titleSmall.copyWith(fontSize: 15, color: AppColors.blackColor),
                              ),
                            );
                          }
                      ),
                      PopupMenuItem(
                        value: "",
                        height: 50.h,
                        child: Center(
                          child: Text(
                            AppLocalization.of(context).translate("activate"),
                            // AppLocalization.of(context).translate("deactivate"),
                            style: AppTheme.labelSmall,
                          ),
                        ),
                        onTap: () {
                          // todo activate or deactivate
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            CustomTextsWidget(
              title: "${AppLocalization.of(context).translate("from_time")}:",
              text: '10:00:00',
            ),
            SizedBox(height: 10.h),
            CustomTextsWidget(
              title: "${AppLocalization.of(context).translate("to_time")}:",
              text: '04:30:00 ',
            ),
            SizedBox(height: 10.h),
            // todo AppColors.grayColor if deactivate
            Text(AppLocalization.of(context).translate("activate"),style:
            AppTheme.bodySmall.copyWith(fontSize: 14,color: AppColors.darkGreenColor)),
            SizedBox(height: 25.h),
            CustomTextsWidget(
              title: AppLocalization.of(context).translate("duration"),
              titleStyle: AppTheme.titleMedium,
            ),
            SizedBox(height: 10.h),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context,index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: Container(
                    width: 1.sw,
                    padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.gray2Color,
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0,1)
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: '10:00:00', // default style
                            style: AppTheme.labelMedium,
                            children: [
                              TextSpan(
                                  text: " ${AppLocalization.of(context).translate("to")} ",
                                  style: AppTheme.titleMedium.copyWith(fontSize: 16)
                              ),
                              TextSpan(
                                  text: '04:30:00 ',
                                  style: AppTheme.labelMedium
                              ),
                            ],
                          ),
                        ),
                        Text("(${"30 minutes"})",
                            style: AppTheme.bodyMedium.copyWith(color: AppColors.darkGreenColor)
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
