import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart' as image;
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_rating_bar.dart';
import 'package:centro_partner/core/ui/shared_widgets/icon_text_widget.dart';
import 'package:centro_partner/features/appointments/widget/status_widget.dart';
import 'package:centro_partner/core/ui/widgets/cached_image.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/project_utils/status_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityAppointmentDetailsScreen extends StatefulWidget {

  final Map<String,dynamic> appointment;

  const ActivityAppointmentDetailsScreen({super.key,required this.appointment});

  @override
  State<ActivityAppointmentDetailsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<ActivityAppointmentDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: CustomHeader(title: "", isNavBar: false),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Card(
                color: AppColors.whiteColor,
                elevation: 3,
                shadowColor: AppColors.gray2Color,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5.h,horizontal: 5.w),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedImage(
                        width: 1.sw,
                        height: 180.h,
                        imageUrl: widget.appointment["photo"],
                        fit: BoxFit.cover,
                        borderRadius: 10.r,
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Text("Basketball Practice",
                            maxLines: 2,overflow: TextOverflow.ellipsis,
                            style: AppTheme.textTheme.headlineMedium),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.appointment["category"],
                                style: AppTheme.textTheme.headlineSmall!.copyWith(
                                  color: AppColors.primaryColor
                                )
                            ),
                            SizedBox(width: 5.w),
                            CustomRatingBar(rate: 3.5,size: 18)
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: IconTextWidget(
                          icon: image.location,
                          iconSize: 18.w,
                          iconColor: AppColors.mediumGrayColor,
                          text: "Damascus, AL mazaa",
                          textStyle: AppTheme.textTheme.labelLarge!.copyWith(color: AppColors.mediumGrayColor),
                        )
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Card(
                color: AppColors.whiteColor,
                elevation: 3,
                shadowColor: AppColors.gray2Color,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalization.of(context).translate("about_appointment"),
                              style: AppTheme.textTheme.headlineMedium,
                            ),
                            SizedBox(height: 20.h),
                            StatusWidget(
                              statusText: StatusType().getStatusInfo(widget.appointment["status"] as int)["text"] as String,
                              statusColor: StatusType().getStatusInfo(widget.appointment["status"] as int)["color"],
                              width: 0.25.sw,
                              height: 32.h,
                            ),
                            SizedBox(height: 20.h),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: IconTextWidget(
                                  icon: image.appointment,
                                  iconSize: 20.w,
                                  text: widget.appointment["date"],
                                  textStyle: AppTheme.textTheme.labelLarge!.copyWith(
                                    fontSize: 18.sp, color: AppColors.mediumGrayColor),
                                )
                            ),
                            SizedBox(height: 10.h),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: IconTextWidget(
                                  icon: image.time,
                                  iconSize: 22.w,
                                  text: "${widget.appointment["from_time"]} - ${widget.appointment["to_time"]}",
                                  textStyle: AppTheme.textTheme.labelLarge!.copyWith(
                                      fontSize: 18.sp, color: AppColors.mediumGrayColor),
                                )
                            ),
                            SizedBox(height: 10.h),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Row(
                                  children: [
                                    CachedImage(
                                      width: 45.w,
                                      height: 45.w,
                                      imageUrl: "",
                                      fit: BoxFit.cover,
                                      borderColor: AppColors.grayColor,
                                      borderRadius: 10.r,
                                      borderWidth: 1,
                                      errorForUser: true,
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 5.h),
                                        child: Text(widget.appointment["user"],
                                          style: AppTheme.textTheme.headlineMedium!.copyWith(
                                              color: AppColors.mediumGrayColor),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            ),
                            SizedBox(height:  widget.appointment["status"] == 0 ? 5.h : 0),
                            widget.appointment["status"] == 0 ?
                            Row(
                                children: [
                                  Expanded(flex: 2,child: Center()),
                                  Expanded(
                                    child: CustomButton(
                                      height: 40.h,
                                      backgroundColor: AppColors.redColor,
                                      borderRadius: 10.r,
                                      buttonName: AppLocalization.of(context).translate("cancel"),
                                      function: () {
                                        Dialogs.showQuestion(context,
                                          title: "",content: Column(
                                            children: [
                                              ListTile(
                                                title: Text("${AppLocalization.of(context).translate("are_you_sure")}?",textAlign: TextAlign.center,
                                                  style: AppTheme.textTheme.headlineSmall!.copyWith(color: AppColors.mediumGrayColor),
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
                                            textStyle: AppTheme.textTheme.headlineSmall!.copyWith(color: AppColors.whiteColor),
                                            function: () {
                                              // todo cancel api later
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ]
                            ) : Center(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50.h),
            ],
          ),
        )
    );
  }
}
