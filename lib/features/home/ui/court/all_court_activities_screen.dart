import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/features/home/widget/court/activity/court_activity_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllCourtActivitiesScreen extends StatefulWidget {

  const AllCourtActivitiesScreen({super.key});

  @override
  State<AllCourtActivitiesScreen> createState() => _AllCourtActivitiesScreenState();
}

class _AllCourtActivitiesScreenState extends State<AllCourtActivitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomHeader(title: "",isNavBar: false),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 30.h),
            // todo filter here
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context,index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: CourtActivityWidget()
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
