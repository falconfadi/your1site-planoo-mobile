import 'dart:io';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/ui/widgets/cached_image.dart';
import 'package:centro_partner/core/ui/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewImageWidget extends StatelessWidget {

  final String? image;
  final double? width;
  final double? height;
  final bool? isFile;
  final File? file;
  final double? borderRadius;

  const ViewImageWidget({super.key,
    this.image,
    this.width,
    this.height,
    this.isFile = false,
    this.file,
    this.borderRadius
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showAnimatedDialog(
          context,
          Center(
            child: isFile == true ?
            Container(
              width: 1.sw,
              height: 300.w,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(file!),
                    fit: BoxFit.cover,
                  )
              ),
            ) : CachedImage(
              imageUrl: image!,
              width: 1.sw,
              height: 300.w,
              fit: BoxFit.cover,

            )
          ),
          dismissible: true,
        );
      },
      child: isFile == true ?
      Container(
        width: 100.w,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(file!),
            fit: BoxFit.cover,
          )
        ),
      ) :
      CachedImage(
        imageUrl: image!,
        width: width ?? 100.w,
        height: height ?? 100.w,
        fit: BoxFit.cover,
        borderColor: AppColors.grayColor,
        borderWidth: 1,
        borderRadius: borderRadius,
      ),
    );
  }
}
