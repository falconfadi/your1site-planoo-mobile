import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/general/data/model/main_court/main_court_details_model.dart';
import 'package:centro_partner/features/home/ui/course/course_details_screen.dart';
import 'package:centro_partner/features/home/ui/court/court_details_screen.dart';
import 'package:centro_partner/features/home/ui/event/event_details_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class MainCourtDetailsScreen extends StatefulWidget {

  final MainCourtDetailsModel mainCourtDetailsModel;

  const MainCourtDetailsScreen({super.key,required this.mainCourtDetailsModel});

  @override
  State<MainCourtDetailsScreen> createState() => _MainCourtDetailsScreenState();
}

class _MainCourtDetailsScreenState extends State<MainCourtDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomHeader(title: "",isNavBar: false),
      body:  SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 25.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.mainCourtDetailsModel.name!, style: AppTheme.titleLarge.copyWith(color: AppColors.primaryColor)),
              if(widget.mainCourtDetailsModel.description != null) ...[
                SizedBox(height: 10.h),
                Text(widget.mainCourtDetailsModel.description!, style: AppTheme.bodyLarge),
              ],
              if (widget.mainCourtDetailsModel.courtsList!.isNotEmpty) ...[
                SizedBox(height: 20.h),
                headerWidget('courts'),
                listWidget(
                  itemCount: widget.mainCourtDetailsModel.courtsList!.length,
                  itemBuilder: (context, index) {
                    final court = widget.mainCourtDetailsModel.courtsList![index];
                    return itemCard(
                      title: court.name!,
                      subtitle: court.description!,
                      onTap: () => Navigation.push(CourtDetailsScreen(courtId: court.iD!))
                    );
                  },
                ),
                SizedBox(height: 20.h),
              ],

              if (widget.mainCourtDetailsModel.coursesList!.isNotEmpty) ...[
                headerWidget('courses'),
                listWidget(
                  itemCount: widget.mainCourtDetailsModel.coursesList!.length,
                  itemBuilder: (context, index) {
                    final course = widget.mainCourtDetailsModel.coursesList![index];
                    return itemCard(
                      title: course.name!,
                      subtitle: course.description!,
                        onTap: () => Navigation.push(CourseDetailsScreen(courseId: course.iD!))
                    );
                  },
                ),
                SizedBox(height: 20.h),
              ],

              if (widget.mainCourtDetailsModel.eventsList != null && widget.mainCourtDetailsModel.eventsList!.isNotEmpty) ...[
                headerWidget('events'),
                listWidget(
                  itemCount: widget.mainCourtDetailsModel.eventsList!.length,
                  itemBuilder: (context, index) {
                    final event = widget.mainCourtDetailsModel.eventsList![index];
                    return itemCard(
                      title: event.name!,
                      subtitle: event.description!,
                        onTap: () => Navigation.push(EventDetailsScreen(eventId: event.iD!))
                    );
                  },
                ),
              ],
              SizedBox(height: 30.h),
            ],
          )
      ),
    );
  }

  Widget headerWidget(String title) {
    return Text(AppLocalization.of(context).translate(title),
      style: AppTheme.headlineSmall,
    );
  }

  Widget listWidget({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    );
  }

  Widget itemCard({required String title, required String subtitle,required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 150.w,
        child: Card(
          color: AppColors.extraLightGrayColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                  style: AppTheme.titleLarge,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  subtitle,
                  style: AppTheme.bodyMedium.copyWith(color: AppColors.mediumGrayColor),
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
