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
  String? fromTime;
  String? toTime;

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
                onTap: () {
                  showCustomTimePicker(
                    context: context,
                    buttonLabel: "save",
                    initialTime: fromTime == null ? null : parseTimeOfDay(timeString: fromTime!),
                    onSaved: (selectedTime) {
                      setState(() {
                        fromTime = selectedTime;
                      });
                    },
                  );
                },
                child: CustomContainerInfoWidget(
                  title: fromTime ?? AppLocalization.of(context).translate("from_time"),
                  textStyle: AppTheme.labelLarge.copyWith(fontSize: 18.sp,color: fromTime == null ?
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
                    buttonLabel: "save",
                    initialTime: toTime == null ? null : parseTimeOfDay(timeString: toTime!),
                    onSaved: (selectedTime) {
                      setState(() {
                        toTime = selectedTime;
                      });
                    },
                  );
                },
                child: CustomContainerInfoWidget(
                  title: toTime ?? AppLocalization.of(context).translate("from_time"),
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

