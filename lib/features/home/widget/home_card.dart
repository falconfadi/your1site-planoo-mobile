import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeCard extends StatelessWidget {

  final String imageUrl;
  final String title;
  final String subtitle;
  final String price;
  final VoidCallback onTap;

  const HomeCard({super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.onTap,
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
            children: [
              Expanded(
                child: CachedImage(
                  width: 1.sw,
                  height: 0.12.sh,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.bodyLarge.copyWith(fontSize: 18.sp),
                    ),
                    Text(subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.bodyMedium.copyWith(color: AppColors.mediumGrayColor),
                    ),
                    Text("$price ${AppLocalization.of(context).translate("syr")}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.headlineSmall.copyWith(color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
