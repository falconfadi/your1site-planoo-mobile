import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';

class CustomDropDown extends StatelessWidget  {

  final double width;
  final double height;
  final String text;
  final dynamic value;
  final List<DropdownMenuItem<dynamic>>? items;
  final void Function(dynamic)? onChanged;


  const CustomDropDown({super.key,
    required this.width,
    required this.height,
    required this.text,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.blackColor,width: 0.5)
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 15.w,right: 10.w,top: 5.h),
          child: Theme(
            data: Theme.of(context).copyWith(
              focusColor: AppColors.extraLightGrayColor,
            ),
            child: DropdownButton(
                dropdownColor: AppColors.whiteColor,
                isExpanded: true,
                hint: Text(text, style: AppTheme.textTheme.labelLarge!.copyWith(fontSize: 18.sp,color: AppColors.mediumGrayColor)),
                icon: const Icon(Icons.keyboard_arrow_down_outlined,size: 22),
                iconEnabledColor: AppColors.grayColor,
                value: value,
                items: items,
                underline: Container(),
                onChanged: onChanged,
            ),
          ),
        )
    );
  }

}
