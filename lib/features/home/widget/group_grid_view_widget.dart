import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/home/data/model/group_model.dart';
import 'package:centro_partner/features/home/ui/group_gallery_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_grid/responsive_grid.dart';


class GroupGridViewWidget extends StatelessWidget {

  List<GroupModel> groupList = <GroupModel>[];

  GroupGridViewWidget({super.key,required this.groupList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: ResponsiveGridList(
          shrinkWrap: true,
          desiredItemWidth: 150.w,
          minSpacing: 10,
          children: groupList.map((i) {
            return GestureDetector(
              onTap: () {
                Navigation.push(GroupGalleryScreen(group: i));
              },
              child: Container(
                height: 180.h,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.grayColor,
                        spreadRadius: 0,
                        blurRadius: 3,
                        offset: const Offset(0,0)
                    )
                  ],
                ),
                child: Column(
                  children: [
                    i.coverImageUrl != null ?
                    Image.network(i.coverImageUrl!,height: 100.w, fit: BoxFit.cover)
                        : Icon(Icons.folder),
                    SizedBox(height: 5.h),
                    Container(
                      width: 150.w,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(i.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme.bodyMedium),
                          Text('${i.media.length}',
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.labelSmall.copyWith(color: AppColors.primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList()
      ),
    );
  }
}