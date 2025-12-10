import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/expandable_text_widget.dart';
import 'package:centro_partner/core/ui/widgets/cached_image.dart';
import 'package:centro_partner/features/home/data/model/customer_model.dart';
import 'package:centro_partner/features/home/data/model/review_model.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomersSheet extends StatefulWidget {

  bool forReview;
  List<CustomerModel> customers;
  List<ReviewInfoModel>? reviews;

  CustomersSheet({super.key,this.forReview = true, required this.customers,this.reviews});

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
          itemCount: widget.forReview == false ? widget.reviews!.length : widget.customers.length,
          itemBuilder: (context,index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 5.h),
              padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
              decoration: BoxDecoration(
                color: AppColors.lightGrayColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CachedImage(
                        width: 45.w,
                        height: 45.w,
                        imageUrl: widget.forReview == false ?
                        widget.reviews![index].customer!.profileImage == null ? "" :  widget.reviews![index].customer!.profileImage!.url! :
                        widget.customers[index].profileImage == null ? "" :  widget.customers[index].profileImage!.url!,
                        fit: BoxFit.cover,
                        borderColor: AppColors.grayColor,
                        borderRadius: 40.r,
                        borderWidth: 1,
                        errorForUser: true,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(child: Text(widget.forReview == false ?
                      widget.reviews![index].customer!.name! :
                      widget.customers[index].name!,style: AppTheme.headlineSmall.copyWith(color: AppColors.primaryColor))),
                    ],
                  ),
                  SizedBox(height: widget.forReview == true ? 0 : 10.h),
                  widget.forReview == true ? Center() :
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: ExpandableTextWidget(
                        text: widget.reviews![index].content!,
                        style: AppTheme.bodyLarge.copyWith(fontSize: 18.sp)
                    ),
                  )

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

