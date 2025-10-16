import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/constants/enum/status_enum.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_container_info_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/ui/widgets/custom_date_picker.dart';
import 'package:centro_partner/core/ui/widgets/custom_drop_down.dart';
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
        CustomDropDown(
          width: 1.sw,
          height: 60.h,
          text: AppLocalization.of(context).translate("status"),
          value: selectedStatus,
          onChanged: (newValue) {
            setState(() {
              selectedStatus = newValue;
            });
          },
          items: StatusEnum.values.map((status) {
            return DropdownMenuItem<StatusEnum>(
              value: status,
              child: Row(
                children: [
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(status.name,
                      style: AppTheme.labelLarge.copyWith(fontSize: 18.sp),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 30.h),
        CustomButton(
          width: 1.sw,
          backgroundColor: AppColors.primaryColor,
          borderRadius: 10.r,
          buttonName: AppLocalization.of(context).translate("apply"),
          function: () {
            Navigator.pop(context,{selectedStatus,date == null ? null : convertDate(date: date.toString(),format: "yyyy-MM-dd")});
          },
        ),
        SizedBox(height: 30.h),
      ]
    );
  }
}
