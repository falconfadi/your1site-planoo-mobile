import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/widgets/custom_drop_down.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/home/ui/court/create_court_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllCourtsWidget extends StatefulWidget {

  const AllCourtsWidget({super.key});

  @override
  State<AllCourtsWidget> createState() => _AllCourtsWidgetState();
}

class _AllCourtsWidgetState extends State<AllCourtsWidget> {

  Map<String,dynamic>? selectCourt;

  // todo remove later
  List<Map<String,dynamic>> courtsList = [
    {"name": "Court 1","available": true,"main":false},
    {"name": "Court 2","available": false,"main":true},
    {"name": "Court 3","available": true,"main":false},
    {"name": "Court 4","available": false,"main":false},
    {"name": "Court 5","available": true,"main":false},
    {"name": "Court 6","available": true,"main":false},
    {"name": "Court 7","available": true,"main":false},
    {"name": "Court 8","available": false,"main":false},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      height: 55.h,
      child: Row(
        children: [
          Expanded(
            child: CustomDropDown(
              width: 1.sw,
              height: 56.h,
              text: AppLocalization.of(context).translate("select_court"),
              value: selectCourt,
              onChanged: (newValue) {
                setState(() {
                  selectCourt = newValue as Map<String,dynamic>;
                });
              },
              items: courtsList.map((Map<String,dynamic> value) {
                return DropdownMenuItem(
                  value: value,
                  child: SizedBox(
                    width: 1.sw,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(value["name"],
                            style: AppTheme.labelMedium.copyWith(
                              color: value["available"] == true
                                  ? AppColors.blackColor
                                  : AppColors.grayColor,
                            )
                        ),
                        const SizedBox(width: 8),
                        if (value["main"] == true)
                          Icon(Icons.check, color: AppColors.primaryColor),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(width: 10.w),
          InkWell(
            onTap: () => Navigation.push(CreateCourtScreen()),
            child: Container(
                width: 55.w,
                height: 55.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.mediumGrayColor, width: 0.5),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Icon(Icons.add,color: AppColors.primaryColor),
                )),
          ),
        ],
      ),
    );
  }
}
