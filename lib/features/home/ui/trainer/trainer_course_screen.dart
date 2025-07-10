import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrainerCourseScreen extends StatefulWidget {

  final Function(int)? onNavigate;

  const TrainerCourseScreen({super.key, this.onNavigate});

  @override
  State<TrainerCourseScreen> createState() => _TrainerCourseScreenState();
}

class _TrainerCourseScreenState extends State<TrainerCourseScreen> {

  // todo later change from backend
  // todo when type is daily => number for appointments
  // todo when type is monthly => number for subscribers
  List<Map<String,dynamic>> lessonsList = [
    {"name": "course 1","type": "daily","number": 2,"main":false},
    {"name": "course 2","type": "monthly","number": 1,"main":true},
    {"name": "course 3","type": "daily","number": 10,"main":false},
    {"name": "course 4","type": "daily","number": 22,"main":false},
    {"name": "course 5","type": "daily","number": 5,"main":false},
    {"name": "course 6","type": "monthly","number": 9,"main":false},
    {"name": "course 7","type": "daily","number": 1,"main":false},
    {"name": "course 8","type": "monthly","number": 0,"main":false},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: CustomHeader(title: "", isNavBar: true),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 40.h),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: lessonsList.length,
                  itemBuilder: (context,index) {
                    return InkWell(
                      onTap: () {
                        widget.onNavigate?.call(1);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: Container(
                          width: 1.sw,
                          padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
                          decoration: BoxDecoration(
                            color: lessonsList[index]["main"] == true ?
                            AppColors.lightGrayColor :
                            AppColors.whiteColor,
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.gray2Color,
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: const Offset(0,1)
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(lessonsList[index]["name"],
                                      style: AppTheme.titleSmall,
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(lessonsList[index]["type"],
                                      style: AppTheme.labelMedium.copyWith(color: AppColors.primaryColor),
                                    ),
                                    if(lessonsList[index]["main"] == true)
                                     SizedBox(height: 5.h),
                                    if(lessonsList[index]["main"] == true)
                                      Text(AppLocalization.of(context).translate("main"),
                                        style: AppTheme.bodyMedium.copyWith(color: AppColors.darkGreenColor),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(lessonsList[index]["number"].toString(),
                                style: AppTheme.titleSmall,
                              ),
                            ],
                          ),
                        )
                      ),
                    );
                  },
                ),
                SizedBox(height: 50.h),
              ],
            ),
          ),
        )
    );
  }
}
