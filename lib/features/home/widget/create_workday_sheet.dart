import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_container_info_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/select_single_item_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_time_picker.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/days_model.dart';
import 'package:centro_partner/features/home/data/usecase/days_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/workday/create_workday_usecase.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateWorkdaySheet extends StatefulWidget {

  final String ownerType;
  final int ownerId;
  final VoidCallback onRefresh;

  const CreateWorkdaySheet({super.key,
    required this.ownerType,
    required this.ownerId,
    required this.onRefresh,
  });

  @override
  State<CreateWorkdaySheet> createState() => _CreateWorkdaySheetState();
}

class _CreateWorkdaySheetState extends State<CreateWorkdaySheet> {

  String? selectedDay;
  String? fromTime;
  String? toTime;

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10.h),
        GetModel<DaysModel>(
          useCaseCallBack: () {
            return DaysUseCase(HomeRepository()).call(params: DaysParams());
          },
          modelBuilder: (model) => SelectSingleItemWidget<String, String>(
            title: selectedDay ?? AppLocalization.of(context).translate("workday"),
            titleColor: selectedDay == null
                ? AppColors.mediumGrayColor
                : AppColors.blackColor,
            list: model.daysList!,
            selectedId: selectedDay,
            labelBuilder: (item) => item,
            idBuilder: (item) => item,
            onSelect: (id) {
              setState(() {
                selectedDay = id;
              });
            },
          ),
        ),
        SizedBox(height: selectedDay == null ? 0 : 20.h),
        selectedDay == null ? Center() :
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  showCustomTimePicker(
                    context: context,
                    minTime: null,
                    initialTime: fromTime == null ? null : parseTimeOfDay(timeString: fromTime!),
                    onSaved: (time) {
                      final newFrom =
                          "${time.hour.toString().padLeft(2, '0')}:"
                          "${time.minute.toString().padLeft(2, '0')}";

                      if (toTime != null) {
                        final startMinutes = time.hour * 60 + time.minute;

                        final end = parseTimeOfDay(timeString: toTime!);
                        final endMinutes = end.hour * 60 + end.minute;

                        if (startMinutes > endMinutes) {
                          setState(() {
                            toTime = newFrom;
                          });
                        }
                      }

                      setState(() {
                        fromTime = newFrom;
                      });
                    },
                    buttonLabel: "save",
                  );
                },
                child: CustomContainerInfoWidget(
                  title: fromTime ?? AppLocalization.of(context).translate("from_time"),
                  textStyle: AppTheme.labelLarge.copyWith(fontSize: isTablet ? 14.sp : 18.sp,color: fromTime == null ?
                  AppColors.mediumGrayColor : AppColors.blackColor),
                ),
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: InkWell(
                onTap: () {
                  showCustomTimePicker(
                    minTime: parseTimeOfDay(timeString: fromTime!),
                    context: context,
                    buttonLabel: "save",
                    initialTime: toTime == null ? null : parseTimeOfDay(timeString: toTime!),
                    onSaved: (time) {
                      setState(() {
                        toTime = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                      });
                    },
                  );
                },
                child: CustomContainerInfoWidget(
                  title: toTime ?? AppLocalization.of(context).translate("from_time"),
                  textStyle: AppTheme.labelLarge.copyWith(fontSize: isTablet ? 14.sp : 18.sp,color: toTime == null ?
                  AppColors.mediumGrayColor : AppColors.blackColor),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 50.h),
        CreateModel(
          withValidation: false,
          onSuccess: (model) {
            Navigation.pop();
            widget.onRefresh.call();
          },
          useCaseCallBack: (model) {
            if(selectedDay == null || fromTime == null || toTime == null) {}
            else {
              return CreateWorkdayUseCase(HomeRepository()).call(
                  params: CreateWorkdayParams(
                    ownerType: widget.ownerType,
                    ownerId: widget.ownerId,
                    day: selectedDay!,
                    start: fromTime!,
                    end: toTime!,
                  ));
            }
          },
          child: CustomButton(
            width: 1.sw,
            backgroundColor: (selectedDay == null || fromTime == null || toTime == null) ?
            AppColors.grayColor : AppColors.primaryColor,
            borderRadius: 10.r,
            buttonName: AppLocalization.of(context).translate("add"),
          ),
        ),
        SizedBox(height: 30.h),
      ],
    );
  }
}
