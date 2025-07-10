import 'package:centro_partner/core/constants/enum/service_type.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_check_box.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/widgets/custom_drop_down.dart';
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

class CourtCreateActivityScreen extends StatefulWidget {

  bool? isEdit;

  CourtCreateActivityScreen({super.key,this.isEdit = false});

  @override
  State<CourtCreateActivityScreen> createState() => _CourtCreateActivityScreenState();
}

class _CourtCreateActivityScreenState extends State<CourtCreateActivityScreen>  with FormStateMinxin {

  ServiceType? selectServiceType;
  bool isActive = false;
  bool isTrial = false;
  bool? withAccount;
  bool isPrivate = false;

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
                    nextFocusNode: form.nodes[1],
                    textEditingController: form.controllers[0],
                    labelText: AppLocalization.of(context).translate("name"),
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
                    focusNode: form.nodes[1],
                    nextFocusNode: form.nodes[2],
                    textEditingController: form.controllers[1],
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
                    focusNode: form.nodes[2],
                    nextFocusNode: form.nodes[3],
                    textEditingController: form.controllers[2],
                    labelText: AppLocalization.of(context).translate("cancellation_cost"),
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
                    focusNode: form.nodes[3],
                    textEditingController: form.controllers[3],
                    labelText: AppLocalization.of(context).translate("description"),
                  ),
                  SizedBox(height: 20.h),
                  CustomDropDown(
                    width: 1.sw,
                    height: 56.h,
                    text: AppLocalization.of(context).translate("type"),
                    value: selectServiceType,
                    onChanged: (newValue) {
                      setState(() {
                        selectServiceType = newValue as ServiceType?;
                      });
                    },
                    items: ServiceType.values.map((ServiceType value) {
                      return DropdownMenuItem<ServiceType>(
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
                  if(widget.isEdit == false)
                    CustomCheckBox(
                      check: isActive,
                      text: AppLocalization.of(context).translate("activate"),
                      onChanged: (value) {
                        isActive = !isActive;
                        setState(() {});
                      },
                    ),
                  CustomCheckBox(
                    check: isTrial,
                    text: AppLocalization.of(context).translate("trial"),
                    onChanged: (value) {
                      setState(() {
                        isTrial = value ?? false;
                        if (!isTrial) {
                          withAccount = null;
                        } else {
                          withAccount = false;
                        }
                      });
                    },
                  ),
                  SizedBox(height: isTrial == true ? 20.h : 0),
                  isTrial ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              withAccount = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.5,
                                color: withAccount == false
                                    ? AppColors.primaryColor
                                    : AppColors.grayColor,
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(AppLocalization.of(context).translate("free"),
                              style: AppTheme.labelLarge),
                          ),
                        ),
                      ),
                      SizedBox(width: 20.h),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              withAccount = true;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.5,
                                color: withAccount == true
                                    ? AppColors.primaryColor
                                    : AppColors.grayColor,
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(AppLocalization.of(context).translate("discount"),
                                style: AppTheme.labelLarge),
                          ),
                        ),
                      ),
                    ],
                  ) : SizedBox.shrink(),
                  SizedBox(height: withAccount == true ? 25.h : 0),
                  withAccount == true ?
                  CustomTextField(
                    autoFocus: false,
                    keyboardType: TextInputType.number,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return BaseValidator.validateValue(
                        context,
                        value!,
                        [RequiredValidator()],
                      );
                    },
                    focusNode: form.nodes[4],
                    textEditingController: form.controllers[4],
                    labelText: AppLocalization.of(context).translate("discount"),
                  ) : SizedBox.shrink(),
                  SizedBox(height: isTrial == false ? 0 : 10.h),
                  CustomCheckBox(
                    check: isPrivate,
                    text: AppLocalization.of(context).translate("private"),
                    onChanged: (isChecked) {
                      setState(() {
                        isPrivate = isChecked ?? false;
                      });
                    },
                  ),
                  SizedBox(height: 20.h),
                  isPrivate == true ?
                  CustomTextField(
                    autoFocus: false,
                    keyboardType: TextInputType.number,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return BaseValidator.validateValue(
                        context,
                        value!,
                        [RequiredValidator()],
                      );
                    },
                    focusNode: form.nodes[5],
                    textEditingController: form.controllers[5],
                    labelText: AppLocalization.of(context).translate("private_cost"),
                  ) : SizedBox.shrink(),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ),
        )
    );
  }

  @override
  int numberOfFields() => 6;
}
