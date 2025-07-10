import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/widgets/custom_date_picker.dart';
import 'package:centro_partner/core/utils/validators/convert_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatefulWidget {

  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  CalendarController calendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: CustomHeader(title: "", isNavBar: false),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              InkWell(
                onTap: () async {
                  DateTime? selectedDate = await selectDate(context, calendarController.displayDate,isDateOfBirth: false);
                  if (selectedDate != null) {
                    setState(() {
                      calendarController.displayDate = selectedDate;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(calendarController.displayDate == null ? convertDate(date: DateTime.now().toString()) : convertDate(date: calendarController.displayDate.toString()),
                      style: AppTheme.bodyMedium
                    ),
                    const Icon(Icons.keyboard_arrow_down_outlined)
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                height: 1.sh - 200.h,
                child: SfCalendar(
                  controller: calendarController,
                  view: CalendarView.week,
                  viewHeaderStyle: ViewHeaderStyle(
                    dateTextStyle: AppTheme.labelMedium.copyWith(color: AppColors.mediumGrayColor),
                    dayTextStyle: AppTheme.labelSmall.copyWith(color: AppColors.mediumGrayColor),
                  ),
                  todayTextStyle: AppTheme.labelMedium.copyWith(color: AppColors.whiteColor),
                  headerHeight: 0,
                  cellBorderColor: AppColors.mediumGrayColor,
                  monthViewSettings: const MonthViewSettings(
                    showAgenda: true,
                  ),
                  timeSlotViewSettings: TimeSlotViewSettings(
                    timeTextStyle: AppTheme.labelSmall.copyWith(color: AppColors.mediumGrayColor),
                    dayFormat: 'EEE',
                  ),
                  todayHighlightColor: AppColors.primaryColor,
                  selectionDecoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor, width: 2),
                  ),
                  // dataSource: AppointmentDataSource(appointmentController.getCalendarAppointments(context,appointmentController.appointmentsList)),
                  // onTap: calendarTapped,
                ),
              ),
            ],
          ),
        )
    );
  }

  // void calendarTapped(CalendarTapDetails details) {
  //   if (details.targetElement == CalendarElement.appointment) {
  //     Appointment selectedAppointment = details.appointments![0];
  //     showDialog(
  //       context: context,
  //       builder: (context) => GetBuilder<AppointmentController>(builder: (appointmentController) {
  //         return AlertDialog(
  //           elevation: 0,
  //           content: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   InkWell(
  //                       onTap: () => Get.back(),
  //                       child: const Icon(Icons.close)
  //                   ),
  //                 ],
  //               ),
  //               AppointmentDetailsItem(title1: "${"date".tr}: ",title2: DateConverter.convertDate(selectedAppointment.startTime.toString())),
  //               const SizedBox(height: Dimensions.paddingSizeExtraSmall),
  //               AppointmentDetailsItem(title1: "${"client_name".tr}: ",title2: selectedAppointment.subject),
  //               const SizedBox(height: Dimensions.paddingSizeExtraSmall),
  //               AppointmentDetailsItem(title1: "${"by_team_member".tr}: ",title2: selectedAppointment.location.toString()),
  //               const SizedBox(height: Dimensions.paddingSizeExtraSmall),
  //               Row(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Text("${"status".tr}:  ",
  //                     style: montserratMedium.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).hintColor),
  //                   ),
  //                   StatusTag(
  //                       statusText: selectedAppointment.notes!,
  //                       statusColor: selectedAppointment.notes! == "booked" ? Theme.of(context).primaryColor : selectedAppointment.notes! == "canceled" ?
  //                       Theme.of(context).colorScheme.onSecondaryContainer : Theme.of(context).colorScheme.onPrimaryContainer
  //                   )
  //                 ],
  //               ),
  //             ],
  //           ),
  //           actions: AppConstants.isAdmin == 0 ? [] : [
  //             !appointmentController.isLoading ? Row(
  //               children: [
  //                 Expanded(
  //                   child: CustomButton(
  //                     buttonText: 'cancel'.tr,
  //                     borderColor: Colors.red,
  //                     transparent: true,
  //                     textColor: Colors.red,
  //                     onPressed: () {
  //                       appointmentController.cancelAppointment(selectedAppointment.id.toString()).then((value) {
  //                         if(value.containsKey(true)) {
  //                           appointmentController.getAppointmentsList();
  //                           Get.back();
  //                         }
  //                       });
  //                     },
  //                     radius: Dimensions.radiusDefault,
  //                     height: 40,
  //                   ),
  //                 ),
  //                 const SizedBox(width: Dimensions.paddingSizeSmall),
  //                 Expanded(
  //                     child: CustomButton(
  //                       onPressed: () {
  //                         appointmentController.completeCenterAppointment(int.parse(selectedAppointment.id.toString())).then((value) {
  //                           if(value.containsKey(true)) {
  //                             appointmentController.getAppointmentsList();
  //                             Get.back();
  //                           }
  //                         });
  //                       },
  //                       buttonText: "complete".tr,
  //                       radius: Dimensions.radiusDefault,
  //                       height: 40,
  //                     )
  //                 ),
  //               ],
  //             )  : const Center(child: CircularProgressIndicator())
  //           ],
  //         );
  //       }),
  //     );
  //   }
  // }
}


class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
//
// class AppointmentDetailsItem extends StatelessWidget {
//
//   final String title1;
//   final String title2;
//
//   const AppointmentDetailsItem({super.key,
//     required this.title1,
//     required this.title2,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Text(title1,
//           style: montserratMedium.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).hintColor),
//         ),
//         Expanded(
//           child: Text(title2,
//             style: montserratBold.copyWith(fontSize: Dimensions.fontSizeLarge),
//           ),
//         )
//       ],
//     );
//   }
// }

