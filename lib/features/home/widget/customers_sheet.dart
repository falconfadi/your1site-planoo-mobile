import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/features/home/data/model/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomersSheet extends StatefulWidget {

  List<CustomerModel> customers;

  CustomersSheet({super.key, required this.customers});

  @override
  State<CustomersSheet> createState() => _CustomersSheetState();
}

class _CustomersSheetState extends State<CustomersSheet> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.customers.length,
          itemBuilder: (context,index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 5.h),
              padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
              decoration: BoxDecoration(
                color: AppColors.lightGrayColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.customers[index].name!,style: AppTheme.headlineSmall.copyWith(color: AppColors.primaryColor)),
                  Text(widget.customers[index].phone!,style: AppTheme.bodyLarge),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 30.h),
      ],
    );
  }
}

