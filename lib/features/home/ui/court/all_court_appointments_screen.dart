import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/home/ui/court/calendar_screen.dart';
import 'package:centro_partner/features/home/widget/court/appointment/court_appointment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllCourtAppointmentsScreen extends StatefulWidget {

  const AllCourtAppointmentsScreen({super.key});

  @override
  State<AllCourtAppointmentsScreen> createState() => _AllCourtAppointmentsScreenState();
}

class _AllCourtAppointmentsScreenState extends State<AllCourtAppointmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomHeader(title: "",isNavBar: false),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // todo filter here
                CustomButton(
                    icon: appointment,
                    iconColor: AppColors.primaryColor,
                    width: 20.w,
                    height: 40.h,
                    backgroundColor: AppColors.whiteColor,
                    borderRadius: 0,
                    function: () => Navigation.push(CalendarScreen())
                ),
              ],
            ),
            SizedBox(height: 20.h),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context,index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: CourtAppointmentWidget()
                );
              },
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}
