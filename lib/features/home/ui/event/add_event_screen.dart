import 'dart:io';
import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_container_info_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/widgets/custom_date_picker.dart';
import 'package:centro_partner/features/home/data/model/event/event_details_model.dart';
import 'package:centro_partner/features/home/data/model/event/event_model.dart';
import 'package:centro_partner/features/home/data/usecase/event/create_event_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/event/edit_event_usecase.dart';
import 'package:centro_partner/features/home/widget/facilities_widget.dart';
import 'package:centro_partner/features/home/widget/photos_widget.dart';
import 'package:centro_partner/features/home/widget/workdays_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/ui/widgets/custom_drop_down.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/category_model.dart';
import 'package:centro_partner/features/home/data/model/location_model.dart';
import 'package:centro_partner/features/home/data/usecase/categories_usecase.dart';
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

class AddEventScreen extends StatefulWidget {

  final bool? isEdit;
  final EventDetailsModel? event;
  final VoidCallback? onRefresh;

  const AddEventScreen({super.key,this.isEdit = false,this.event,this.onRefresh});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> with FormStateMinxin {

  CategoryInfoModel? selectCategory;
  DateTime? startDate;
  Set<String> selectedDays = {};
  String? fromTime;
  String? toTime;
  LocationModel? selectedLocation;
  Set<int> selectedFacilitiesId = {};
  List<File> photosList = <File>[];

  @override
  void initState() {
    super.initState();
    if(widget.isEdit == true) {
      form.controllers[0].text = widget.event!.name!;
      form.controllers[1].text = widget.event!.eventDuration.toString();
      form.controllers[2].text = widget.event!.capacity.toString();
      form.controllers[3].text = widget.event!.admissionFee.toString();
      form.controllers[4].text = widget.event!.withdrawalFee.toString();
      form.controllers[5].text = widget.event!.description!;
      startDate = DateTime.parse(widget.event!.startDate!);
      selectedLocation = widget.event!.location!;
      selectedFacilitiesId = widget.event!.facilitiesList!.map((f) => f.ID!).toSet();
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
                              (cat) => cat.ID == widget.event!.category!.ID,
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
                  SizedBox(height: 20.h),
                  InkWell(
                    onTap: () async {
                      DateTime? selectedDate = await selectDate(context, startDate);
                      if (selectedDate != null) {
                        setState(() {
                          startDate = selectedDate;
                        });
                      }
                    },
                    child: CustomContainerInfoWidget(
                      title: startDate == null ? AppLocalization.of(context).translate("start_date") : convertDate(date: startDate.toString()),
                      textStyle: AppTheme.labelLarge.copyWith(fontSize: 18.sp,color: startDate == null ?
                      AppColors.mediumGrayColor : AppColors.blackColor),
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
                    labelText: "${AppLocalization.of(context).translate("event_duration")} | ${AppLocalization.of(context).translate("day")}",
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
                    labelText: AppLocalization.of(context).translate("admission_fee"),
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
                    labelText: AppLocalization.of(context).translate("withdrawal_fee"),
                  ),
                  SizedBox(height: 20.h),
                  InkWell(
                    onTap: () async {
                      final result = await Navigation.push(
                        CreateLocationScreen(
                          ownerType: widget.isEdit == true ? "event" : null,
                          ownerId: widget.isEdit == true ? widget.event!.iD! : null,
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
                    focusNode: form.nodes[5],
                    textEditingController: form.controllers[5],
                    labelText: AppLocalization.of(context).translate("description"),
                  ),
                  SizedBox(height: 20.h),
                  PhotosWidget(
                    ownerType: widget.isEdit == true ? "event" : null,
                    ownerId: widget.isEdit == true ? widget.event!.iD! : null,
                    photos: photosList,
                    isEdit: widget.isEdit == true ? true : false,
                  ),
                  SizedBox(height: 20.h),
                  FacilitiesWidget(
                    ownerType: widget.isEdit == true ? "event" : null,
                    ownerId: widget.isEdit == true ? widget.event!.iD! : null,
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
                              if (startDate == null) {
                                Dialogs.showSnackBar(context: context, message: AppLocalization.of(context).translate("start_date_required"));
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
                          onSuccess: (EventModel model) async {
                            Navigation.pop();
                            widget.onRefresh?.call();
                          },
                          useCaseCallBack: (model) {
                            if(widget.isEdit == false) {
                              return CreateEventUseCase(HomeRepository()).call(
                                  params: CreateEventParams(
                                    name: form.controllers[0].text,
                                    categoryId: selectCategory == null ? -1 : selectCategory!.ID!,
                                    days: selectedDays.isEmpty ? [] : selectedDays.toList(),
                                    fromTime: fromTime ?? "",
                                    endTime: toTime ?? "",
                                    eventDuration: form.controllers[1].text,
                                    capacity: form.controllers[2].text,
                                    admissionFee: form.controllers[3].text,
                                    withdrawalFee: form.controllers[4].text,
                                    startDate: startDate == null ? "" : convertDate(date: startDate.toString(),format: "yyyy-MM-dd"),
                                    description: form.controllers[5].text,
                                    latitude: selectedLocation == null ? 0.0 : selectedLocation!.lat!,
                                    longitude: selectedLocation == null ? 0.0 : selectedLocation!.long!,
                                    files: photosList.isEmpty ? [] : photosList,
                                    tags: selectedFacilitiesId.isEmpty ? [] : selectedFacilitiesId.toList(),
                                  )
                              );
                            }
                            return EditEventUseCase(HomeRepository()).call(
                                params: EditEventParams(
                                  eventId: widget.event!.iD!,
                                  name: form.controllers[0].text,
                                  categoryId: selectCategory == null ? -1 : selectCategory!.ID!,
                                  eventDuration: form.controllers[1].text,
                                  capacity: form.controllers[2].text,
                                  admissionFee: form.controllers[3].text,
                                  withdrawalFee: form.controllers[4].text,
                                  startDate: startDate == null ? "" : convertDate(date: startDate.toString(),format: "yyyy-MM-dd"),
                                  description: form.controllers[5].text,
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
  int numberOfFields() => 6;
}