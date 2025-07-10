import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/features/home/data/model/group_model.dart';
import 'package:centro_partner/features/home/widget/media_grid_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupGalleryScreen extends StatelessWidget {

  final GroupModel group;

  GroupGalleryScreen({Key? key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomHeader(title: "",isNavBar: false),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 30.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(group.name,style: AppTheme.labelLarge),
            ),
            SizedBox(height: 20.h),
            MediaGridViewWidget(mediaList: group.media),
          ],
        )
      ),
    );
  }
}