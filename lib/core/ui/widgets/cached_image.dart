import 'package:cached_network_image/cached_network_image.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/ui/widgets/loading.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double? borderRadius;
  final Color? borderColor;
  final double? borderWidth;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    required this.fit,
    this.borderRadius,
    this.borderColor,
    this.borderWidth
  });

  @override
  Widget build(BuildContext context) {
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
            errorWidget: (context, url, error) => Image.asset(
              profileHolder,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
