import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/shared_widgets/tabs_widget.dart';
import 'package:centro_partner/core/ui/widgets/coustom_sheet.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/appointments/ui/activity_appointment_details_screen.dart';
import 'package:centro_partner/features/appointments/widget/activity_appointments_widget.dart';
import 'package:centro_partner/features/appointments/widget/filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppointmentsScreen extends StatefulWidget {

  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {

  int selectedTab = 0;

  List<Map<String,dynamic>> activityAppointmentsList = [
    {"photo":"https://smithhousestrategy.com/wp-content/uploads/2024/02/sports.jpg","category":"Football","date":"15/10/2025","from_time":"10:00","to_time":"12:30","status": 0,"user":"Maya"},
    {"photo":"https://smithhousestrategy.com/wp-content/uploads/2024/02/sports.jpg","category":"Basketball","date":"15/10/2025","from_time":"10:00","to_time":"12:30","status": 1,"user":"Dani"},
    {"photo":"https://smithhousestrategy.com/wp-content/uploads/2024/02/sports.jpg","category":"Volleyball","date":"15/10/2025","from_time":"10:00","to_time":"12:30","status": 1,"user":"Ahmad"},
    {"photo":"https://smithhousestrategy.com/wp-content/uploads/2024/02/sports.jpg","category":"Tennis","date":"15/10/2025","from_time":"10:00","to_time":"12:30","status": -1,"user":"Jojo"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: CustomHeader(title: AppLocalization.of(context).translate("appointments"), isNavBar: true),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      CustomSheet.show(
                          isDismissible: true,
                          header: Text(AppLocalization.of(context).translate("filter"),
                            style: AppTheme.titleLarge.copyWith(fontSize: 18.sp),
                          ),
                          padding: 30.w,
                          context: context,
                          child: FilterSheet()
                      );
                    },
                    child: SvgPicture.asset(filter,color: AppColors.turquoiseColor)
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: TabsWidget(
                      selectedTab: selectedTab,
                      onTabChanged: (index) {
                        setState(() {
                          selectedTab = index;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              selectedTab == 0 ?
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: activityAppointmentsList.length,
                  itemBuilder: (context,index) {
                    return InkWell(
                        onTap: () => Navigation.push(ActivityAppointmentDetailsScreen(appointment: activityAppointmentsList[index])),
                        child: ActivityAppointmentsWidget(appointment: activityAppointmentsList[index]));
                    },
                ),
              ) : Center(),
            ],
          ),
        )
    );
  }
}
