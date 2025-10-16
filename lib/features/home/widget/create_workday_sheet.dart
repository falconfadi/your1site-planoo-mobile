import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_container_info_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_drop_down.dart';
import 'package:centro_partner/core/ui/widgets/custom_time_picker.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
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
  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10.h),
        GetModel<DaysModel>(
          useCaseCallBack: () {
            return DaysUseCase(HomeRepository()).call(params: DaysParams());
          },
          modelBuilder: (model) => CustomDropDown(
            width: 1.sw,
            height: 60.h,
            text: AppLocalization.of(context).translate("workday"),
            value: selectedDay,
            onChanged: (newValue) {
              setState(() {
                selectedDay = newValue;
              });
            },
            items: model.daysList!.map((day) {
              return DropdownMenuItem<String>(
                value: day,
                child: Row(
                  children: [
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(day,
                        style: AppTheme.labelLarge.copyWith(fontSize: 18.sp),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: selectedDay == null ? 0 : 20.h),
        selectedDay == null ? Center() :
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  TimeOfDay? selected = await selectTime(context, fromTime);
                  if (selected != null) {
                    setState(() {
                      fromTime = selected;
                    });
                  }
                },
                child: CustomContainerInfoWidget(
                  title: fromTime == null ? AppLocalization.of(context).translate("from_time") :
                  formatTime24(time: fromTime!),
                  textStyle: AppTheme.labelLarge.copyWith(fontSize: 18.sp,color: fromTime == null ?
                  AppColors.mediumGrayColor : AppColors.blackColor),
                ),
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: InkWell(
                onTap: () async {
                  TimeOfDay? selected = await selectTime(context, toTime);
                  if (selected != null) {
                    setState(() {
                      toTime = selected;
                    });
                  }
                },
                child: CustomContainerInfoWidget(
                  title: toTime == null ? AppLocalization.of(context).translate("to_time") :
                  formatTime24(time: toTime!),
                  textStyle: AppTheme.labelLarge.copyWith(fontSize: 18.sp,color: toTime == null ?
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
                    start: formatTime24(time: fromTime!),
                    end: formatTime24(time: toTime!),
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

