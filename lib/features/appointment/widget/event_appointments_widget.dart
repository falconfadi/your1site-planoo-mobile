import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/icon_text_widget.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';
import 'package:centro_partner/features/appointment/data/model/appointment_details_model.dart';
import 'package:centro_partner/features/appointment/ui/event_appointment_details_screen.dart';
import 'package:centro_partner/features/appointment/widget/status_widget.dart';
import 'package:centro_partner/core/ui/widgets/cached_image.dart';
import 'package:centro_partner/core/constants/app_images.dart' as image;
import 'package:centro_partner/core/utils/project_utils/status_type.dart';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/event/event_model.dart';
import 'package:centro_partner/features/home/data/usecase/event/event_details_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class EventAppointmentsWidget extends StatefulWidget {

  AppointmentDetailsModel? appointment;
  VoidCallback? onRefresh;

  EventAppointmentsWidget({super.key,required this.appointment,this.onRefresh});

  @override
  State<EventAppointmentsWidget> createState() => _EventAppointmentsWidgetState();
}

class _EventAppointmentsWidgetState extends State<EventAppointmentsWidget> {

  @override
  Widget build(BuildContext context) {
    return GetModel<EventModel>(
        loadingHeight: 100.h,
        useCaseCallBack: () {
          return EventDetailsUseCase(HomeRepository()).call(
              params: EventDetailsParams(eventId: widget.appointment!.holder!.id!));
        },
        modelBuilder: (model) => InkWell(
          onTap: () => Navigation.push(
              EventAppointmentDetailsScreen(
                eventModel: model,
                appointment: widget.appointment!,
                onRefresh: widget.onRefresh,
              )
          ),
          child: Card(
            color: AppColors.whiteColor,
            elevation: 3,
            shadowColor: AppColors.gray2Color,
            child: Container(
              height: 130.h,
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
                          child: Text(model.event!.category!.name!,
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
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Flexible(
                    flex: 2,
                    child: CachedImage(
                      width: 1.sw,
                      height: 130.h,
                      imageUrl: model.event!.mediaList!.isNotEmpty ?
                      model.event!.mediaList!.first.url! : "",
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
