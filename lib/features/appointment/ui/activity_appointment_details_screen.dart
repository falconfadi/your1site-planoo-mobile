import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart' as image;
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_rating_bar.dart';
import 'package:centro_partner/core/ui/shared_widgets/icon_text_widget.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';
import 'package:centro_partner/features/appointment/data/appointment_repository/appointment_repository.dart';
import 'package:centro_partner/features/appointment/data/model/appointment_details_model.dart';
import 'package:centro_partner/features/appointment/data/usecase/cancel_activity_appointment_usecase.dart';
import 'package:centro_partner/features/appointment/widget/status_widget.dart';
import 'package:centro_partner/core/ui/widgets/cached_image.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/project_utils/status_type.dart';
import 'package:centro_partner/features/home/data/model/activity/activity_model.dart';
import 'package:centro_partner/features/home/ui/activity_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ActivityAppointmentDetailsScreen extends StatefulWidget {

  ActivityModel activityModel;
  AppointmentDetailsModel appointment;
  VoidCallback? onRefresh;

  ActivityAppointmentDetailsScreen({super.key,required this.activityModel,required this.appointment,this.onRefresh});

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
              InkWell(
                onTap: () {
                  Navigation.push(ActivityDetailsScreen(
                    activityId: widget.activityModel.activity!.iD!,
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
                          imageUrl: widget.activityModel.activity!.mediaList!.first.url!,
                          fit: BoxFit.cover,
                          borderRadius: 10.r,
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(widget.activityModel.activity!.name!,
                                  maxLines: 2,overflow: TextOverflow.ellipsis,
                                  style: AppTheme.headlineMedium),
                            ),
                            SizedBox(width: 10.w),
                            Text(widget.activityModel.activity!.price.toString(),
                                style: AppTheme.headlineMedium.copyWith(color: AppColors.turquoiseColor)),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(widget.activityModel.activity!.category!.name!,
                                  maxLines: 2,overflow: TextOverflow.ellipsis,
                                  style: AppTheme.headlineSmall.copyWith(
                                    color: AppColors.primaryColor
                                  )
                              ),
                            ),
                            SizedBox(width: 5.w),
                            CustomRatingBar(rate: 3.5,size: 18)
                          ],
                        ),
                        Text(widget.activityModel.activity!.description!,
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
                                        child: Text(widget.appointment.customer!.name!,
                                          style: AppTheme.headlineMedium.copyWith(
                                              color: AppColors.mediumGrayColor),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            ),
                            SizedBox(height:  widget.appointment.status == "accepted" ? 20.h : 0),
                            Row(
                                children: [
                                  widget.appointment.status == "accepted" ? Expanded(
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
                                                  style: AppTheme.headlineSmall.copyWith(color: AppColors.mediumGrayColor),
                                                ),
                                              ),
                                            ],
                                          ),
                                          btnOk: CreateModel(
                                            withValidation: false,
                                            onTap: () {},
                                            onSuccess: (result) {
                                              Navigation.pop();
                                              Navigation.pop();
                                              widget.onRefresh?.call();
                                            },
                                            useCaseCallBack: (model) {
                                              return CancelActivityAppointmentUseCase(AppointmentRepository()).call(
                                                params: CancelActivityAppointmentParams(appointmentId: widget.appointment.iD!)
                                              );
                                            },
                                            child: CustomButton(
                                              height: 40.h,
                                              width: 1.sw,
                                              backgroundColor: AppColors.redColor,
                                              borderRadius: 8.r,
                                              buttonName: AppLocalization.of(context).translate("ok"),
                                              textStyle: AppTheme.headlineSmall.copyWith(color: AppColors.whiteColor),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ) : Expanded(child: Center()),
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
