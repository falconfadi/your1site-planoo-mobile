import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourtAppointmentsScreen extends StatefulWidget {

  final Function(int)? onNavigate;

  const CourtAppointmentsScreen({super.key, this.onNavigate});

  @override
  State<CourtAppointmentsScreen> createState() => _CourtAppointmentsScreenState();
}

class _CourtAppointmentsScreenState extends State<CourtAppointmentsScreen> {

  List<Map<String,dynamic>> courtsList = [
    {"name": "Court 1","type": "Football","number": 2,"main":false},
    {"name": "Court 2","type": "Basketball","number": 1,"main":true},
    {"name": "Court 3","type": "Tennis","number": 10,"main":false},
    {"name": "Court 4","type": "Padel","number": 22,"main":false},
    {"name": "Court 5","type": "Volleyball","number": 5,"main":false},
    {"name": "Court 6","type": "Handball","number": 9,"main":false},
    {"name": "Court 7","type": "Badminton","number": 1,"main":false},
    {"name": "Court 8","type": "Squash","number": 0,"main":false},
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
                  itemCount: courtsList.length,
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
                            color: courtsList[index]["main"] == true ?
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
                                    Text(courtsList[index]["name"],
                                      style: AppTheme.titleSmall,
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(courtsList[index]["type"],
                                      style: AppTheme.labelMedium.copyWith(color: AppColors.primaryColor),
                                    ),
                                    if(courtsList[index]["main"] == true)
                                     SizedBox(height: 5.h),
                                    if(courtsList[index]["main"] == true)
                                      Text(AppLocalization.of(context).translate("main"),
                                        style: AppTheme.bodyMedium.copyWith(color: AppColors.darkGreenColor),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(courtsList[index]["number"].toString(),
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
