import 'dart:io';
import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/shared_widgets/photos_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/select_multi_items_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/workdays_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/ui/widgets/custom_drop_down.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/activity/activity_details_model.dart';
import 'package:centro_partner/features/home/data/model/activity/activity_model.dart';
import 'package:centro_partner/features/home/data/model/category_model.dart';
import 'package:centro_partner/features/home/data/model/facility_model.dart';
import 'package:centro_partner/features/home/data/model/session_duration_model.dart';
import 'package:centro_partner/features/home/data/usecase/activity/edit_activity_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/categories_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/activity/create_activity_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/facilities_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/session_durations_usecase.dart';
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
  final ActivityDetailsModel? activity;
  final VoidCallback? onRefresh;

  const AddActivityScreen({super.key,this.isEdit = false,this.activity,this.onRefresh});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen>  with FormStateMinxin {

  CategoryInfoModel? selectCategory;
  Set<String> selectedDays = {};
  TimeOfDay? fromTime;
  TimeOfDay? toTime;
  int? selectedSession;
  Set<int> selectedFacilitiesId = {};
  List<File> photosList = <File>[];


  @override
  void initState() {
    super.initState();
    if(widget.isEdit == true) {
      form.controllers[0].text = widget.activity!.name!;
      form.controllers[3].text = widget.activity!.description!;
      selectedSession = widget.activity!.sessionDuration;
      form.controllers[1].text = widget.activity!.price.toString();
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
                              (cat) => cat.ID == widget.activity!.category!.ID,
                          orElse: () => result.categoriesList!.first,
                        );
                      }
                    },
                    withAnimation: false,
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
                  GetModel<SessionDurationModel>(
                    useCaseCallBack: () {
                      return SessionDurationsUseCase(HomeRepository())
                          .call(params: SessionDurationsParams());
                    },
                    withAnimation: false,
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
                  if(widget.isEdit == false)
                    CustomTextField(
                    autoFocus: false,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    focusNode: form.nodes[2],
                    textEditingController: form.controllers[2],
                    labelText: AppLocalization.of(context).translate("location"),
                  ),
                  if(widget.isEdit == false) SizedBox(height: 20.h),
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
                  if(widget.isEdit == false) SizedBox(height: 20.h),
                  if(widget.isEdit == false)
                    PhotosWidget(photos: photosList),
                  if(widget.isEdit == false) SizedBox(height: 20.h),
                  if(widget.isEdit == false)
                    GetModel<FacilityModel>(
                    useCaseCallBack: () {
                      return FacilitiesUseCase(HomeRepository())
                          .call(params: FacilitiesParams());
                    },
                    withAnimation: false,
                    modelBuilder: (model) => SelectMultiItemsWidget(
                      title: AppLocalization.of(context).translate("facilities"),
                      list: model.facilitiesList!,
                      selectedIds: selectedFacilitiesId,
                      labelBuilder: (item) => item.name!,
                      idBuilder: (item) => item.ID!,
                      onSelect: (ids) {
                        setState(() {
                          selectedFacilitiesId.addAll(ids);
                        });
                      },
                    ),
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
                              if (selectedSession == null) {
                                Dialogs.showSnackBar(context: context, message: AppLocalization.of(context).translate("session_duration_required"));
                                return false;
                              }
                              // todo enable it later
                              // if (location == null) {
                              //   Dialogs.showSnackBar(context: context, message: AppLocalization.of(context).translate("location_required"));
                              //   return false;
                              // }
                              if (selectedFacilitiesId.isEmpty) {
                                Dialogs.showSnackBar(context: context, message: AppLocalization.of(context).translate("facility_required"));
                                return false;
                              }
                              if (selectedFacilitiesId.isEmpty) {
                                Dialogs.showSnackBar(context: context, message: "tags");
                                return false;
                              }
                            }
                            return true;
                          },
                          onSuccess: (ActivityModel model) async {
                            Navigation.pop();
                            widget.onRefresh?.call();
                          },
                          useCaseCallBack: (model) {
                            if(widget.isEdit == false) {
                              return CreateActivityUseCase(HomeRepository()).call(
                                  params: CreateActivityParams(
                                    name: form.controllers[0].text,
                                    categoryId: selectCategory!.ID!,
                                    days: selectedDays.toList(),
                                    fromTime: formatTime24(time: fromTime!),
                                    endTime: formatTime24(time: toTime!),
                                    sessionDuration: selectedSession!,
                                    price: form.controllers[1].text,
                                    description: form.controllers[3].text,
                                    latitude: 33.333329999, // todo get from map later
                                    longitude: 32.332219999, // todo get from map later
                                    files: photosList,
                                    tags: selectedFacilitiesId.toList(),
                                  )
                              );
                            }
                            return EditActivityUseCase(HomeRepository()).call(
                                params: EditActivityParams(
                                  activityId: widget.activity!.iD,
                                  name: form.controllers[0].text,
                                  categoryId: selectCategory!.ID!,
                                  sessionDuration: selectedSession!,
                                  price: form.controllers[1].text,
                                  description: form.controllers[3].text,
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
  int numberOfFields() => 4;
}