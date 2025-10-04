import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_container_info_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_switch_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/ui/widgets/custom_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';

class EditDaysSheet extends StatefulWidget {

  final List<Map<String,dynamic>> daysList;

  const EditDaysSheet({super.key,required this.daysList});

  @override
  State<EditDaysSheet> createState() => _EditDaysSheetState();
}

class _EditDaysSheetState extends State<EditDaysSheet> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 0.6.sh,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.daysList.length,
            itemBuilder: (context,index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5.w),
                padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
                decoration: BoxDecoration(
                  color: AppColors.lightGrayColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(widget.daysList[index]["day"],style: AppTheme.textTheme.bodyLarge!.copyWith(fontSize: 18.sp))),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: 25.h,
                                child: CustomSwitchWidget(activate: widget.daysList[index]["active"],scale: 0.6)
                            ),
                            InkWell(
                              onTap: () {
                                // todo delete day api
                              },
                              child: SvgPicture.asset(delete,color: AppColors.redColor),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              TimeOfDay? selected = await selectTime(context, widget.daysList[index]["from_time"]);
                              if (selected != null) {
                                setState(() {
                                  widget.daysList[index]["from_time"] = selected;
                                });
                              }
                            },
                            child: CustomContainerInfoWidget(
                              height: 45.h,
                              title: formatTime24(time: widget.daysList[index]["from_time"]),
                              textStyle: AppTheme.textTheme.labelLarge!.copyWith(fontSize: 18.sp),
                            ),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              TimeOfDay? selected = await selectTime(context, widget.daysList[index]["to_time"]);
                              if (selected != null) {
                                setState(() {
                                  widget.daysList[index]["to_time"] = selected;
                                });
                              }
                            },
                            child: CustomContainerInfoWidget(
                              height: 45.h,
                              title: formatTime24(time: widget.daysList[index]["to_time"]),
                              textStyle: AppTheme.textTheme.labelLarge!.copyWith(fontSize: 18.sp),
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
        ),
        CustomButton(
          backgroundColor: AppColors.primaryColor,
          borderRadius: 10.r,
          buttonName: AppLocalization.of(context).translate("edit"),
          function: () {
            // todo book api later
          },
        ),
        SizedBox(height: 30.h),
      ]
    );
  }
}
