import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_container_info_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/select_multi_items_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_time_picker.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/days_model.dart';
import 'package:centro_partner/features/home/data/usecase/days_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class WorkdaysWidget extends StatefulWidget {

  final Set<String> selectedDays;
  String? fromTime;
  String? toTime;
  final ValueChanged<String>? onFromTimeChanged;
  final ValueChanged<String>? onToTimeChanged;
  final ValueChanged<Set<String>>? onDaysChanged;

  WorkdaysWidget({super.key,
    required this.selectedDays,
    required this.fromTime,
    required this.toTime,
    this.onFromTimeChanged,
    this.onToTimeChanged,
    this.onDaysChanged
  });

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
          GetModel<DaysModel>(
            loadingHeight: 60.h,
            useCaseCallBack: () {
              return DaysUseCase(HomeRepository()).call(params: DaysParams());
            },
            modelBuilder: (model) => SelectMultiItemsWidget<String, String>(
              title: AppLocalization.of(context).translate("workdays"),
              list: model.daysList ?? [],
              selectedIds: widget.selectedDays,
              labelBuilder: (item) => item,
              idBuilder: (item) => item,
              onSelect: (ids) {
                // setState(() {
                //   widget.selectedDays.addAll(ids);
                // });
                widget.onDaysChanged!(ids.toSet());
              },
            )
          ),
          SizedBox(height: widget.selectedDays.isEmpty ? 0 : 20.h),
          widget.selectedDays.isEmpty ? Center() :
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    showCustomTimePicker(
                      context: context,
                      minTime: null,
                      initialTime: widget.fromTime == null ? null : parseTimeOfDay(timeString: widget.fromTime!),
                      buttonLabel: "save",
                      onSaved: (time) {
                        final newFrom =
                            "${time.hour.toString().padLeft(2, '0')}:"
                            "${time.minute.toString().padLeft(2, '0')}";

                        widget.onFromTimeChanged!(newFrom);

                        if (widget.toTime != null) {
                          final startMinutes = time.hour * 60 + time.minute;

                          // final end = parseTimeOfDay(timeString: widget.toTime!);
                          // final endMinutes = end.hour * 60 + end.minute;

                          final end = parseTimeOfDay(
                              timeString: widget.toTime!)
                              .hour *
                              60 +
                              parseTimeOfDay(
                                  timeString: widget.toTime!)
                                  .minute;

                          if (startMinutes > end) {
                            // setState(() {
                            //   widget.toTime = newFrom;
                            // });
                            widget.onToTimeChanged!(newFrom);
                          }
                        }

                        // setState(() {
                        //   widget.fromTime = newFrom;
                        // });
                      },
                    );
                  },
                  child: CustomContainerInfoWidget(
                    title: widget.fromTime ?? AppLocalization.of(context).translate("from_time"),
                    textStyle: AppTheme.labelLarge.copyWith(fontSize: 18.sp,color: widget.fromTime == null ?
                    AppColors.mediumGrayColor : AppColors.blackColor),
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showCustomTimePicker(
                      context: context,
                      minTime: widget.fromTime == null
                          ? null : parseTimeOfDay(timeString: widget.fromTime!),
                      initialTime: widget.toTime == null ? null : parseTimeOfDay(timeString: widget.toTime!),
                      buttonLabel: "save",
                      onSaved: (time) {
                        final newTo =
                            "${time.hour.toString().padLeft(2, '0')}:"
                            "${time.minute.toString().padLeft(2, '0')}";

                        widget.onToTimeChanged!(newTo);
                        // setState(() {
                        //   widget.toTime = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                        // });
                      },
                    );
                  },
                  child: CustomContainerInfoWidget(
                    title: widget.toTime ?? AppLocalization.of(context).translate("to_time"),
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