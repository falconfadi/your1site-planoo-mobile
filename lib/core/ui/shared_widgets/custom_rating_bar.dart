import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRatingBar extends StatelessWidget {

  final double rate;
  final double? size;
  final IconData? iconData;

  CustomRatingBar({required this.rate,this.size,this.iconData});

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rate,
      minRating: 1,
      glowColor: AppColors.whiteColor,
      ignoreGestures: false,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: size ?? 25.w,
      unratedColor: AppColors.gray2Color,
      itemPadding: EdgeInsets.symmetric(horizontal: 0.w),
      itemBuilder: (context, _) => Icon(
        iconData ?? Icons.star_border_purple500,
        color: AppColors.yellowColor,
      ),
      onRatingUpdate: (rating) {},
    );
  }
}