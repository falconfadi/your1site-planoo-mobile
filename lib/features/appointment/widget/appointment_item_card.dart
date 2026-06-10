import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_rating_bar.dart';
import 'package:centro_partner/core/ui/widgets/cached_image.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentItemCard extends StatelessWidget {

  final VoidCallback onTap;
  final String imageUrl;
  final String title;
  final String category;
  final String description;
  final String price;
  final double rating;

  const AppointmentItemCard({
    super.key,
    required this.onTap,
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    return InkWell(
      onTap: onTap,
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
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                borderRadius: 10.r,
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(title,
                        maxLines: 2,overflow: TextOverflow.ellipsis,
                        style: AppTheme.headlineMedium),
                  ),
                  SizedBox(width: 10.w),
                  Text(price,
                      style: AppTheme.headlineMedium.copyWith(color: AppColors.turquoiseColor)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(category,
                        maxLines: 2,overflow: TextOverflow.ellipsis,
                        style: AppTheme.headlineSmall.copyWith(
                            color: AppColors.primaryColor
                        )
                    ),
                  ),
                  SizedBox(width: 5.w),
                  CustomRatingBar(rate: rating,
                      size: isTablet ? 18.sp : 18)
                ],
              ),
              Text(description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.labelMedium.copyWith(color: AppColors.darkGrayColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}