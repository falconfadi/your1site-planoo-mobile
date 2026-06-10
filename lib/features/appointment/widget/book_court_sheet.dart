import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_row_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/icon_text_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/select_single_item_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/ui/widgets/custom_sheet.dart';
import 'package:centro_partner/core/ui/widgets/custom_table_calendar.dart';
import 'package:centro_partner/core/ui/widgets/custom_text_field.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:centro_partner/core/utils/validators/required_validator.dart';
import 'package:centro_partner/features/appointment/data/appointment_repository/appointment_repository.dart';
import 'package:centro_partner/features/appointment/data/model/accepted_appointments_model.dart';
import 'package:centro_partner/features/appointment/data/model/slots_model.dart';
import 'package:centro_partner/features/appointment/data/usecase/accepted_appointments_usecase.dart';
import 'package:centro_partner/features/appointment/data/usecase/check_court_appointment_usecase.dart';
import 'package:centro_partner/features/appointment/data/usecase/create_court_appointment_usecase.dart';
import 'package:centro_partner/features/appointment/widget/payment_sheet.dart';
import 'package:centro_partner/features/home/data/model/court/court_details_model.dart';
import 'package:centro_partner/features/home/data/model/workday/workday_details_model.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';
import 'package:centro_partner/core/utils/extension/text_field_ext.dart';
import 'package:centro_partner/core/utils/form_utils/form_state_mixin.dart';
import 'package:centro_partner/core/utils/validators/phone_number_validation.dart';
import 'package:centro_partner/core/utils/validators/base_validator.dart';
import 'package:centro_partner/core/constants/app_images.dart' as image;
import 'package:intl/intl.dart';

class BookCourtSheet extends StatefulWidget {

  CourtDetailsModel court;

  BookCourtSheet({super.key,required this.court});

  @override
  State<BookCourtSheet> createState() => _BookCourtSheetState();
}

class _BookCourtSheetState extends State<BookCourtSheet> with FormStateMinxin {

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
    final isTablet = Responsive.isTablet(context);
    return Column(
      children: [
        SelectSingleItemWidget<WorkdayDetailsModel, int>(
          title: selectedDay?.day ?? AppLocalization.of(context).translate("workdays"),
          titleColor: selectedDay == null
              ? AppColors.mediumGrayColor
              : AppColors.blackColor,
          list: widget.court.workdaysList ?? [],
          selectedId: selectedDay?.iD,
          labelBuilder: (item) => item.day ?? "",
          idBuilder: (item) => item.iD ?? 0,
          onSelect: (id) {
            setState(() {
              selectedDay = widget.court.workdaysList?.firstWhere(
                    (item) => item.iD == id,
                    orElse: () => WorkdayDetailsModel(),
              );
              date = null;
              selectedSlot = 0;
            });
          },
        ),
        SizedBox(height: 20.h),
        GetModel<AcceptedAppointmentsModel>(
          useCaseCallBack: () {
            return AcceptedAppointmentsUseCase(AppointmentRepository()).call(
              params: AcceptedAppointmentsParams(ownerType: "activity"),
            );
          },
          onError: (errorMessage) {
            return AcceptedAppointmentsModel(appointmentsList: []);
          },
          onSuccess: (result) {},
          modelBuilder: (model) {
            final allowedWeekday = selectedDay != null
                ? getWeekdayFromName(selectedDay!.day ?? '')
                : null;

            return Column(
              children: [
                if (selectedDay != null)
                  AppointmentsCalendarWidget(
                    appointments: model.appointmentsList ?? [],
                    allowedWeekday: allowedWeekday,
                    onDaySelected: (selectedDate, dayAppointments) {
                      setState(() {
                        date = selectedDate;
                      });
                      if (dayAppointments.isNotEmpty) {
                        Dialogs.showQuestion(context,
                          content: Column(
                            children: [
                              Text(AppLocalization.of(context).translate("your_appointments"),
                                style: AppTheme.titleLarge.copyWith(
                                    fontSize: 18.sp),
                              ),
                              SizedBox(height: 10.h),
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: dayAppointments.length,
                                itemBuilder: (context, index) {
                                  final appointment = dayAppointments[index];
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                                    child: Column(
                                      children: [
                                        IconTextWidget(
                                          icon: image.appointment,
                                          iconSize: 15.w,
                                          iconColor: AppColors.primaryColor,
                                          text: convertDate(date: appointment.date!,format: 'dd/MM/yyyy'),
                                          textStyle: AppTheme.labelLarge.copyWith(
                                              fontSize: 18.sp, color: AppColors.mediumGrayColor),
                                        ),
                                        IconTextWidget(
                                          icon: image.time,
                                          iconSize: 17.w,
                                          iconColor: AppColors.primaryColor,
                                          text: DateFormat("HH:mm").format(DateFormat("HH:mm:ss").parse(appointment.time!)),
                                          textStyle: AppTheme.labelLarge.copyWith(
                                              fontSize: 18.sp, color: AppColors.mediumGrayColor),
                                        ),
                                        if (index < dayAppointments.length - 1)
                                          Divider(color: AppColors.grayColor)
                                      ],
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 10.h),
                            ],
                          ),
                        );
                      }
                    },
                  ),
              ],
            );
          },
        ),
        SizedBox(height: 30.h),
        CreateModel(
          withValidation: false,
          onTap: () {},
          onSuccess: (SlotsModel model) async {
            form.controllers[0].clear();
            form.controllers[1].clear();
            CustomSheet.show(
                isDismissible: true,
                header: Text(AppLocalization.of(context).translate("book"),
                  style: AppTheme.titleLarge.copyWith(fontSize: 18.sp),
                ),
                padding: 30.w,
                context: context,
                child: Center(
                  child: Material(
                    color: Colors.transparent,
                    child: StatefulBuilder(
                        builder: (context, setStateDialog) {
                          return Container(
                            width: 0.9.sw,
                            padding: EdgeInsets.only(left: 10.w,right: 10.w,top: 0,bottom: 20.h),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomRowWidget(title: AppLocalization.of(context).translate("court"), subTitle: widget.court.name!),
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
                                        height: isTablet ? 45.h : 35.h,
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
                                            prefixIcon: Icons.phone_android_outlined,
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
                                CustomButton(
                                  width: 1.sw,
                                  backgroundColor: (model.slot!.slots!.isEmpty) ?
                                  AppColors.grayColor : AppColors.primaryColor,
                                  borderRadius: 8.r,
                                  buttonName: AppLocalization.of(context).translate("book"),
                                  function: () {
                                    if(form.validate() == true && model.slot!.slots!.isNotEmpty) {
                                      CustomSheet.show(
                                          isDismissible: true,
                                          header: Center(),
                                          padding: 30.w,
                                          context: context,
                                          child: PaymentSheet(
                                            createCourtAppointmentParams: CreateCourtAppointmentParams(
                                                courtId: widget.court.iD!,
                                                code: model.slot!.code.toString(),
                                                dayId: selectedDay!.iD!,
                                                date: convertDate(date: date.toString(),format: "yyyy-MM-dd"),
                                                sessionDuration: widget.court.sessionDuration!,
                                                time: model.slot!.slots!.isEmpty ? "" : model.slot!.slots![selectedSlot].startTime!,
                                                note: form.controllers[0].text,
                                                customerPhone: form.controllers[1].text
                                            ),
                                          )
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: 5.h),
                              ],
                            ),
                          );
                        }
                    ),
                  ),
                ),
            );
          },
          useCaseCallBack: (model) {
            if (selectedDay != null && date != null) {
              return CheckCourtAppointmentUseCase(AppointmentRepository()).call(
                  params: CheckCourtAppointmentParams(
                    courtId: widget.court.iD!,
                    dayId: selectedDay!.iD!,
                    date: convertDate(date: date.toString(),format: "yyyy-MM-dd"),
                    sessionDuration: widget.court.sessionDuration!,
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
