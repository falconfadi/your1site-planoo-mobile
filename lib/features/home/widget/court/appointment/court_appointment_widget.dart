import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_texts_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/icon_text_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/status_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/home/ui/court/calendar_screen.dart';
import 'package:centro_partner/features/home/ui/court/court_appointment_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CourtAppointmentWidget extends StatelessWidget {

  const CourtAppointmentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key("0"), // todo add a id of item
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            // todo accept api
            return false;
          }
          return false;
        },
        background: SizedBox.shrink(),
        secondaryBackground: Container(
          color: AppColors.darkGreenColor,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Icon(Icons.check,size: 30, color: Colors.white),
        ),
        child: InkWell(
          onTap: () => Navigation.push(CourtAppointmentDetailsScreen()),
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
                SizedBox(height: 5.h),
                Divider(),
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
              ],
            ),
          ),
        )
    );
  }
}
