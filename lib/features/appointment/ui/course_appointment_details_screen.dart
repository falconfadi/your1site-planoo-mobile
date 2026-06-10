import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/appointment/widget/appointment_item_card.dart';
import 'package:centro_partner/features/appointment/widget/attendance_summary_card.dart';
import 'package:centro_partner/features/home/data/model/course/course_details_model.dart';
import 'package:centro_partner/features/home/ui/course/course_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseAppointmentDetailsScreen extends StatelessWidget {

  CourseDetailsModel? course;

  CourseAppointmentDetailsScreen({super.key,required this.course});

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
                    Navigation.push(CourseDetailsScreen(courseId: course!.iD!));
                  },
                  imageUrl: course!.mediaList!.isNotEmpty ? course!.mediaList!.first.url! : "",
                  title: course!.name!,
                  category: course!.category!.name!,
                  description: course!.description!,
                  rating: course!.rate!.toDouble(),
                  price: "${course!.price} ${AppLocalization.of(context).translate("syr")}"
              ),
              SizedBox(height: 5.h),
              AttendanceSummaryCard(
                date: course!.startDate!,
                capacity: course!.capacity!,
                remainingSlots: course!.capacity! - course!.attendees!,
                status: course!.status!,
                participantsList: course!.customersList ?? [],
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
    );
  }
}
