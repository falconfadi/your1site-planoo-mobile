import 'dart:io';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';

// todo check later after binding with apis
class FileItemWidget extends StatefulWidget {

  File? file;
  final Function deleteItem;

  FileItemWidget({
    ValueKey? key,
    this.file,
    required this.deleteItem,
  }) : super(key: key);

  @override
  State<FileItemWidget> createState() => _FileItemWidgetState();
}

class _FileItemWidgetState extends State<FileItemWidget> {

  late VideoPlayerController _controller;
  bool _isPlaying = false;
  String extension = "";

  @override
  void initState() {
    super.initState();
    extension = widget.file!.path.split('.').last.toLowerCase();
    if(extension == "mp4") {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.file!.path))
        ..addListener(() {
          final bool isPlaying = _controller.value.isPlaying;
          if (isPlaying != _isPlaying) {
            setState(() {
              _isPlaying = isPlaying;
            });
          }
        })
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (extension == "mp4") {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.r),
      child: Container(
        color: AppColors.lightGrayColor,
        height: 80.w,
        width: 80.w,
        child: Stack(
          children: [
            ///image
            extension == "jpg" || extension == "png" ?
            Image.file(widget.file!,fit: BoxFit.fill, width: 150.w, height: 150.w) :
            ///video
            extension == "mp4" ? _controller.value.isInitialized ? Stack(
              fit: StackFit.expand,
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                InkWell(
                  onTap: () {
                    if (_isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                    setState(() {});
                  },
                  child: Icon(
                    _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: AppColors.whiteColor,
                  ),
                ),
              ],
            ) : Container() : Container(),
            Padding(
              padding: EdgeInsets.only(right: 5.h, bottom: 5.h),
              child: Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    widget.deleteItem.call();
                  },
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppColors.whiteColor,
                    ),
                    child: SvgPicture.asset(cancel, color: AppColors.blackColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
