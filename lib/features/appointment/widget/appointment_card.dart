import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/icon_text_widget.dart';
import 'package:centro_partner/core/ui/widgets/cached_image.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/core/constants/app_images.dart' as image;

// class AppointmentCard extends StatelessWidget {
//
//   final VoidCallback onTap;
//   final double cardHeight;
//   final String title;
//   final String date;
//   final String imageUrl;
//   final Widget? header;
//   final List<Widget> details;
//
//   const AppointmentCard({
//     super.key,
//     required this.onTap,
//     required this.cardHeight,
//     required this.title,
//     required this.date,
//     required this.imageUrl,
//     required this.details,
//     this.header,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Card(
//         color: AppColors.whiteColor,
//         elevation: 3,
//         shadowColor: AppColors.gray2Color,
//         child: Container(
//           height: cardHeight,
//           margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Flexible(
//                 flex: 3,
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 5.w),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (header != null) header!,
//                       if (header != null) SizedBox(height: 10.h),
//                       Text(
//                         title,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: AppTheme.bodyMedium.copyWith(
//                           fontSize: 18.sp,
//                         ),
//                       ),
//                       IconTextWidget(
//                         icon: image.appointment,
//                         iconSize: 18.w,
//                         text: convertDate(
//                           date: date,
//                           format: 'dd/MM/yyyy',
//                         ),
//                         textStyle: AppTheme.labelLarge.copyWith(
//                           color: AppColors.mediumGrayColor,
//                         ),
//                       ),
//                       ...details,
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(width: 10.w),
//               Flexible(
//                 flex: 2,
//                 child: CachedImage(
//                   width: 1.sw,
//                   height: cardHeight,
//                   imageUrl: imageUrl,
//                   fit: BoxFit.cover,
//                   borderRadius: 10.r,
//                   borderWidth: 1,
//                   borderColor: AppColors.lightGrayColor,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class AppointmentCard extends StatelessWidget {

  final VoidCallback onTap;
  final double imageHeight;
  final String title;
  final String date;
  final String imageUrl;
  final Widget? header;
  final List<Widget> details;
  final bool isAppointment;

  const AppointmentCard({
    super.key,
    required this.onTap,
    required this.imageHeight,
    required this.title,
    required this.date,
    required this.imageUrl,
    required this.details,
    this.header,
    this.isAppointment = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: AppColors.whiteColor,
        elevation: 3,
        shadowColor: AppColors.gray2Color,
        child: Container(
          width: 1.sw,
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CachedImage(
                  width: 1.sw,
                  height: imageHeight,
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  borderRadius: 10.r,
                  borderWidth: 1,
                  borderColor: AppColors.lightGrayColor,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (header != null) header!,
                      if (header != null) SizedBox(height: 10.h),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.bodyMedium.copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                      IconTextWidget(
                        icon: image.appointment,
                        iconSize: 18.w,
                        text: convertDate(
                          date: date,
                          format: 'dd/MM/yyyy',
                        ),
                        textStyle: AppTheme.labelLarge.copyWith(
                          color: AppColors.mediumGrayColor,
                        ),
                      ),
                      ...details,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
