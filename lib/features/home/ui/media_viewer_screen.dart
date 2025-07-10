import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_texts_widget.dart';
import 'package:centro_partner/core/ui/widgets/coustom_sheet.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/ui/widgets/custom_dialog.dart';
import 'package:centro_partner/core/ui/widgets/loading.dart';
import 'package:centro_partner/core/utils/validators/convert_date.dart';
import 'package:centro_partner/features/home/data/model/media_model.dart';
import 'package:centro_partner/features/home/widget/edit_media_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class MediaViewerScreen extends StatefulWidget {

  final MediaModel media;

  MediaViewerScreen({required this.media});

  @override
  State<MediaViewerScreen> createState() => _MediaViewerScreenState();
}

class _MediaViewerScreenState extends State<MediaViewerScreen> {

  late VideoPlayerController controller;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    if (widget.media.type == "video") {
      controller = VideoPlayerController.network(widget.media.url)
        ..initialize().then((_) {
          setState(() {});
          controller.play();
          isPlaying = true;
        });
    }
  }

  @override
  void dispose() {
    if (widget.media.type == "video") {
      controller.dispose();
    }
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (controller.value.isPlaying) {
        controller.pause();
        isPlaying = false;
      } else {
        controller.play();
        isPlaying = true;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomHeader(title: "", isNavBar: false),
      body: SizedBox(
        height: 1.sh,
        child: Stack(
          children: [
            SizedBox(
              width: 1.sw,
              height: 1.sh - 240.h,
              child: widget.media.type == 'image'
                  ? Image.network(widget.media.url, fit: BoxFit.contain)
                  : controller.value.isInitialized
                ? Column(
                  children: [
                    Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 1.sh - 300.h,
                        child: GestureDetector(
                          child: AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: VideoPlayer(controller),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: IconButton(
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black45,
                            ),
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          onPressed: _togglePlayPause,
                        ),
                      ),
                    ],
                    ),
                    VideoProgressIndicator(controller, allowScrubbing: true,colors: const VideoProgressColors(playedColor: AppColors.redColor),),
                  ],
                ) : Center(child: LoadingIndicator())
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: SizedBox(
                height: 140.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                        width: 100.w,
                        height: 100,
                        backgroundColor: AppColors.whiteColor,
                        borderRadius: 0,
                        icon: delete,
                        iconColor: AppColors.blackColor,
                        buttonName: null,
                        function: () =>
                            Dialogs.showQuestion(context,
                              title: "", content: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      "${AppLocalization.of(context).translate(
                                          "are_you_sure")}?",
                                      textAlign: TextAlign.center,
                                      style: AppTheme.titleSmall.copyWith(
                                          color: AppColors.mediumGrayColor),
                                    ),
                                  ),
                                ],
                              ),
                              btnOk: CustomButton(
                                height: 40.h,
                                width: 1.sw,
                                backgroundColor: AppColors.whiteColor,
                                borderRadius: 8.r,
                                buttonName: AppLocalization
                                    .of(context)
                                    .translate("ok"),
                                textStyle: AppTheme.titleSmall.copyWith(
                                    fontSize: 15, color: AppColors.blackColor),
                              ),
                            )
                    ),
                    CustomButton(
                      width: 100.w,
                      backgroundColor: AppColors.whiteColor,
                      borderRadius: 0,
                      icon: about,
                      iconColor: AppColors.blackColor,
                      buttonName: null,
                      function: () =>
                          showAnimatedDialog(
                            context,
                            Center(
                              child: Material(
                                color: AppColors.whiteColor,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 20.h),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomTextsWidget(
                                        title: AppLocalization
                                            .of(context)
                                            .translate("details"),
                                        titleStyle: AppTheme.titleSmall
                                            .copyWith(
                                            color: AppColors.primaryColor),
                                      ),
                                      SizedBox(height: 20.h),
                                      CustomTextsWidget(
                                        title: "${AppLocalization
                                            .of(context)
                                            .translate("name")}:",
                                        text: widget.media.name,
                                      ),
                                      SizedBox(height: 10.h),
                                      CustomTextsWidget(
                                        title: "${AppLocalization
                                            .of(context)
                                            .translate("taken_on")}:",
                                        text: convertDate(
                                            date: widget.media.createdAt
                                                .toString()),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            dismissible: true,
                          ),
                    ),
                    // CustomButton(
                    //   width: 100.w,
                    //   height: 100,
                    //   backgroundColor: AppColors.whiteColor,
                    //   borderRadius: 0,
                    //   icon: edit,
                    //   iconColor: AppColors.blackColor,
                    //   buttonName: null,
                    //   function: () => CustomSheet.show(
                    //       isDismissible: true,
                    //       header: Text(""),
                    //       padding: 30.w,
                    //       context: context,
                    //       child: EditMediaSheet()),
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

