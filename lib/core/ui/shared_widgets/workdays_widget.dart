import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/constants/enum/days_enum.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_container_info_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/select_multi_items_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_time_picker.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class WorkdaysWidget extends StatefulWidget {

  final Set<String> selectedDays;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  WorkdaysWidget({super.key,required this.selectedDays,required this.fromTime,required this.toTime});

  @override
  State<WorkdaysWidget> createState() => _WorkdaysWidgetState();
}

class _WorkdaysWidgetState extends State<WorkdaysWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          SelectMultiItemsWidget<DaysEnum, String>(
            title: AppLocalization.of(context).translate("workdays"),
            list: DaysEnum.values,
            selectedIds: widget.selectedDays,
            labelBuilder: (item) => item.name,
            idBuilder: (item) => item.name,
            onSelect: (ids) {
              setState(() {
                widget.selectedDays.addAll(ids);
              });
            },
          ),
          SizedBox(height: widget.selectedDays.isEmpty ? 0 : 20.h),
          widget.selectedDays.isEmpty ? Center() :
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    TimeOfDay? selected = await selectTime(context, widget.fromTime);
                    if (selected != null) {
                      setState(() {
                        widget.fromTime = selected;
                      });
                    }
                  },
                  child: CustomContainerInfoWidget(
                    title: widget.fromTime == null ? AppLocalization.of(context).translate("from_time") :
                    formatTime24(time: widget.fromTime!),
                    textStyle: AppTheme.labelLarge.copyWith(fontSize: 18.sp,color: widget.fromTime == null ?
                    AppColors.mediumGrayColor : AppColors.blackColor),
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    TimeOfDay? selected = await selectTime(context, widget.toTime);
                    if (selected != null) {
                      setState(() {
                        widget.toTime = selected;
                      });
                    }
                  },
                  child: CustomContainerInfoWidget(
                    title: widget.toTime == null ? AppLocalization.of(context).translate("to_time") :
                    formatTime24(time: widget.toTime!),
                    textStyle: AppTheme.labelLarge.copyWith(fontSize: 18.sp,color: widget.toTime == null ?
                    AppColors.mediumGrayColor : AppColors.blackColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
