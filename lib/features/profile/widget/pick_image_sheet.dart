import 'dart:io';
import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/utils/project_utils/pick_image.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:centro_partner/features/auth/data/model/sign_in_model.dart';
import 'package:centro_partner/features/profile/data/model/profile_image_model.dart';
import 'package:centro_partner/features/profile/data/profile_repository/profile_repository.dart';
import 'package:centro_partner/features/profile/data/usecase/upload_profile_image_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/ui/dialogs/dialogs.dart';

class PickImageSheet extends StatefulWidget {

  VoidCallback onImageUpdated;
  SignInModel? model;

  PickImageSheet({required this.onImageUpdated, super.key,  this.model});

  @override
  State<PickImageSheet> createState() => _PickImageSheetState();
}

class _PickImageSheetState extends State<PickImageSheet> {

  File? image;

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildPickOption(
              icon: Icons.image_outlined,
              labelKey: "gallery",
              source: ImageSource.gallery,
              isTablet: isTablet
            ),
            _buildPickOption(
              icon: Icons.camera_alt_outlined,
              labelKey: "camera",
              source: ImageSource.camera,
              isTablet: isTablet
            ),
          ],
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildPickOption({required IconData icon, required String labelKey, required ImageSource source,bool? isTablet}) {
    return CreateModel<ProfileImageModel>(
      withValidation: false,
      onTap: () async {},
      onSuccess: (data) {
        widget.onImageUpdated();
        Navigator.pop(context);
      },
      useCaseCallBack: (data) async {
        image = await PickImage.selectImage(imageSource: source);

        if (image == null) {
          return Future.value();
        }

        return UploadProfileImageUseCase(ProfileRepository()).call(
          params: UploadProfileImageParams(file: image!),
        );
      },
      child: Column(
        children: [
          Container(
            width: isTablet! ? 50.w : 60.w,
            height: isTablet ? 50.w : 60.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.turquoiseColor,
            ),
            child: Center(
              child: Icon(icon, size: isTablet ? 25.sp : 30, color: AppColors.whiteColor),
            ),
          ),
          SizedBox(height: 10.h),
          Center(
            child: Text(
              AppLocalization.of(context).translate(labelKey),
              style: AppTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }
}


