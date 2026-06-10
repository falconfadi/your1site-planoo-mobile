import 'dart:io';
import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/shared_widgets/select_single_item_widget.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:centro_partner/features/home/widget/facilities_widget.dart';
import 'package:centro_partner/features/home/widget/location_preview_widget.dart';
import 'package:centro_partner/features/home/widget/photos_widget.dart';
import 'package:centro_partner/features/home/widget/workdays_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/court/court_details_model.dart';
import 'package:centro_partner/features/home/data/model/court/court_model.dart';
import 'package:centro_partner/features/home/data/model/category_model.dart';
import 'package:centro_partner/features/home/data/model/location_model.dart';
import 'package:centro_partner/features/home/data/model/session_duration_model.dart';
import 'package:centro_partner/features/home/data/usecase/court/edit_court_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/categories_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/court/create_court_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/session_durations_usecase.dart';
import 'package:centro_partner/features/home/ui/create_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/ui/widgets/custom_text_field.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/validators/base_validator.dart';
import 'package:centro_partner/core/utils/validators/required_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/core/utils/extension/text_field_ext.dart';
import 'package:centro_partner/core/utils/form_utils/form_state_mixin.dart';

class AddCourtScreen extends StatefulWidget {

  final bool? isEdit;
  final CourtDetailsModel? court;
  final VoidCallback? onRefresh;

  const AddCourtScreen({super.key,this.isEdit = false,this.court,this.onRefresh});

  @override
  State<AddCourtScreen> createState() => _AddCourtScreenState();
}

class _AddCourtScreenState extends State<AddCourtScreen> with FormStateMinxin {

  CategoryInfoModel? selectCategory;
  Set<String> selectedDays = {};
  String? fromTime;
  String? toTime;
  int? selectedSession;
  LocationModel? selectedLocation;
  Set<int> selectedFacilitiesId = {};
  List<File> photosList = <File>[];

  @override
  void initState() {
    super.initState();
    if(widget.isEdit == true) {
      form.controllers[0].text = widget.court!.name!;
      form.controllers[2].text = widget.court!.description!;
      selectedSession = widget.court!.sessionDuration;
      form.controllers[1].text = widget.court!.price.toString();
      selectedLocation = widget.court!.location!;
      selectedFacilitiesId = widget.court!.facilitiesList!.map((f) => f.ID!).toSet();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: CustomHeader(
          title: "",
          isNavBar: false,
          leading: IconButton(
            icon: Icon(Icons.close),
            color: AppColors.blackColor,
            iconSize: isTablet ? 20.sp : null,
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
                      return CategoriesUseCase(HomeRepository()).call(
                        params: CategoriesParams(),
                      );
                    },
                    onSuccess: (result) {
                      if (widget.isEdit == true) {
                        selectCategory = result.categoriesList?.firstWhere((cat) =>
                              cat.ID == widget.court!.category!.ID,
                              orElse: () => result.categoriesList!.first,
                            );
                      }
                    },
                    modelBuilder: (model) =>
                        SelectSingleItemWidget<CategoryInfoModel, int>(
                          title: selectCategory?.name ??
                              AppLocalization.of(context)
                                  .translate("category"),
                          titleColor: selectCategory == null
                              ? AppColors.mediumGrayColor
                              : AppColors.blackColor,
                          list: model.categoriesList ?? [],
                          selectedId: selectCategory?.ID,
                          labelBuilder: (item) =>
                          item.name ?? "",
                          idBuilder: (item) =>
                          item.ID ?? 0,
                          onSelect: (id) {
                            setState(() {
                              selectCategory =
                                  model.categoriesList?.firstWhere(
                                        (item) => item.ID == id,
                                  );
                            });
                          },
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
                      onDaysChanged: (days) {
                        setState(() => selectedDays = days);
                      },
                    ),
                  SizedBox(height: 20.h),
                  GetModel<SessionDurationModel>(
                    useCaseCallBack: () {
                      return SessionDurationsUseCase(HomeRepository()).call(
                        params: SessionDurationsParams(),
                      );
                    },
                    modelBuilder: (model) =>
                        SelectSingleItemWidget<int, int>(
                          title: selectedSession == null ? AppLocalization.of(context).translate("session_duration")
                              : "$selectedSession ${AppLocalization.of(context).translate("minute")}",
                          titleColor: selectedSession == null
                              ? AppColors.mediumGrayColor
                              : AppColors.blackColor,
                          list: model.durationsList ?? [],
                          selectedId: selectedSession,
                          labelBuilder: (item) => "$item ${AppLocalization.of(context).translate("minute")}",
                          idBuilder: (item) => item,
                          onSelect: (id) {
                            setState(() {
                              selectedSession = id;
                            });
                          },
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
                  LocationPreviewWidget(
                    location: selectedLocation,
                    onTap: () async {
                      final result = await Navigation.push(
                        CreateLocationScreen(
                          ownerType: widget.isEdit == true ? "activity" : null,
                          ownerId: widget.isEdit == true ? widget.court!.iD! : null,
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
                    focusNode: form.nodes[2],
                    textEditingController: form.controllers[2],
                    labelText: AppLocalization.of(context).translate("description"),
                  ),
                  SizedBox(height: 20.h),
                  PhotosWidget(
                    ownerType: widget.isEdit == true ? "activity" : null,
                    ownerId: widget.isEdit == true ? widget.court!.iD! : null,
                    photos: photosList,
                    isEdit: widget.isEdit == true ? true : false,
                  ),
                  SizedBox(height: 20.h),
                  FacilitiesWidget(
                    ownerType: widget.isEdit == true ? "activity" : null,
                    ownerId: widget.isEdit == true ? widget.court!.iD! : null,
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
                            }
                            return true;
                          },
                          onSuccess: (CourtModel model) async {
                            Navigation.pop();
                            widget.onRefresh?.call();
                          },
                          useCaseCallBack: (model) {
                            if(widget.isEdit == false) {
                              return CreateCourtUseCase(HomeRepository()).call(
                                  params: CreateCourtParams(
                                    name: form.controllers[0].text,
                                    categoryId: selectCategory == null ? -1 : selectCategory!.ID!,
                                    days:  selectedDays.isEmpty ? [] : selectedDays.toList(),
                                    fromTime: fromTime ?? "",
                                    endTime: toTime ?? "",
                                    sessionDuration: selectedSession == null ? -1 : selectedSession!,
                                    price: form.controllers[1].text,
                                    description: form.controllers[2].text,
                                    latitude: selectedLocation == null ? 0.0 : selectedLocation!.lat!,
                                    longitude: selectedLocation == null ? 0.0 : selectedLocation!.long!,
                                    files: photosList.isEmpty ? [] : photosList,
                                    tags: selectedFacilitiesId.isEmpty ? [] : selectedFacilitiesId.toList(),
                                  )
                              );
                            }
                            return EditCourtUseCase(HomeRepository()).call(
                                params: EditCourtParams(
                                  courtId: widget.court!.iD,
                                  name: form.controllers[0].text,
                                  categoryId: selectCategory == null ? -1 : selectCategory!.ID!,
                                  sessionDuration: selectedSession == null ? -1 : selectedSession!,
                                  price: form.controllers[1].text,
                                  description: form.controllers[2].text,
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
  int numberOfFields() => 3;
}