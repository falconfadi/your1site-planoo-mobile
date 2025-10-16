import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/icon_text_widget.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';
import 'package:centro_partner/features/appointment/data/model/appointment_details_model.dart';
import 'package:centro_partner/features/appointment/ui/activity_appointment_details_screen.dart';
import 'package:centro_partner/features/appointment/widget/status_widget.dart';
import 'package:centro_partner/core/ui/widgets/cached_image.dart';
import 'package:centro_partner/core/constants/app_images.dart' as image;
import 'package:centro_partner/core/utils/project_utils/status_type.dart';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/activity/activity_model.dart';
import 'package:centro_partner/features/home/data/usecase/activity/activity_details_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ActivityAppointmentsWidget extends StatefulWidget {

  AppointmentDetailsModel? appointment;
  VoidCallback? onRefresh;

  ActivityAppointmentsWidget({super.key,required this.appointment,this.onRefresh});

  @override
  State<ActivityAppointmentsWidget> createState() => _ActivityAppointmentsWidgetState();
}

class _ActivityAppointmentsWidgetState extends State<ActivityAppointmentsWidget> {

  @override
  Widget build(BuildContext context) {
    return GetModel<ActivityModel>(
        loadingHeight: 100.h,
        useCaseCallBack: () {
          return ActivityDetailsUseCase(HomeRepository()).call(
              params: ActivityDetailsParams(activityId: widget.appointment!.holder!.id!));
        },
        modelBuilder: (model) => InkWell(
          onTap: () => Navigation.push(
              ActivityAppointmentDetailsScreen(
                activityModel: model,
                appointment: widget.appointment!,
                onRefresh: widget.onRefresh,
              )
          ),
          child: Card(
            color: AppColors.whiteColor,
            elevation: 3,
            shadowColor: AppColors.gray2Color,
            child: Container(
              height: 185.h,
              margin: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
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
                        StatusWidget(
                          statusText: widget.appointment!.status!,
                          statusColor: StatusType().getStatusInfo(widget.appointment!.status!)["color"],
                          width: 0.25.sw,
                          height: 32.h,
                        ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Text(model.activity!.category!.name!,
                              maxLines: 1,overflow: TextOverflow.ellipsis,
                              style: AppTheme.bodyMedium.copyWith(fontSize: 18.sp)
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: IconTextWidget(
                              icon: image.appointment,
                              iconSize: 18.w,
                              text: convertDate(date: widget.appointment!.date!,format: 'dd/MM/yyyy'),
                              textStyle: AppTheme.labelLarge.copyWith(color: AppColors.mediumGrayColor),
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: IconTextWidget(
                              icon: image.time,
                              iconSize: 20.w,
                              text: DateFormat("HH:mm").format(DateFormat("HH:mm:ss").parse(widget.appointment!.time!)),
                              textStyle: AppTheme.labelLarge.copyWith(color: AppColors.mediumGrayColor),
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: IconTextWidget(
                              icon: image.user,
                              iconSize: 18.w,
                              text: widget.appointment!.customer!.name!,
                              textStyle: AppTheme.labelLarge.copyWith(
                                  color: AppColors.mediumGrayColor),
                            )
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Flexible(
                    flex: 2,
                    child: CachedImage(
                      width: 1.sw,
                      height: 185.h,
                      imageUrl: model.activity!.mediaList!.first.url!,
                      fit: BoxFit.fill,
                      borderRadius: 10.r,
                      borderWidth: 1,
                      borderColor: AppColors.lightGrayColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
