import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_container_info_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_row_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/ui/widgets/custom_date_picker.dart';
import 'package:centro_partner/core/ui/widgets/custom_dialog.dart';
import 'package:centro_partner/core/ui/widgets/custom_drop_down.dart';
import 'package:centro_partner/core/ui/widgets/custom_text_field.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/validators/required_validator.dart';
import 'package:centro_partner/features/appointment/data/appointment_repository/appointment_repository.dart';
import 'package:centro_partner/features/appointment/data/model/slots_model.dart';
import 'package:centro_partner/features/appointment/data/usecase/check_activity_appointment_usecase.dart';
import 'package:centro_partner/features/appointment/data/usecase/create_activity_appointment_usecase.dart';
import 'package:centro_partner/features/home/data/model/activity/activity_details_model.dart';
import 'package:centro_partner/features/home/data/model/workday/workday_details_model.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';
import 'package:centro_partner/core/utils/extension/text_field_ext.dart';
import 'package:centro_partner/core/utils/form_utils/form_state_mixin.dart';
import 'package:centro_partner/core/utils/validators/phone_number_validation.dart';
import 'package:centro_partner/core/utils/validators/base_validator.dart';

class BookActivitySheet extends StatefulWidget {

  ActivityDetailsModel activity;

  BookActivitySheet({super.key,required this.activity});

  @override
  State<BookActivitySheet> createState() => _BookActivitySheetState();
}

class _BookActivitySheetState extends State<BookActivitySheet> with FormStateMinxin {

  WorkdayDetailsModel? selectedDay;
  DateTime? date;
  int selectedSlot = 0;

  int getWeekdayFromName(String dayName) {
    switch (dayName.toLowerCase()) {
      case 'saturday': return DateTime.saturday;
      case 'sunday': return DateTime.sunday;
      case 'monday': return DateTime.monday;
      case 'tuesday': return DateTime.tuesday;
      case 'wednesday': return DateTime.wednesday;
      case 'thursday': return DateTime.thursday;
      case 'friday': return DateTime.friday;
      default: return DateTime.monday;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDropDown(
          width: 1.sw,
          height: 60.h,
          text: AppLocalization.of(context).translate("workdays"),
          value: selectedDay,
          onChanged: (newValue) {
            setState(() {
              selectedDay = newValue;
            });
          },
          items: widget.activity.workdaysList!.map((WorkdayDetailsModel value) => DropdownMenuItem(
            value: value,
            child: Row(
              children: [
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    value.day!,
                    style: AppTheme.labelLarge.copyWith(fontSize: 18.sp),
                  ),
                ),
              ],
            ),
          ))
              .toList(),
        ),
        SizedBox(height: 20.h),
        InkWell(
          onTap: () async {
            if(selectedDay != null) {
              final allowedWeekday = getWeekdayFromName(selectedDay?.day ?? '');
              DateTime? selectedDate = await selectDate(
                  context,
                  date,
                  allowedWeekday: allowedWeekday
              );
              if (selectedDate != null) {
                setState(() {
                  date = selectedDate;
                });
              }
            } else {
              Dialogs.showSnackBar(context: context, message: AppLocalization.of(context).translate("days_required"));
            }
          },
          child: CustomContainerInfoWidget(
            title: date == null ? AppLocalization.of(context).translate("date") : convertDate(date: date.toString()),
            textStyle: AppTheme.labelLarge.copyWith(fontSize: 18.sp,color: date == null ?
            AppColors.mediumGrayColor : AppColors.blackColor),
          ),
        ),
        SizedBox(height: 30.h),
        CreateModel(
          withValidation: false,
          onTap: () {},
          onSuccess: (SlotsModel model) async {
            showAnimatedDialog(
              context,
              Center(
                child: Material(
                  color: Colors.transparent,
                  child: StatefulBuilder(
                      builder: (context, setStateDialog) {
                      return Container(
                        width: 0.9.sw,
                        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 30.h),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomRowWidget(title: AppLocalization.of(context).translate("activity"), subTitle: widget.activity.name!),
                            SizedBox(height: 5.h),
                            CustomRowWidget(title: AppLocalization.of(context).translate("day"), subTitle: model.slot!.day!),
                            SizedBox(height: 5.h),
                            CustomRowWidget(title: AppLocalization.of(context).translate("date"), subTitle: convertDate(date: model.slot!.date!)),
                            SizedBox(height: 10.h),
                            Divider(),
                            SizedBox(height: 10.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalization.of(context).translate("slots"),
                                  style: AppTheme.headlineMedium,
                                ),
                                SizedBox(height: 10.h),
                                SizedBox(
                                    height: 35.h,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: model.slot!.slots!.length,
                                      itemBuilder: (context,index) {
                                        return InkWell(
                                          onTap: () {
                                            setStateDialog(() {
                                              selectedSlot = index;
                                            });
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                                              decoration: BoxDecoration(
                                                color: selectedSlot == index ?
                                                AppColors.turquoiseColor : AppColors.lightGrayColor,
                                                borderRadius: BorderRadius.circular(10.r),
                                              ),
                                              child: Center(child: Text("${model.slot!.slots![index].startTime} - ${model.slot!.slots![index].endTime}",style: AppTheme.labelLarge))
                                          ),
                                        );
                                      },
                                    )
                                ),
                                SizedBox(height: 10.h),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Form(
                                key: form.key,
                                child: Column(
                                    children: [
                                      CustomTextField(
                                        autoFocus: false,
                                        maxLine: 2,
                                        autoValidateMode: AutovalidateMode.onUserInteraction,
                                        focusNode: form.nodes[0],
                                        textEditingController: form.controllers[0],
                                        labelText: AppLocalization.of(context).translate("note"),
                                      ),
                                      SizedBox(height: 15.h),
                                      CustomTextField(
                                        autoFocus: false,
                                        autoValidateMode: AutovalidateMode.onUserInteraction,
                                        keyboardType: TextInputType.phone,
                                        prefixIcon: Icons.phone,
                                        validator: (value) {
                                          return BaseValidator.validateValue(
                                            context,
                                            value!,
                                            [RequiredValidator(),PhoneNumberValidator(value: value)],
                                          );
                                        },
                                        focusNode: form.nodes[1],
                                        textEditingController: form.controllers[1],
                                        labelText: AppLocalization.of(context).translate("customer_phone"),
                                      ),
                                    ]
                                )
                            ),
                            SizedBox(height: 30.h),
                            CreateModel(
                              withValidation: true,
                              onTap: () {
                                return form.validate();
                              },
                              useCaseCallBack: (data) {
                                return CreateActivityAppointmentUseCase(AppointmentRepository()).call(
                                    params: CreateActivityAppointmentParams(
                                      activityId: widget.activity.iD!,
                                      dayId: selectedDay!.iD!,
                                      date: convertDate(date: date.toString(),format: "yyyy-MM-dd"),
                                      sessionDuration: widget.activity.sessionDuration!,
                                      time: model.slot!.slots!.isEmpty ? "" : model.slot!.slots![selectedSlot].startTime!,
                                      note: form.controllers[0].text,
                                      customerPhone: form.controllers[1].text
                                    ));
                              },
                              onSuccess: (result) async {
                                Navigation.pop();
                                Navigation.pop();
                                Dialogs.showSnackBar(context: context, message: AppLocalization.of(context).translate("activity_booked_successfully"));
                              },
                              child: CustomButton(
                                width: 1.sw,
                                backgroundColor: AppColors.primaryColor,
                                borderSideColor: AppColors.primaryColor,
                                borderRadius: 8.r,
                                buttonName: AppLocalization.of(context).translate("book"),
                              ),
                            ),
                            SizedBox(height: 5.h),
                          ],
                        ),
                      );
                    }
                  ),
                ),
              ),
              dismissible: true,
            );
          },
          useCaseCallBack: (model) {
            if (selectedDay != null && date != null) {
              return CheckActivityAppointmentUseCase(AppointmentRepository()).call(
                  params: CheckActivityAppointmentParams(
                    activityId: widget.activity.iD!,
                    dayId: selectedDay!.iD!,
                    date: convertDate(date: date.toString(),format: "yyyy-MM-dd"),
                    sessionDuration: widget.activity.sessionDuration!,
                  )
              );
            }
            return null;
          },
          child: CustomButton(
            backgroundColor: (selectedDay == null || date == null) ?
            AppColors.grayColor : AppColors.primaryColor,
            borderRadius: 10.r,
            buttonName: AppLocalization.of(context).translate("check"),
          ),
        ),
        SizedBox(height: 30.h),
      ]
    );
  }
  @override
  int numberOfFields() => 2;
}
