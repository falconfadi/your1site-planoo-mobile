import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_texts_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/expandable_text_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/home/ui/trainer/trainer_create_activity_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TrainerActivityDetailsScreen extends StatelessWidget {

  const TrainerActivityDetailsScreen({super.key});

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
                  child: Text("activity name",
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
                          onTap: () =>  Navigation.push(TrainerCreateActivityScreen(isEdit: true))
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
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("300 \$",
                  style: AppTheme.titleSmall,
                ),
                SizedBox(width: 10.h),
                // todo if vip or normal
                SvgPicture.asset(vip,width: 25.w)
              ],
            ),
            SizedBox(height: 5.h),
            // todo AppColors.grayColor if deactivate
            Text(AppLocalization.of(context).translate("activate"),style:
            AppTheme.bodySmall.copyWith(fontSize: 14,color: AppColors.darkGreenColor)),
            SizedBox(height: 10.h),
            CustomTextsWidget(
              title: "${AppLocalization.of(context).translate("cancellation_cost")}:",
              text: "10 \$",
            ),
            SizedBox(height: 10.h),
            CustomTextsWidget(
              title: "${AppLocalization.of(context).translate("trial")}:",
              // text: "discount" + " - " + "100 \$",
              text: "free",
            ),
            SizedBox(height: 10.h),
            CustomTextsWidget(
              title: "${AppLocalization.of(context).translate("private")}:",
              text: "100 \$",
            ),
            SizedBox(height: 25.h),
            ExpandableTextWidget(
                text: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc",
                style: AppTheme.labelMedium
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
