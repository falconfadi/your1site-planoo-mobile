import 'dart:io';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/enum/course_type.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_check_box.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_image_edit_button.dart';
import 'package:centro_partner/core/ui/widgets/custom_drop_down.dart';
import 'package:centro_partner/core/utils/project_utils/pick_image.dart';
import 'package:centro_partner/features/home/widget/view_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/ui/widgets/custom_text_field.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/validators/base_validator.dart';
import 'package:centro_partner/core/utils/validators/required_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/core/utils/extension/text_field_ext.dart';
import 'package:centro_partner/core/utils/form_utils/form_state_mixin.dart';

class CreateCourseScreen extends StatefulWidget {

  bool? isEdit;

  CreateCourseScreen({super.key,this.isEdit = false});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen>  with FormStateMinxin {

  File? photo;
  CourseType? selectLessonType;
  bool isGroup = false;
  bool isOutdoor = false;

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
                  Stack(
                    children: [
                      ViewImageWidget(image: photo == null ? profileHolder :  photo!.path),
                      Positioned(
                        bottom: 0,
                        right: 5.w,
                        child: InkWell(
                          onTap: () async {
                            await PickImage.selectImage(image: photo);
                          },
                          child: CustomImageEditButton()
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  CustomTextField(
                    autoFocus: false,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      return BaseValidator.validateValue(
                        context,
                        value!,
                        [RequiredValidator()],
                      );
                    },
                    focusNode: form.nodes[0],
                    textEditingController: form.controllers[0],
                    labelText: AppLocalization.of(context).translate("name"),
                  ),
                  SizedBox(height: 20.h),
                  CustomDropDown(
                    width: 1.sw,
                    height: 56.h,
                    text: AppLocalization.of(context).translate("type"),
                    value: selectLessonType,
                    onChanged: (newValue) {
                      setState(() {
                        selectLessonType = newValue as CourseType?;
                      });
                    },
                    items: CourseType.values.map((CourseType value) {
                      return DropdownMenuItem<CourseType>(
                        value: value,
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            Text(AppLocalization.of(context).translate(value.name), style: AppTheme.labelMedium),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    autoFocus: false,
                    maxLine: 3,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return BaseValidator.validateValue(
                        context,
                        value!,
                        [RequiredValidator()],
                      );
                    },
                    focusNode: form.nodes[1],
                    textEditingController: form.controllers[1],
                    labelText: AppLocalization.of(context).translate("description"),
                  ),
                  SizedBox(height: 10.h),
                  CustomCheckBox(
                    check: isGroup,
                    text: AppLocalization.of(context).translate("multiple_participants"),
                    onChanged: (value) {
                      isGroup = !isGroup;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: isGroup == true ? 10.h : 0),
                  if(isGroup == true)
                    CustomTextField(
                      autoFocus: false,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        return BaseValidator.validateValue(
                          context,
                          value!,
                          [RequiredValidator()],
                        );
                      },
                      focusNode: form.nodes[2],
                      textEditingController: form.controllers[2],
                      labelText: AppLocalization.of(context).translate("capacity"),
                    ),
                  SizedBox(height: isGroup == true ? 20.h : 10.h),
                  CustomTextField(
                    autoFocus: false,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      return BaseValidator.validateValue(
                        context,
                        value!,
                        [RequiredValidator()],
                      );
                    },
                    focusNode: form.nodes[3],
                    textEditingController: form.controllers[3],
                    labelText: AppLocalization.of(context).translate("cost"),
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    autoFocus: false,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      return BaseValidator.validateValue(
                        context,
                        value!,
                        [RequiredValidator()],
                      );
                    },
                    focusNode: form.nodes[4],
                    textEditingController: form.controllers[4],
                    labelText: AppLocalization.of(context).translate("cancellation_cost"),
                  ),
                  SizedBox(height: 20.h),
                  CustomCheckBox(
                    check: isOutdoor,
                    text: AppLocalization.of(context).translate("outdoor"),
                    onChanged: (value) {
                      isOutdoor = !isOutdoor;
                      setState(() {});
                    },
                  ),
                  // todo add later the location
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
        )
    );
  }

  @override
  int numberOfFields() => 5;
}
