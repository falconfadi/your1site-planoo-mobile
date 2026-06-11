import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/constants/enum/status_enum.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_container_info_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/ui/widgets/custom_date_picker.dart';
import 'package:centro_partner/core/ui/widgets/custom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';

class FilterSheet extends StatefulWidget {

  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {

  StatusEnum? selectedStatus;
  DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            DateTime? selectedDate = await selectDate(context, date);
            if (selectedDate != null) {
              setState(() {
                date = selectedDate;
              });
            }
          },
          child: CustomContainerInfoWidget(
            title: date == null ? AppLocalization.of(context).translate("date") : convertDate(date: date.toString()),
            textStyle: AppTheme.labelLarge.copyWith(fontSize: 18.sp,color: date == null ?
            AppColors.mediumGrayColor : AppColors.blackColor),
          ),
        ),
        SizedBox(height: 20.h),
        InkWell(
          onTap: () async {
            CustomSheet.show(
                isDismissible: true,
                header: Text(AppLocalization.of(context).translate("status"),
                  style: AppTheme.titleLarge.copyWith(fontSize: 18.sp),
                ),
                padding: 30.w,
                context: context,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StatefulBuilder(
                        builder: (context, setSheetState) {
                        return ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: StatusEnum.values.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setSheetState(() {
                                  selectedStatus = StatusEnum.values[index];
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                                margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: selectedStatus == StatusEnum.values[index] ?
                                  AppColors.primaryColor.withOpacity(0.3) :
                                      AppColors.extraLightGrayColor,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: Center(
                                    child: Text(StatusEnum.values[index].name,
                                      style: AppTheme.labelLarge.copyWith(fontSize: 18.sp),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    ),
                    SizedBox(height: 20.h),
                    CustomButton(
                      width: 1.sw,
                      backgroundColor: AppColors.primaryColor,
                      borderRadius: 10.r,
                      buttonName: AppLocalization.of(context).translate("save"),
                      function: () {
                        Navigator.pop(context);
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
            );
          },
          child: CustomContainerInfoWidget(
            title: selectedStatus == null ? AppLocalization.of(context).translate("status") :
            selectedStatus!.name,
            textStyle: AppTheme.labelLarge.copyWith(fontSize: 18.sp,color: selectedStatus == null ?
            AppColors.mediumGrayColor : AppColors.blackColor),
          ),
        ),
        SizedBox(height: 30.h),
        CustomButton(
          width: 1.sw,
          backgroundColor: AppColors.primaryColor,
          borderRadius: 10.r,
          buttonName: AppLocalization.of(context).translate("apply"),
          function: () {
            if(selectedStatus == null && date == null) {
              Navigator.pop(context);
            } else {
              Navigator.pop(context,{selectedStatus,date == null ? null : convertDate(date: date.toString(),format: "yyyy-MM-dd")});
            }
          },
        ),
        SizedBox(height: 30.h),
      ]
    );
  }
}
