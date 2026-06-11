import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/constants/end_point.dart';
import 'package:centro_partner/core/ui/widgets/cached_image.dart';
import 'package:centro_partner/features/home/data/model/facility_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FacilitiesPreviewWidget extends StatelessWidget {

  final List<FacilityInfoModel> facilitiesList;

  const FacilitiesPreviewWidget({super.key,
    required this.facilitiesList,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.whiteColor,
      elevation: 3,
      shadowColor: AppColors.gray2Color,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalization.of(context).translate("facilities"),
                    style: AppTheme.headlineMedium,
                  ),
                  SizedBox(height: 10.h),
                  Container(
                      color: AppColors.whiteColor,
                      height: 120.h,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: facilitiesList.length,
                        itemBuilder: (context,index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 2.w),
                            padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 10.w),
                            decoration: BoxDecoration(
                              color: AppColors.lightGrayColor,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                    child: CachedImage(
                                      width: 45.w,
                                      height: 45.w,
                                      imageUrl: serverUrl + facilitiesList[index].icon!,
                                      fit: BoxFit.cover,
                                      borderRadius: 10.r,
                                    )
                                ),
                                SizedBox(height: 10.h),
                                Flexible(child: Text(facilitiesList[index].name!,
                                    style: AppTheme.labelLarge)),
                              ],
                            ),
                          );
                        },
                      )
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}