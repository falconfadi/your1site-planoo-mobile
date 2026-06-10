import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/appointment/widget/appointment_item_card.dart';
import 'package:centro_partner/features/appointment/widget/attendance_summary_card.dart';
import 'package:centro_partner/features/home/data/model/event/event_details_model.dart';
import 'package:centro_partner/features/home/ui/event/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventAppointmentDetailsScreen extends StatelessWidget {

  EventDetailsModel? event;

  EventAppointmentDetailsScreen({super.key,required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: CustomHeader(title: "", isNavBar: false),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              AppointmentItemCard(
                  onTap: () {
                    Navigation.push(EventDetailsScreen(eventId: event!.iD!));
                  },
                  imageUrl: event!.mediaList!.isNotEmpty ? event!.mediaList!.first.url! : "",
                  title: event!.name!,
                  category: event!.category!.name!,
                  description: event!.description!,
                  rating: event!.rate!.toDouble(),
                  price: "${event!.admissionFee} ${AppLocalization.of(context).translate("syr")}"
              ),
              SizedBox(height: 5.h),
              AttendanceSummaryCard(
                date: event!.startDate!,
                capacity: event!.capacity!,
                remainingSlots: event!.capacity! - event!.attendees!,
                status: event!.status!,
                participantsList: event!.customersList ?? [],
                isEvent: true,
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
    );
  }
}
