import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/boilerplate/get_model/cubits/get_model_cubit.dart';
import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_container_info_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_switch_widget.dart';
import 'package:centro_partner/core/ui/widgets/coustom_sheet.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/ui/widgets/custom_time_picker.dart';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/workday/all_workdays_model.dart';
import 'package:centro_partner/features/home/data/usecase/workday/all_workdays_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/workday/delete_workday_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/workday/edit_workday_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/workday/toggle_activation_workday_usecase.dart';
import 'package:centro_partner/features/home/widget/create_workday_sheet.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';

class WorkdaysScreen extends StatefulWidget {

  final String ownerType;
  final int ownerId;

  const WorkdaysScreen({super.key,
    required this.ownerType,
    required this.ownerId,
  });

  @override
  State<WorkdaysScreen> createState() => _WorkdaysScreenState();
}

class _WorkdaysScreenState extends State<WorkdaysScreen> {

  GetModelCubit<AllWorkdaysModel>? refreshCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomHeader(title: "", isNavBar: false),
      body: GetModel<AllWorkdaysModel>(
        onCubitCreated: (cubit) {
          refreshCubit = cubit as GetModelCubit<AllWorkdaysModel>;
        },
        useCaseCallBack: () {
          return AllWorkdaysUseCase(HomeRepository()).call(
              params: AllWorkdaysParams(
                ownerType: widget.ownerType,
                ownerId: widget.ownerId
              ));
        },
        withAnimation: false,
        modelBuilder: (getModel) => SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
              children: [
                SizedBox(height: 20.h),
                InkWell(
                  onTap: () {
                    CustomSheet.show(
                        isDismissible: true,
                        header: Text(AppLocalization.of(context).translate("workday"),
                          style: AppTheme.titleLarge.copyWith(fontSize: 18.sp),
                        ),
                        padding: 30.w,
                        context: context,
                        child: CreateWorkdaySheet(
                          ownerType: widget.ownerType,
                          ownerId: widget.ownerId,
                          onRefresh: () async {
                            refreshCubit!.getModel();
                          },
                        )
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.add_circle_outline_outlined,color: AppColors.turquoiseColor),
                      SizedBox(width: 5.w),
                      Padding(
                        padding: EdgeInsets.only(top: 3.h),
                        child: Text(AppLocalization.of(context).translate("add"),
                          style: AppTheme.bodyLarge.copyWith(fontSize: 20.sp,color: AppColors.turquoiseColor),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: getModel.workdaysList!.length,
                  itemBuilder: (context,index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 15.w),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrayColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(getModel.workdaysList![index].day!,style: AppTheme.bodyLarge.copyWith(fontSize: 18.sp))),
                              SizedBox(
                                width: 45.w,
                                height: 25.h,
                                child: CreateModel(
                                  withValidation: false,
                                  onTap: () => true,
                                  onSuccess: (model) async {
                                    refreshCubit!.getModel();
                                  },
                                  useCaseCallBack: (model) {
                                    return ToggleActivationWorkdayUseCase(HomeRepository()).call(
                                      params: ToggleActivationWorkdayParams(
                                        ownerType: widget.ownerType,
                                        ownerId: widget.ownerId,
                                        dayId: getModel.workdaysList![index].iD!,
                                      ),
                                    );
                                  },
                                  child: AbsorbPointer(
                                    child: CustomSwitchWidget(
                                      activate: getModel.workdaysList![index].isActive!,
                                      scale: 0.7,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    TimeOfDay? selected = await selectTime(context, parseTimeOfDay(timeString: getModel.workdaysList![index].start ?? "00:00"));
                                    if (selected != null) {
                                      setState(() {
                                        String newTime = formatTime24(time: selected);
                                        getModel.workdaysList![index].start = newTime;
                                      });
                                    }
                                  },
                                  child: CustomContainerInfoWidget(
                                    height: 45.h,
                                    title: getModel.workdaysList![index].start!,
                                    textStyle: AppTheme.labelLarge.copyWith(fontSize: 18.sp),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    TimeOfDay? selected = await selectTime(context, parseTimeOfDay(timeString: getModel.workdaysList![index].end ?? "00:00"));
                                    if (selected != null) {
                                      setState(() {
                                        String newTime = formatTime24(time: selected);
                                        getModel.workdaysList![index].end = newTime;
                                      });
                                    }
                                  },
                                  child: CustomContainerInfoWidget(
                                    height: 45.h,
                                    title: getModel.workdaysList![index].end!,
                                    textStyle: AppTheme.labelLarge.copyWith(fontSize: 18.sp),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CreateModel(
                                  withValidation: false,
                                  onTap: () {},
                                  onSuccess: (model) async {
                                    refreshCubit!.getModel();
                                  },
                                  useCaseCallBack: (model) {
                                    return DeleteWorkdayUseCase(HomeRepository()).call(
                                        params: DeleteWorkdayParams(
                                          ownerType: widget.ownerType,
                                          ownerId: widget.ownerId,
                                          dayId: getModel.workdaysList![index].iD!,
                                        )
                                    );
                                  },
                                  child: CustomButton(
                                    height: 40.h,
                                    backgroundColor: AppColors.redColor,
                                    borderRadius: 10.r,
                                    buttonName: AppLocalization.of(context).translate("delete"),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: CreateModel(
                                  withValidation: false,
                                  onSuccess: (model) {
                                    refreshCubit!.getModel();
                                  },
                                  useCaseCallBack: (model) {
                                    return EditWorkdayUseCase(HomeRepository()).call(
                                        params: EditWorkdayParams(
                                          ownerType: widget.ownerType,
                                          ownerId: widget.ownerId,
                                          dayId: getModel.workdaysList![index].iD!,
                                          start: formatTime24(time: parseTimeOfDay(timeString: getModel.workdaysList![index].start!)),
                                          end: formatTime24(time: parseTimeOfDay(timeString: getModel.workdaysList![index].end!))
                                        ));
                                  },
                                  child: CustomButton(
                                    height: 40.h,
                                    backgroundColor: AppColors.primaryColor,
                                    borderRadius: 10.r,
                                    buttonName: AppLocalization.of(context).translate("edit"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 30.h),
              ]
          ),
        ),
      ),
    );
  }
}
