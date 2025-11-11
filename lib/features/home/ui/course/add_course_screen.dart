import 'dart:io';
import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_container_info_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/features/home/data/model/course/course_details_model.dart';
import 'package:centro_partner/features/home/data/model/course/course_model.dart';
import 'package:centro_partner/features/home/data/model/course_duration_model.dart';
import 'package:centro_partner/features/home/data/usecase/course/create_course_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/course/edit_course_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/workday/course_durations_usecase.dart';
import 'package:centro_partner/features/home/widget/facilities_widget.dart';
import 'package:centro_partner/features/home/widget/photos_widget.dart';
import 'package:centro_partner/features/home/widget/workdays_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/ui/widgets/custom_drop_down.dart';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/category_model.dart';
import 'package:centro_partner/features/home/data/model/location_model.dart';
import 'package:centro_partner/features/home/data/model/session_duration_model.dart';
import 'package:centro_partner/features/home/data/usecase/categories_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/session_durations_usecase.dart';
import 'package:centro_partner/features/home/ui/create_location_screen.dart';
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

class AddCourseScreen extends StatefulWidget {

  final bool? isEdit;
  final CourseDetailsModel? course;
  final VoidCallback? onRefresh;

  const AddCourseScreen({super.key,this.isEdit = false,this.course,this.onRefresh});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> with FormStateMinxin {

  CategoryInfoModel? selectCategory;
  Set<String> selectedDays = {};
  String? fromTime;
  String? toTime;
  int? selectedSession;
  int? selectedCourseDuration;
  LocationModel? selectedLocation;
  Set<int> selectedFacilitiesId = {};
  List<File> photosList = <File>[];

  @override
  void initState() {
    super.initState();
    if(widget.isEdit == true) {
      form.controllers[0].text = widget.course!.name!;
      form.controllers[1].text = widget.course!.price.toString();
      form.controllers[2].text = widget.course!.capacity.toString();
      form.controllers[3].text = widget.course!.cancellationFee.toString();
      form.controllers[4].text = widget.course!.description!;
      selectedSession = widget.course!.sessionDuration;
      selectedCourseDuration = widget.course!.courseDuration;
      selectedLocation = widget.course!.location!;
      selectedFacilitiesId = widget.course!.facilitiesList!.map((f) => f.ID!).toSet();
    }
  }

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
                  GetModel<CategoryModel>(
                    useCaseCallBack: () {
                      return CategoriesUseCase(HomeRepository()).call(params: CategoriesParams());
                    },
                    onSuccess: (result) {
                      if(widget.isEdit == true) {
                        selectCategory = result.categoriesList?.firstWhere(
                              (cat) => cat.ID == widget.course!.category!.ID,
                          orElse: () => result.categoriesList!.first,
                        );
                      }
                    },
                    modelBuilder: (model) => CustomDropDown(
                      width: 1.sw,
                      height: 60.h,
                      text: AppLocalization.of(context).translate("category"),
                      value: selectCategory,
                      onChanged: (newValue) {
                        setState(() {
                          selectCategory = newValue;
                        });
                      },
                      items: model.categoriesList!.map((CategoryInfoModel value) {
                        return DropdownMenuItem<CategoryInfoModel>(
                          value: value,
                          child: Row(
                            children: [
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  value.name ?? '',
                                  style: AppTheme.labelLarge.copyWith(fontSize: 18.sp),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  if(widget.isEdit == false) SizedBox(height: 20.h),
                  if(widget.isEdit == false)
                    WorkdaysWidget(
                      selectedDays: selectedDays,
                      fromTime: fromTime,
                      toTime: toTime,
                      onFromTimeChanged: (time) {
                        setState(() => fromTime = time);
                      },
                      onToTimeChanged: (time) {
                        setState(() => toTime = time);
                      },
                    ),
                  SizedBox(height: 20.h),
                  GetModel<CourseDurationModel>(
                    useCaseCallBack: () {
                      return CourseDurationsUseCase(HomeRepository())
                          .call(params: CourseDurationsParams());
                    },
                    modelBuilder: (model) => CustomDropDown(
                      width: 1.sw,
                      height: 60.h,
                      text: AppLocalization.of(context).translate("course_duration"),
                      value: selectedCourseDuration,
                      onChanged: (newValue) {
                        setState(() {
                          selectedCourseDuration = newValue;
                        });
                      },
                      items: model.courseDurationsList!.map((duration) {
                        return DropdownMenuItem<int>(
                          value: duration,
                          child: Row(
                            children: [
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  "$duration ${AppLocalization.of(context).translate("day")}",
                                  style: AppTheme.labelLarge.copyWith(fontSize: 18.sp),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  GetModel<SessionDurationModel>(
                    useCaseCallBack: () {
                      return SessionDurationsUseCase(HomeRepository())
                          .call(params: SessionDurationsParams());
                    },
                    modelBuilder: (model) => CustomDropDown(
                      width: 1.sw,
                      height: 60.h,
                      text: AppLocalization.of(context).translate("session_duration"),
                      value: selectedSession,
                      onChanged: (newValue) {
                        setState(() {
                          selectedSession = newValue;
                        });
                      },
                      items: model.durationsList!.map((duration) {
                        return DropdownMenuItem<int>(
                          value: duration,
                          child: Row(
                            children: [
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  "$duration ${AppLocalization.of(context).translate("minute")}",
                                  style: AppTheme.labelLarge.copyWith(fontSize: 18.sp),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
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
                    focusNode: form.nodes[3],
                    textEditingController: form.controllers[3],
                    labelText: AppLocalization.of(context).translate("cancellation_fee"),
                  ),
                  SizedBox(height: 20.h),
                  InkWell(
                    onTap: () async {
                      final result = await Navigation.push(
                        CreateLocationScreen(
                          ownerType: widget.isEdit == true ? "course" : null,
                          ownerId: widget.isEdit == true ? widget.course!.iD! : null,
                          location: selectedLocation,
                          isEdit: widget.isEdit == true ? true : false,
                        ),
                      );
                      if (result != null && result is LocationModel) {
                        setState(() {
                          selectedLocation = result;
                        });
                      }
                    },
                    child: CustomContainerInfoWidget(
                      title: selectedLocation == null ? AppLocalization.of(context).translate("location") :
                      "${selectedLocation!.lat!.toStringAsFixed(6)} | ${selectedLocation!.long!.toStringAsFixed(6)}",
                      textStyle: selectedLocation == null ? null : AppTheme.labelLarge.copyWith(fontSize: 18.sp),
                    ),
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
                    focusNode: form.nodes[4],
                    textEditingController: form.controllers[4],
                    labelText: AppLocalization.of(context).translate("description"),
                  ),
                  SizedBox(height: 20.h),
                  PhotosWidget(
                    ownerType: widget.isEdit == true ? "course" : null,
                    ownerId: widget.isEdit == true ? widget.course!.iD! : null,
                    photos: photosList,
                    isEdit: widget.isEdit == true ? true : false,
                  ),
                  SizedBox(height: 20.h),
                  FacilitiesWidget(
                    ownerType: widget.isEdit == true ? "course" : null,
                    ownerId: widget.isEdit == true ? widget.course!.iD! : null,
                    selectedFacilitiesId: selectedFacilitiesId,
                    isEdit: widget.isEdit == true ? true : false,
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    children: [
                      Expanded(flex: 2,child: Center()),
                      Expanded(
                        child: CreateModel(
                          withValidation: true,
                          onTap: () {
                            bool isValid = form.validate();
                            if (!isValid) return false;
                            if (widget.isEdit == false) {
                              if (selectCategory == null) {
                                Dialogs.showSnackBar(context: context, message: AppLocalization.of(context).translate("category_required"));
                                return false;
                              }
                              if (selectedDays.isEmpty) {
                                Dialogs.showSnackBar(context: context, message: AppLocalization.of(context).translate("days_required"));
                                return false;
                              }
                              if (fromTime == null || toTime == null) {
                                Dialogs.showSnackBar(context: context, message: AppLocalization.of(context).translate("times_required"));
                                return false;
                              }
                              if (selectedCourseDuration == null) {
                                Dialogs.showSnackBar(context: context, message: AppLocalization.of(context).translate("course_duration_required"));
                                return false;
                              }
                              if (selectedSession == null) {
                                Dialogs.showSnackBar(context: context, message: AppLocalization.of(context).translate("session_duration_required"));
                                return false;
                              }
                              if (selectedLocation == null) {
                                Dialogs.showSnackBar(context: context, message: AppLocalization.of(context).translate("location_required"));
                                return false;
                              }
                              if (photosList.isEmpty) {
                                Dialogs.showSnackBar(context: context, message: AppLocalization.of(context).translate("media_required"));
                                return false;
                              }
                              if (selectedFacilitiesId.isEmpty) {
                                Dialogs.showSnackBar(context: context, message: AppLocalization.of(context).translate("facility_required"));
                                return false;
                              }
                            }
                            return true;
                          },
                          onSuccess: (CourseModel model) async {
                            Navigation.pop();
                            widget.onRefresh?.call();
                          },
                          useCaseCallBack: (model) {
                            if(widget.isEdit == false) {
                              return CreateCourseUseCase(HomeRepository()).call(
                                  params: CreateCourseParams(
                                    name: form.controllers[0].text,
                                    categoryId: selectCategory == null ? -1 : selectCategory!.ID!,
                                    days: selectedDays.isEmpty ? [] : selectedDays.toList(),
                                    fromTime: fromTime ?? "",
                                    endTime: toTime ?? "",
                                    sessionDuration: selectedSession == null ? -1 : selectedSession!,
                                    courseDuration: selectedCourseDuration == null ? -1 : selectedCourseDuration!,
                                    price: form.controllers[1].text,
                                    capacity: form.controllers[2].text,
                                    cancellationFee: form.controllers[3].text,
                                    description: form.controllers[4].text,
                                    latitude: selectedLocation == null ? 0.0 : selectedLocation!.lat!,
                                    longitude: selectedLocation == null ? 0.0 : selectedLocation!.long!,
                                    files: photosList.isEmpty ? [] : photosList,
                                    tags: selectedFacilitiesId.isEmpty ? [] : selectedFacilitiesId.toList(),
                                  )
                              );
                            }
                            return EditCourseUseCase(HomeRepository()).call(
                                params: EditCourseParams(
                                  courseId: widget.course!.iD!,
                                  name: form.controllers[0].text,
                                  categoryId: selectCategory == null ? -1 : selectCategory!.ID!,
                                  sessionDuration: selectedSession == null ? -1 : selectedSession!,
                                  courseDuration: selectedCourseDuration == null ? -1 : selectedCourseDuration!,
                                  price: form.controllers[1].text,
                                  capacity: form.controllers[2].text,
                                  cancellationFee: form.controllers[3].text,
                                  description: form.controllers[4].text,
                                )
                            );
                          },
                          child: CustomButton(
                            backgroundColor: AppColors.primaryColor,
                            borderRadius: 10.r,
                            buttonName: AppLocalization.of(context).translate(
                                widget.isEdit == false ? "add" : "edit"),
                          ),
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
  int numberOfFields() => 5;
}