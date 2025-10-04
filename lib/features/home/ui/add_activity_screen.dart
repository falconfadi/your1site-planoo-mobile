import 'dart:io';
import 'package:centro_partner/core/constants/enum/session_duration_enum.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/shared_widgets/photos_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/select_multi_items_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/workdays_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/ui/widgets/custom_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/ui/widgets/custom_text_field.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/validators/base_validator.dart';
import 'package:centro_partner/core/utils/validators/required_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/core/utils/extension/text_field_ext.dart';
import 'package:centro_partner/core/utils/form_utils/form_state_mixin.dart';

class AddActivityScreen extends StatefulWidget {

  final bool? isEdit;

  const AddActivityScreen({super.key,this.isEdit = false});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen>  with FormStateMinxin {

  String selectCategory = "";
  Set<int> selectedFacilityIds = {};
  Set<String> selectedDays = {};
  SessionDurationEnum? selectedSession;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;
  List<File> photosList = <File>[];
  List<String> categoriesList = ["Football", "Basketball", "Tennis", "Padel", "Volleyball", "Handball", "Badminton", "Squash"];
  List<Facility> facilities = [Facility(1, "Wifi"), Facility(2, "Cafe"),Facility(3, "Pool")];

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
                    height: 60.h,
                    text: AppLocalization.of(context).translate("category"),
                    value: selectCategory.isEmpty ? null : selectCategory,
                    onChanged: (newValue) {
                      setState(() {
                        selectCategory = newValue;
                      });
                    },
                    items: categoriesList.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Row(
                          children: [
                            SizedBox(width: 8.w),
                            Expanded(child: Text(value, style: AppTheme.textTheme.labelLarge!.copyWith(fontSize: 18.sp))),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.h),
                  WorkdaysWidget(selectedDays: selectedDays, fromTime: fromTime, toTime: toTime),
                  SizedBox(height: 20.h),
                  CustomDropDown(
                    width: 1.sw,
                    height: 60.h,
                    text: AppLocalization.of(context).translate("session_duration"),
                    value: selectedSession,
                    onChanged: (newValue) {
                      setState(() {
                        selectedSession = newValue;
                      });
                    },
                    items: SessionDurationEnum.values.map((session) {
                      return DropdownMenuItem<SessionDurationEnum>(
                        value: session,
                        child: Row(
                          children: [
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                "${session.value} ${AppLocalization.of(context).translate("minute")}",
                                style: AppTheme.textTheme.labelLarge!.copyWith(fontSize: 18.sp),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
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
                    textEditingController: form.controllers[1],
                    labelText: AppLocalization.of(context).translate("price"),
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    autoFocus: false,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    focusNode: form.nodes[2],
                    textEditingController: form.controllers[2],
                    labelText: AppLocalization.of(context).translate("location"),
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
                  PhotosWidget(photos: photosList),
                  SizedBox(height: 20.h),
                  SelectMultiItemsWidget<Facility, int>(
                    title: AppLocalization.of(context).translate("facilities"),
                    list: facilities,
                    selectedIds: selectedFacilityIds,
                    labelBuilder: (item) => item.name,
                    idBuilder: (item) => item.id,
                    onSelect: (ids) {
                      setState(() {
                        selectedFacilityIds.addAll(ids);
                      });
                    },
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    children: [
                      Expanded(flex: 2,child: Center()),
                      Expanded(
                        child: CustomButton(
                          backgroundColor: AppColors.primaryColor,
                          borderRadius: 10.r,
                          buttonName: AppLocalization.of(context).translate("add"),
                        ),
                      ),
                    ]
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        )
    );
  }

  @override
  int numberOfFields() => 4;
}

class Facility {
  final int id;
  final String name;
  Facility(this.id, this.name);
}