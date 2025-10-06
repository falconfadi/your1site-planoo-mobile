import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/icon_text_widget.dart';
import 'package:centro_partner/features/appointments/widget/status_widget.dart';
import 'package:centro_partner/core/ui/widgets/cached_image.dart';
import 'package:centro_partner/core/constants/app_images.dart' as image;
import 'package:centro_partner/core/utils/project_utils/status_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityAppointmentsWidget extends StatelessWidget {

  final Map<String,dynamic> appointment;

  const ActivityAppointmentsWidget({super.key,required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                      statusText: StatusType().getStatusInfo(appointment["status"] as int)["text"] as String,
                      statusColor: StatusType().getStatusInfo(appointment["status"] as int)["color"],
                    width: 0.25.sw,
                    height: 32.h,
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text(appointment["category"],
                        maxLines: 1,overflow: TextOverflow.ellipsis,
                        style: AppTheme.bodyMedium.copyWith(fontSize: 18.sp)
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: IconTextWidget(
                        icon: image.appointment,
                        iconSize: 18.w,
                        text: appointment["date"],
                      textStyle: AppTheme.labelLarge.copyWith(color: AppColors.mediumGrayColor),
                    )
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: IconTextWidget(
                        icon: image.time,
                        iconSize: 20.w,
                        text: "${appointment["from_time"]} - ${appointment["to_time"]}",
                        textStyle: AppTheme.labelLarge.copyWith(color: AppColors.mediumGrayColor),
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: IconTextWidget(
                        icon: image.user,
                        iconSize: 18.w,
                        text: appointment["user"],
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
                height: 185.h,
                imageUrl: appointment["photo"],
                fit: BoxFit.fill,
                borderRadius: 10.r,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
