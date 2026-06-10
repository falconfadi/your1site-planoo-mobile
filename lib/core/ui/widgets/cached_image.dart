import 'package:cached_network_image/cached_network_image.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/ui/widgets/loading.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final bool? errorForUser;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    required this.fit,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.errorForUser = false
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: borderWidth ?? 0,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: fit,
            height: height,
            width: width,
            placeholder: (context, url) => const Center(child: LoadingIndicator()),
            errorWidget: (context, url, error) => Icon(
                errorForUser! ? Icons.person : Icons.image_not_supported_outlined,color: AppColors.grayColor,
              size: isTablet ? 30.sp : null,
            ),
          ),
        ),
      ),
    );
  }
}
