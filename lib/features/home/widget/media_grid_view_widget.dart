import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/home/data/model/media_model.dart';
import 'package:centro_partner/features/home/ui/media_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_grid/responsive_grid.dart';

class MediaGridViewWidget extends StatelessWidget {

  final List<MediaModel> mediaList;

  const MediaGridViewWidget({super.key, required this.mediaList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: ResponsiveGridList(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        desiredItemWidth: 80.w,
        minSpacing: 5,
        children: mediaList.map((i) {
          return GestureDetector(
            onTap: () {
              Navigation.push(MediaViewerScreen(media: i));
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grayColor,
                    spreadRadius: 0,
                    blurRadius: 3,
                    offset: const Offset(0, 0),
                  )
                ],
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: i.type == 'image'
                    ? Image.network(i.url, fit: BoxFit.cover)
                    : Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(i.thumbnailUrl ?? i.url, fit: BoxFit.cover),
                    Center(
                      child: Icon(Icons.play_circle, color: AppColors.whiteColor, size: 25),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
