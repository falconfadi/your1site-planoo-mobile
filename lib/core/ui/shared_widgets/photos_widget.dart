import 'dart:io';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_container_info_widget.dart';
import 'package:centro_partner/features/home/widget/view_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class PhotosWidget extends StatefulWidget {

  final List<File> photos;

  const PhotosWidget({super.key,required this.photos});

  @override
  State<PhotosWidget> createState() => _PhotosWidgetState();
}

class _PhotosWidgetState extends State<PhotosWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: () => selectImage(),
            child: CustomContainerInfoWidget(title:AppLocalization.of(context).translate("photos"),
            ),
          ),
          SizedBox(height: widget.photos.isEmpty ? 0 : 20.h),
          widget.photos.isEmpty ? const Center() :
          Container(
            height: 100.w,
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.photos.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Stack(
                    children: [
                      ViewImageWidget(
                        width: 100.w,
                        height: 100.w,
                        isFile: true,
                        file: widget.photos[index],
                      ),
                      Positioned(
                        top: 5.h,
                        right: 5.w,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              widget.photos.removeAt(index);
                            });
                          },
                          child: SvgPicture.asset(delete,width: 24.w,color: AppColors.redColor,)
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: widget.photos.isEmpty ? 0 : 20.h),
        ],
      ),
    );
  }

  void selectImage() async {
    final imagePicker = ImagePicker();
    final List<XFile> result = await imagePicker.pickMultiImage(imageQuality: 25);
    if (result.isNotEmpty) {
      setState(() {
        widget.photos.addAll(result.map((e) => File(e.path)));
      });
    }
  }
}
