import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/boilerplate/get_model/cubits/get_model_cubit.dart';
import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/expandable_text_widget.dart';
import 'package:centro_partner/core/ui/widgets/cached_image.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/ui/widgets/custom_sheet.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/project_utils/open_url.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/event/event_details_model.dart';
import 'package:centro_partner/features/home/data/model/event/event_model.dart';
import 'package:centro_partner/features/home/data/usecase/event/delete_event_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/event/event_details_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/event/toggle_activation_event_usecase.dart';
import 'package:centro_partner/features/home/ui/event/add_event_screen.dart';
import 'package:centro_partner/features/home/ui/workdays_screen.dart';
import 'package:centro_partner/features/home/widget/customers_sheet.dart';
import 'package:centro_partner/features/home/widget/images_slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventDetailsScreen extends StatefulWidget {

  final int eventId;
  final VoidCallback? onRefresh;

  const EventDetailsScreen({super.key,required this.eventId,this.onRefresh});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {

  GetModelCubit<EventModel>? refreshCubit;
  EventDetailsModel? eventDetailsModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: GetModel<EventModel>(
        onCubitCreated: (cubit) {
          refreshCubit = cubit as GetModelCubit<EventModel>;
        },
        useCaseCallBack: () {
          return EventDetailsUseCase(HomeRepository()).call(
              params: EventDetailsParams(eventId: widget.eventId));
        },
        onSuccess: (EventModel result) {
          setState(() {
            eventDetailsModel = result.event;
          });
        },
        modelBuilder: (model) => SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ImagesSliderWidget(imgList: model.event!.mediaList!),
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
                                  child: CreateModel(
                                    withValidation: false,
                                    onTap: () {},
                                    onSuccess: (model) async {
                                      Navigator.pop(context);
                                      refreshCubit?.getModel();
                                    },
                                    useCaseCallBack: (model) {
                                      return ToggleActivationEventUseCase(HomeRepository()).call(
                                          params: ToggleActivationEventParams(
                                              eventId: widget.eventId
                                          )
                                      );
                                    },
                                    child: Center(
                                      child: Text(
                                        AppLocalization.of(context).translate(
                                            model.event!.isActive == true ? "deactivate" : "activate"),
                                        style: AppTheme.bodyLarge,
                                      ),
                                    ),
                                  ),
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
                                    onTap: () => Navigation.push(AddEventScreen(
                                      isEdit: true,
                                      event: model.event,
                                      onRefresh: () async {
                                        refreshCubit?.getModel();
                                      },
                                    ))
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
                                    onTap: () => Navigation.push(WorkdaysScreen(
                                      ownerType: "event",
                                      ownerId: model.event!.iD!,
                                      onRefresh: () async {
                                        refreshCubit?.getModel();
                                      },
                                    ))
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
                                        btnOk: CreateModel(
                                          withValidation: false,
                                          onTap: () {},
                                          onSuccess: (model) async {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            widget.onRefresh?.call();
                                          },
                                          useCaseCallBack: (model) {
                                            return DeleteEventUseCase(HomeRepository()).call(
                                                params: DeleteEventParams(
                                                  eventId: widget.eventId
                                                )
                                            );
                                          },
                                          child: CustomButton(
                                            height: 40.h,
                                            width: 1.sw,
                                            backgroundColor: AppColors.redColor,
                                            borderRadius: 8.r,
                                            buttonName: AppLocalization.of(context).translate("ok"),
                                            textStyle: AppTheme.headlineSmall.copyWith(color: AppColors.whiteColor),
                                          ),
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
                          child: Text(model.event!.category!.name!,style: AppTheme.headlineMedium.copyWith(
                              fontSize: 24.sp
                          )),
                        ),
                        SizedBox(width: 10.w),
                        InkWell(
                          onTap: () {
                            String courseUrl = 'https://www.google.com/maps/search/?api=1&query=${model.event!.location!.long!},${model.event!.location!.lat!}';
                            OpenUrl.launchUrls(Uri.parse(courseUrl));
                          },
                          child: Text(AppLocalization.of(context).translate("show_map"),
                              style: AppTheme.titleLarge.copyWith(
                                  color: AppColors.turquoiseColor
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(model.event!.name!,style: AppTheme.labelLarge),
                        ),
                        SizedBox(width: 10.w),
                        Text("(${model.event!.capacity.toString()})",
                            style: AppTheme.headlineSmall.copyWith(
                                color: AppColors.primaryColor
                            )),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(star,color: AppColors.yellowColor,width: 15.w),
                              // todo later
                              Text(" 4.5 (200 ${AppLocalization.of(context).translate("reviews")})",
                                  style: AppTheme.labelMedium.copyWith(color: AppColors.mediumGrayColor)),
                            ],
                          ),
                        ),
                        Text(model.event!.admissionFee.toString(),
                          style: AppTheme.headlineSmall.copyWith(
                              color: AppColors.primaryColor,
                              fontSize: 24.sp
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    ExpandableTextWidget(
                      text: model.event!.description!,
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
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      text: AppLocalization.of(context).translate("withdrawal_fee"),
                                      style: AppTheme.headlineMedium,
                                      children: [
                                        TextSpan(text: " ${model.event!.withdrawalFee} ",
                                            style: AppTheme.headlineSmall.copyWith(color: AppColors.redColor)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      text: AppLocalization.of(context).translate("event_duration"),
                                      style: AppTheme.headlineMedium,
                                      children: [
                                        TextSpan(text: " ${model.event!.eventDuration} ",style: AppTheme.labelLarge.copyWith(fontSize: 18.sp)),
                                        TextSpan(
                                          text: AppLocalization.of(context).translate("day"),
                                          style: AppTheme.labelLarge.copyWith(fontSize: 18.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      text: AppLocalization.of(context).translate("start_date"),
                                      style: AppTheme.headlineMedium,
                                      children: [
                                        TextSpan(text: " ${convertDate(date: model.event!.startDate!,format: "dd/MM/yyyy")} ",style: AppTheme.labelLarge.copyWith(fontSize: 18.sp)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: model.event!.customersList!.isEmpty ? 0 : 10.h),
                    model.event!.customersList!.isEmpty ? Center() :
                    InkWell(
                          onTap: () {
                            CustomSheet.show(
                                isDismissible: true,
                                header: Text(AppLocalization.of(context).translate("participants"),
                                  style: AppTheme.titleLarge.copyWith(fontSize: 18.sp),
                                ),
                                padding: 30.w,
                                context: context,
                                child: CustomersSheet(customers: model.event!.customersList!)
                            );
                          },
                          child: Card(
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
                                    child: Text(AppLocalization.of(context).translate("participants"),
                                      style: AppTheme.headlineMedium,
                                    ),
                                  ),
                                  SizedBox(width: 10.h),
                                  Icon(Icons.arrow_circle_right_outlined,color: AppColors.turquoiseColor)
                                ],
                              ),
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
                                        itemCount: model.event!.workdaysList!.length,
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
                                                Flexible(child: Text(model.event!.workdaysList![index].day!,style: AppTheme.titleLarge.copyWith(color: AppColors.primaryColor))),
                                                Flexible(child: Text("${model.event!.workdaysList![index].start} - ${model.event!.workdaysList![index].end}",style: AppTheme.labelLarge)),
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
                    model.event!.facilitiesList!.isEmpty ? Center() :
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
                                        itemCount: model.event!.facilitiesList!.length,
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
                                                Flexible(child: CachedImage(imageUrl: model.event!.facilitiesList![index].icon!, fit: BoxFit.cover)),
                                                SizedBox(height: 10.h),
                                                Flexible(child: Text(model.event!.facilitiesList![index].name!,style: AppTheme.labelLarge.copyWith(color: AppColors.mediumGrayColor))),
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
              SizedBox(height: 10.h)
            ],
          ),
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
                  Text(AppLocalization.of(context).translate("end_date"),
                    style: AppTheme.bodyMedium,
                  ),
                  Text(eventDetailsModel == null ? "" : convertDate(date: eventDetailsModel!.endDate!,format: "dd/MM/yyyy"),
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
              child: Container(
                height: 40.h,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(5.r),
                  boxShadow: eventDetailsModel == null ? [] : [
                    BoxShadow(
                        color: eventDetailsModel!.status == "pending" ?
                        AppColors.mediumGrayColor : eventDetailsModel!.status == "canceled" ?
                        AppColors.redColor : eventDetailsModel!.status == "completed" ?
                        AppColors.turquoiseColor : AppColors.darkGreenColor,
                        spreadRadius: 0,
                        blurRadius: 3,
                        offset: const Offset(0,0)
                    )
                  ],
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
                    child: Text(eventDetailsModel == null ? "" : eventDetailsModel!.status!,
                      style: AppTheme.bodyLarge.copyWith(fontSize: 18.sp,color: eventDetailsModel == null ? null : eventDetailsModel!.status == "pending" ?
                      AppColors.mediumGrayColor : eventDetailsModel!.status == "canceled" ?
                      AppColors.redColor : eventDetailsModel!.status == "completed" ?
                      AppColors.turquoiseColor : AppColors.darkGreenColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}