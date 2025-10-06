import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/expandable_text_widget.dart';
import 'package:centro_partner/core/ui/widgets/coustom_sheet.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';
import 'package:centro_partner/features/home/ui/add_activity_screen.dart';
import 'package:centro_partner/features/home/widget/edit_days_sheet.dart';
import 'package:centro_partner/features/home/widget/images_slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivityDetailsScreen extends StatefulWidget {

  const ActivityDetailsScreen({super.key});

  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {

  final List<String> imgList = [
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  final List<Map<String,dynamic>> workdaysList = [
    {"day":"Monday","from_time": TimeOfDay(hour: 10,minute: 00),"to_time": TimeOfDay(hour: 13,minute: 00),"active":true},
    {"day":"Tuesday","from_time": TimeOfDay(hour: 9,minute: 00),"to_time": TimeOfDay(hour: 15,minute: 00),"active":true},
    {"day":"wentesday","from_time": TimeOfDay(hour: 12,minute: 00),"to_time": TimeOfDay(hour: 16,minute: 30),"active":true},
    {"day":"Thursday","from_time": TimeOfDay(hour: 13,minute: 00),"to_time": TimeOfDay(hour: 17,minute: 45),"active":true},
    {"day":"Friday","from_time": TimeOfDay(hour: 14,minute: 00),"to_time": TimeOfDay(hour: 18,minute: 00),"active":true},
  ];

  final List<Map<String,dynamic>> facilitiesList = [
    {"icon": Icons.wifi,"name":"Wifi"},
    {"icon": Icons.local_cafe_outlined,"name":"Cafe"},
    {"icon": Icons.pool,"name":"Pool"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ImagesSliderWidget(imgList: imgList),
                Positioned(
                  right: 20,
                  left: 20,
                  top: 45.h,
                  child: SizedBox(
                    width: 1.sw,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Navigation.pop(),
                          child: Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(8.r)
                            ),
                            child: Icon(Icons.arrow_back_ios_new_rounded,size: 18),
                          ),
                        ),
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(8.r)
                          ),
                          child: PopupMenuButton(
                            icon: Icon(Icons.more_vert,size: 18),
                            offset: const Offset(0,40),
                            onSelected: (value) {},
                            color: AppColors.whiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8.r)),
                            ),
                            elevation: 5,
                            shadowColor: AppColors.lightGrayColor,
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem(
                                value: "",
                                height: 50.h,
                                child: Center(
                                  child: Text(
                                    AppLocalization.of(context).translate("activate"),
                                    // AppLocalization.of(context).translate("deactivate"),
                                    style: AppTheme.bodyLarge,
                                  ),
                                ),
                                onTap: () {
                                  // todo activate or deactivate
                                },
                              ),
                              PopupMenuItem(
                                  value: "",
                                  height: 50.h,
                                  child: Center(
                                    child: Text(
                                      AppLocalization.of(context).translate("edit"),
                                      style: AppTheme.bodyLarge,
                                    ),
                                  ),
                                  onTap: () => Navigation.push(AddActivityScreen(isEdit: true))
                              ),
                              PopupMenuItem(
                                  value: "",
                                  height: 50.h,
                                  child: Center(
                                    child: Text(
                                      AppLocalization.of(context).translate("edit_days"),
                                      style: AppTheme.bodyLarge,
                                    ),
                                  ),
                                  onTap: () {
                                    CustomSheet.show(
                                        isDismissible: true,
                                        header: Text(AppLocalization.of(context).translate("workdays"),
                                          style: AppTheme.titleLarge.copyWith(fontSize: 18.sp),
                                        ),
                                        padding: 30.w,
                                        context: context,
                                        child: EditDaysSheet(daysList: workdaysList)
                                    );
                                  }
                              ),
                              PopupMenuItem(
                                  value: "",
                                  height: 50.h,
                                  child: Center(
                                    child: Text(
                                      AppLocalization.of(context).translate("delete"),
                                      style: AppTheme.bodyLarge.copyWith(color: AppColors.redColor),
                                    ),
                                  ),
                                  onTap: () {
                                    Dialogs.showQuestion(context,
                                      title: "",content: Column(
                                        children: [
                                          ListTile(
                                            title: Text("${AppLocalization.of(context).translate("are_you_sure")}?",textAlign: TextAlign.center,
                                              style: AppTheme.headlineSmall.copyWith(color: AppColors.mediumGrayColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                      btnOk: CustomButton(
                                        height: 40.h,
                                        width: 1.sw,
                                        backgroundColor: AppColors.redColor,
                                        borderRadius: 8.r,
                                        buttonName: AppLocalization.of(context).translate("ok"),
                                        textStyle: AppTheme.headlineSmall.copyWith(color: AppColors.whiteColor),
                                        function: () {
                                          // todo delete api later
                                        },
                                      ),
                                    );
                                  }
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text("Tennis",style: AppTheme.headlineMedium.copyWith(
                          fontSize: 24.sp
                        )),
                      ),
                      SizedBox(width: 10.w),
                      InkWell(
                        onTap: () {
                          // todo check later
                          // String activityUrl = 'https://www.google.com/maps/search/?api=1&query=${model!.srcLong},${model!.srcLat}';
                          // OpenUrl.launchUrls(Uri.parse(activityUrl));
                        },
                        child: Text(AppLocalization.of(context).translate("show_map"),
                            style: AppTheme.titleLarge.copyWith(
                              color: AppColors.turquoiseColor
                        )),
                      ),
                    ],
                  ),
                  Text("Racket sport played on a rectangular court divided by a net",style: AppTheme.labelLarge),
                  SizedBox(height: 5.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(star,color: AppColors.yellowColor,width: 15.w),
                      Text(" 4.5 (200 ${AppLocalization.of(context).translate("reviews")})",
                          style: AppTheme.labelMedium.copyWith(color: AppColors.mediumGrayColor)),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  ExpandableTextWidget(
                      text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                    style: AppTheme.labelLarge,
                  ),
                  SizedBox(height: 10.h),
                  Card(
                    color: AppColors.whiteColor,
                    elevation: 3,
                    shadowColor: AppColors.gray2Color,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: AppLocalization.of(context).translate("session_duration"),
                                style: AppTheme.headlineMedium,
                                children: [
                                  TextSpan(text: " 30 ",style: AppTheme.labelLarge.copyWith(fontSize: 18.sp)),
                                  TextSpan(
                                    text: AppLocalization.of(context).translate("minute"),
                                    style: AppTheme.labelLarge.copyWith(fontSize: 18.sp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Card(
                    color: AppColors.whiteColor,
                    elevation: 3,
                    shadowColor: AppColors.gray2Color,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalization.of(context).translate("workdays"),
                                  style: AppTheme.headlineMedium,
                                ),
                                SizedBox(height: 10.h),
                                Container(
                                  color: AppColors.whiteColor,
                                    height: 80.h,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: workdaysList.length,
                                      itemBuilder: (context,index) {
                                        return Container(
                                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                                          padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
                                          decoration: BoxDecoration(
                                            color: AppColors.lightGrayColor,
                                            borderRadius: BorderRadius.circular(10.r),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Flexible(child: Text(workdaysList[index]["day"],style: AppTheme.titleLarge.copyWith(color: AppColors.primaryColor))),
                                              Flexible(child: Text("${formatTime24(time: workdaysList[index]["from_time"])} - ${formatTime24(time: workdaysList[index]["to_time"])}",style: AppTheme.labelLarge)),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                ),
                                SizedBox(height: 10.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Card(
                    color: AppColors.whiteColor,
                    elevation: 3,
                    shadowColor: AppColors.gray2Color,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalization.of(context).translate("facilities"),
                                  style: AppTheme.headlineMedium,
                                ),
                                SizedBox(height: 10.h),
                                Container(
                                    color: AppColors.whiteColor,
                                    height: 80.h,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: facilitiesList.length,
                                      itemBuilder: (context,index) {
                                        return Container(
                                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                                          padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 20.w),
                                          decoration: BoxDecoration(
                                            color: AppColors.lightGrayColor,
                                            borderRadius: BorderRadius.circular(10.r),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Flexible(child: Icon(facilitiesList[index]["icon"],color: AppColors.mediumGrayColor)),
                                              SizedBox(height: 10.h),
                                              Flexible(child: Text(facilitiesList[index]["name"],style: AppTheme.labelLarge.copyWith(color: AppColors.mediumGrayColor))),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                ),
                                SizedBox(height: 10.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h)
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: 1.sw,
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 15.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
                color: AppColors.grayColor,
                spreadRadius: 0,
                blurRadius: 8,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocalization.of(context).translate("price"),
                    style: AppTheme.bodyMedium,
                  ),
                  Text("\$199",
                    style: AppTheme.headlineSmall.copyWith(
                      color: AppColors.primaryColor,
                      fontSize: 24.sp
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              flex: 2,
              child: CustomButton(
                backgroundColor: AppColors.primaryColor,
                borderRadius: 10.r,
                buttonName: AppLocalization.of(context).translate("add"),
                function: () {
                  // todo book api later
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}