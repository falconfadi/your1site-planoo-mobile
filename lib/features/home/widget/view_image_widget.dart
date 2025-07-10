import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/ui/widgets/cached_image.dart';
import 'package:centro_partner/core/ui/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewImageWidget extends StatelessWidget {

  String image;
  double? width;
  double? height;
  double? borderRadius;

  ViewImageWidget({super.key,
    required this.image,
    this.width,
    this.height,
    this.borderRadius
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showAnimatedDialog(
          context,
          Center(
            child: Container(
              width: 1.sw,
              height: 300.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      image ?? profileHolder
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          dismissible: true,
        );
      },
      child: CachedImage(
        imageUrl: image,
        width: width ?? 150.w,
        height: height ?? 150.w,
        fit: BoxFit.cover,
        borderColor: AppColors.whiteColor,
        borderWidth: 1,
        borderRadius: borderRadius ?? 100.r,
      ),
    );
  }
}
