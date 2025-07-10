import 'dart:io';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/features/home/widget/file_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/ui/widgets/custom_text_field.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/core/utils/extension/text_field_ext.dart';
import 'package:centro_partner/core/utils/form_utils/form_state_mixin.dart';
import 'package:image_picker/image_picker.dart';

class CreateMediaScreen extends StatefulWidget {

  CreateMediaScreen({super.key});

  @override
  State<CreateMediaScreen> createState() => _CreateMediaScreenState();
}

class _CreateMediaScreenState extends State<CreateMediaScreen>  with FormStateMinxin {

  List<File> mediaList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: CustomHeader(
          title: "",
          isNavBar: false,
          leading: IconButton(
            icon: Icon(Icons.close),
            color: AppColors.blackColor,
            onPressed: () {
              Navigation.pop();
            },
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Text(AppLocalization.of(context).translate("save"),
                      style: AppTheme.titleSmall.copyWith(color: AppColors.primaryColor)),
                ],
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: form.key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),
                  // CustomTextField(
                  //   autoFocus: false,
                  //   autoValidateMode: AutovalidateMode.onUserInteraction,
                  //   keyboardType: TextInputType.text,
                  //   focusNode: form.nodes[0],
                  //   textEditingController: form.controllers[0],
                  //   labelText: AppLocalization.of(context).translate("group_name"),
                  // ),
                  // SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomButton(
                          icon: camera,
                          iconColor: AppColors.primaryColor,
                          backgroundColor: AppColors.whiteColor,
                          borderSideColor: AppColors.primaryColor,
                          borderRadius: 10.r,
                          textStyle: AppTheme.labelSmall.copyWith(fontSize: 12, color: AppColors.blackColor),
                          buttonName: AppLocalization.of(context).translate("photo"),
                          function: () {
                            selectImage(imageSource: ImageSource.gallery, fileType: "image");
                          },
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: CustomButton(
                          icon: video,
                          iconColor: AppColors.darkPurpleColor,
                          backgroundColor: AppColors.whiteColor,
                          borderSideColor: AppColors.darkPurpleColor,
                          borderRadius: 10.r,
                          textStyle: AppTheme.labelSmall.copyWith(fontSize: 12, color: AppColors.blackColor),
                          buttonName: AppLocalization.of(context).translate("video"),
                          function: () {
                            selectImage(imageSource: ImageSource.gallery, fileType: "video");
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Wrap(
                    runSpacing: 30.h,
                    spacing: 30.w,
                    children: mediaList.map((file) {
                      return FileItemWidget(
                        file: file,
                        deleteItem: () {
                          mediaList.remove(file);
                          setState(() {});
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        )
    );
  }

  void selectImage({required ImageSource imageSource, required String fileType}) async {
    final imagePicker = ImagePicker();

    if (fileType == "image") {
      final List<XFile>? result = await imagePicker.pickMultiImage(imageQuality: 25);
      if (result != null && result.isNotEmpty) {
        setState(() {
          mediaList.addAll(result.map((e) => File(e.path)));
        });
      }
    } else if (fileType == "video") {
      final XFile? result = await imagePicker.pickVideo(source: imageSource);
      if (result != null) {
        setState(() {
          mediaList.add(File(result.path));
        });
      }
    }
  }

  @override
  int numberOfFields() => 1;
}
