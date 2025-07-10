import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/constants/enum/media_enum.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/features/home/data/model/group_model.dart';
import 'package:centro_partner/features/home/data/model/media_model.dart';
import 'package:centro_partner/features/home/widget/group_grid_view_widget.dart';
import 'package:centro_partner/features/home/widget/media_grid_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final List<GroupModel> dummyGroups = [
  GroupModel(
    id: 'group1',
    name: 'Vacation 2025',
    media: [
      MediaModel(
        id: 'img1',
        name: 'Beach Sunset',
        url: 'https://gravatar.com/avatar/b351f672f27b79df181d33697685028c?s=400&d=robohash&r=x',
        thumbnailUrl: null,
        type: 'image',
        size: 1.5,
        createdAt: DateTime(2025, 7, 1),
      ),
      MediaModel(
        id: 'vid1',
        name: 'Waves',
        url: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
        thumbnailUrl: 'https://gravatar.com/avatar/b351f672f27b79df181d33697685028c?s=400&d=robohash&r=x',
        type: 'video',
        size: 12.3,
        createdAt: DateTime(2025, 7, 1),
      ),
    ],
  ),
  GroupModel(
    id: 'group2',
    name: 'Work Projects',
    media: [
      MediaModel(
        id: 'img2',
        name: 'Presentation',
        url: 'https://gravatar.com/avatar/b351f672f27b79df181d33697685028c?s=400&d=robohash&r=x',
        thumbnailUrl: null,
        type: 'image',
        size: 0.9,
        createdAt: DateTime(2025, 6, 20),
      ),
    ],
  ),
  GroupModel(
    id: 'group3',
    name: 'Test',
    media: [
      MediaModel(
        id: 'img2',
        name: 'Presentation',
        url: 'https://gravatar.com/avatar/b351f672f27b79df181d33697685028c?s=400&d=robohash&r=x',
        thumbnailUrl: null,
        type: 'image',
        size: 0.9,
        createdAt: DateTime(2025, 6, 20),
      ),
    ],
  ),
];

final List<MediaModel> dummyMedia = [
  MediaModel(
    id: 'img1',
    name: 'Sunset at Beach',
    url: 'https://gravatar.com/avatar/b351f672f27b79df181d33697685028c?s=400&d=robohash&r=x',
    thumbnailUrl: null,
    type: 'image',
    size: 1.2,
    createdAt: DateTime(2025, 7, 1),
  ),
  MediaModel(
    id: 'img2',
    name: 'Mountain View',
    url: 'https://gravatar.com/avatar/b351f672f27b79df181d33697685028c?s=400&d=robohash&r=x',
    thumbnailUrl: null,
    type: 'image',
    size: 2.1,
    createdAt: DateTime(2025, 6, 28),
  ),
  MediaModel(
    id: 'vid1',
    name: 'Wave Video',
    url: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
    thumbnailUrl: 'https://gravatar.com/avatar/b351f672f27b79df181d33697685028c?s=400&d=robohash&r=x',
    type: 'video',
    size: 10.5,
    createdAt: DateTime(2025, 6, 25),
  ),
  MediaModel(
    id: 'vid2',
    name: 'Drone Flight',
    url: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
    thumbnailUrl: 'https://gravatar.com/avatar/b351f672f27b79df181d33697685028c?s=400&d=robohash&r=x',
    type: 'video',
    size: 18.7,
    createdAt: DateTime(2025, 6, 22),
  ),
];


class AllMediaScreen extends StatefulWidget {

  @override
  State<AllMediaScreen> createState() => _AllMediaScreenState();
}

class _AllMediaScreenState extends State<AllMediaScreen> {

  MediaEnum selectedFilter = MediaEnum.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomHeader(title: "",isNavBar: false),
      body: Column(
        children: [
          SizedBox(height: 20.h),
          SizedBox(
            height: 40.h,
            child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: MediaEnum.values.length,
                itemBuilder: (context,index) {
                  final label = MediaEnum.values[index].name;
                  return GestureDetector(
                    onTap: () => setState(() => selectedFilter = MediaEnum.values[index]),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      decoration: BoxDecoration(
                        // color: Colors.red,
                        border: Border(
                          bottom: BorderSide(width: 1.5, color: selectedFilter == MediaEnum.values[index] ?
                          Colors.blue : Colors.white),
                        ),
                      ),
                      child: Center(child: Text(AppLocalization.of(context).translate(label),
                      style: AppTheme.labelMedium))
                    ),
                  );
                }
            ),
          ),
          SizedBox(height: 30.h),
          Expanded(child: _mediaContent()),
        ],
      ),
    );
  }

  Widget _mediaContent() {
    switch (selectedFilter) {
      // case MediaEnum.groups:
      //   return GroupGridViewWidget(groupList: dummyGroups);
      case MediaEnum.images:
        return MediaGridViewWidget(
          mediaList: dummyMedia.where((m) => m.type == 'image').toList(),
        );
      case MediaEnum.videos:
        return MediaGridViewWidget(
          mediaList: dummyMedia.where((m) => m.type == 'video').toList(),
        );
      default:
        return MediaGridViewWidget(
          mediaList: dummyMedia,
        );
    }
  }
}
