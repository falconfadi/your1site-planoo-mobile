import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/features/home/widget/court/all_courts_widget.dart';
import 'package:centro_partner/features/home/widget/court/court_tabs_widget.dart';
import 'package:centro_partner/features/home/widget/trainer/all_courses_widget.dart';
import 'package:centro_partner/features/home/widget/trainer/trainer_tabs_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomHeader(title: "", isNavBar: true),
      body: SingleChildScrollView(
        // todo change according to account type
        child: Column(
          children: [
            SizedBox(height: 20.h),
            AllCourtsWidget(),
            SizedBox(height: 20.h),
            CourtTabsWidget(),
          ],
        ),
        // child: Column(
        //   children: [
        //     SizedBox(height: 20.h),
        //     AllCoursesWidget(),
        //     SizedBox(height: 20.h),
        //     TrainerTabsWidget(),
        //   ],
        // ),
      )
    );
  }
}
