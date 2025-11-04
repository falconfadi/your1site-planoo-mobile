import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart' as image;
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_rating_bar.dart';
import 'package:centro_partner/core/ui/shared_widgets/icon_text_widget.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';
import 'package:centro_partner/features/appointment/data/model/appointment_details_model.dart';
import 'package:centro_partner/features/appointment/widget/status_widget.dart';
import 'package:centro_partner/core/ui/widgets/cached_image.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/project_utils/status_type.dart';
import 'package:centro_partner/features/home/data/model/course/course_model.dart';
import 'package:centro_partner/features/home/ui/course/course_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CourseAppointmentDetailsScreen extends StatefulWidget {

  CourseModel courseModel;
  AppointmentDetailsModel appointment;
  VoidCallback? onRefresh;

  CourseAppointmentDetailsScreen({super.key,required this.courseModel,required this.appointment,this.onRefresh});

  @override
  State<CourseAppointmentDetailsScreen> createState() => _CourseAppointmentDetailsScreenState();
}

class _CourseAppointmentDetailsScreenState extends State<CourseAppointmentDetailsScreen> {

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
              InkWell(
                onTap: () {
                  Navigation.push(CourseDetailsScreen(
                    courseId: widget.courseModel.course!.iD!,
                  ));
                },
                child: Card(
                  color: AppColors.whiteColor,
                  elevation: 3,
                  shadowColor: AppColors.gray2Color,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
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
                          imageUrl: widget.courseModel.course!.mediaList!.isNotEmpty ?
                          widget.courseModel.course!.mediaList!.first.url! : "",
                          fit: BoxFit.cover,
                          borderRadius: 10.r,
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(widget.courseModel.course!.name!,
                                  maxLines: 2,overflow: TextOverflow.ellipsis,
                                  style: AppTheme.headlineMedium),
                            ),
                            SizedBox(width: 10.w),
                            Text(widget.courseModel.course!.price.toString(),
                                style: AppTheme.headlineMedium.copyWith(color: AppColors.turquoiseColor)),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(widget.courseModel.course!.category!.name!,
                                  maxLines: 2,overflow: TextOverflow.ellipsis,
                                  style: AppTheme.headlineSmall.copyWith(
                                    color: AppColors.primaryColor
                                  )
                              ),
                            ),
                            SizedBox(width: 5.w),
                            CustomRatingBar(rate: 3.5,size: 18) // todo
                          ],
                        ),
                        Text(widget.courseModel.course!.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.labelMedium.copyWith(color: AppColors.darkGrayColor),
                        )
                      ],
                    ),
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
                              style: AppTheme.headlineMedium,
                            ),
                            SizedBox(height: 20.h),
                            StatusWidget(
                              statusText: widget.appointment.status!,
                              statusColor: StatusType().getStatusInfo(widget.appointment.status!)["color"],
                              width: 0.25.sw,
                              height: 32.h,
                            ),
                            SizedBox(height: 20.h),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: IconTextWidget(
                                  icon: image.appointment,
                                  iconSize: 20.w,
                                  text: convertDate(date: widget.appointment.date!,format: 'dd/MM/yyyy'),
                                  textStyle: AppTheme.labelLarge.copyWith(
                                    fontSize: 18.sp, color: AppColors.mediumGrayColor),
                                )
                            ),
                            SizedBox(height: 10.h),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: IconTextWidget(
                                  icon: image.time,
                                  iconSize: 22.w,
                                  text: DateFormat("HH:mm").format(DateFormat("HH:mm:ss").parse(widget.appointment.time!)),
                                  textStyle: AppTheme.labelLarge.copyWith(
                                      fontSize: 18.sp, color: AppColors.mediumGrayColor),
                                )
                            ),
                            SizedBox(height: 10.h),
                            Row(
                                children: [
                                  Expanded(child: Center()),
                                  SizedBox(width: 20.w),
                                  Expanded(
                                    child: CustomButton(
                                      height: 40.h,
                                      backgroundColor: AppColors.turquoiseColor,
                                      borderRadius: 10.r,
                                      buttonName: AppLocalization.of(context).translate("ok"),
                                      function: () {
                                        Navigation.pop();
                                      },
                                    ),
                                  )
                                ]
                            ),
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
