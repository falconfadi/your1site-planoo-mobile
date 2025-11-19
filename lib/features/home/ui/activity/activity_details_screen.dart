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
import 'package:centro_partner/core/ui/widgets/custom_sheet.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/project_utils/open_url.dart';
import 'package:centro_partner/features/appointment/widget/book_activity_sheet.dart';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/activity/activity_details_model.dart';
import 'package:centro_partner/features/home/data/model/activity/activity_model.dart';
import 'package:centro_partner/features/home/data/model/review_model.dart';
import 'package:centro_partner/features/home/data/usecase/activity/activity_details_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/activity/delete_activity_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/activity/toggle_activation_activity_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/reviews_usecase.dart';
import 'package:centro_partner/features/home/ui/activity/add_activity_screen.dart';
import 'package:centro_partner/features/home/ui/workdays_screen.dart';
import 'package:centro_partner/features/home/widget/customers_sheet.dart';
import 'package:centro_partner/features/home/widget/images_slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivityDetailsScreen extends StatefulWidget {

  final int activityId;
  final VoidCallback? onRefresh;

  const ActivityDetailsScreen({super.key,required this.activityId,this.onRefresh});

  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {

  GetModelCubit<ActivityModel>? refreshCubit;
  ActivityDetailsModel? activityDetailsModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: GetModel<ActivityModel>(
        onCubitCreated: (cubit) {
          refreshCubit = cubit as GetModelCubit<ActivityModel>;
        },
        useCaseCallBack: () {
          return ActivityDetailsUseCase(HomeRepository()).call(
              params: ActivityDetailsParams(activityId: widget.activityId));
        },
        onSuccess: (ActivityModel result) {
          setState(() {
            activityDetailsModel = result.activity;
          });
        },
        modelBuilder: (model) => SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ImagesSliderWidget(imgList: model.activity!.mediaList!),
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
                                      return ToggleActivationActivityUseCase(HomeRepository()).call(
                                          params: ToggleActivationActivityParams(
                                              activityId: widget.activityId
                                          )
                                      );
                                    },
                                    child: Center(
                                      child: Text(
                                        AppLocalization.of(context).translate(
                                            model.activity!.isActive == true ? "deactivate" : "activate"),
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
                                    onTap: () => Navigation.push(AddActivityScreen(
                                      isEdit: true,
                                      activity: model.activity,
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
                                      ownerType: "activity",
                                      ownerId: model.activity!.iD!,
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
                                            return DeleteActivityUseCase(HomeRepository()).call(
                                                params: DeleteActivityParams(
                                                  activityId: widget.activityId
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
                          child: Text(model.activity!.category!.name!,style: AppTheme.headlineMedium.copyWith(
                              fontSize: 24.sp
                          )),
                        ),
                        SizedBox(width: 10.w),
                        InkWell(
                          onTap: () {
                            String activityUrl = 'https://www.google.com/maps/search/?api=1&query=${model.activity!.location!.long!},${model.activity!.location!.lat!}';
                            OpenUrl.launchUrls(Uri.parse(activityUrl));
                          },
                          child: Text(AppLocalization.of(context).translate("show_map"),
                              style: AppTheme.titleLarge.copyWith(
                                  color: AppColors.turquoiseColor
                              )),
                        ),
                      ],
                    ),
                    Text(model.activity!.name!,style: AppTheme.labelLarge),
                    SizedBox(height: 5.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(star,color: AppColors.yellowColor,width: 15.w),
                        Text(" ${model.activity!.rate.toString()} ",
                            style: AppTheme.labelLarge.copyWith(color: AppColors.mediumGrayColor)),
                        GetModel<ReviewModel>(
                          useCaseCallBack: () => ReviewsUseCase(HomeRepository()).call(
                              params: ReviewsParams(ownerType: "activity", ownerId: model.activity!.iD!)
                          ),
                          onError: (error) {
                            if (error.contains("Not found")) {
                              return ReviewModel(reviewsList: []);
                            }
                            return null;
                          },
                          modelBuilder: (reviewModel) => InkWell(
                            onTap: () {
                              if(reviewModel.reviewsList!.isNotEmpty) {
                                CustomSheet.show(
                                    isDismissible: true,
                                    header: Text(AppLocalization.of(context).translate("reviews"),
                                      style: AppTheme.titleLarge.copyWith(fontSize: 18.sp),
                                    ),
                                    padding: 30.w,
                                    context: context,
                                    child: CustomersSheet(forReview: false,customers: [],reviews: reviewModel.reviewsList)
                                );
                              }
                            },
                            child: Text("(${reviewModel.reviewsList!.length} ${AppLocalization.of(context).translate("reviews")})",
                                style: AppTheme.labelLarge.copyWith(color: reviewModel.reviewsList!.isEmpty ? AppColors.mediumGrayColor : AppColors.primaryColor)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    ExpandableTextWidget(
                      text: model.activity!.description!,
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
                                    TextSpan(text: " ${model.activity!.sessionDuration} ",style: AppTheme.labelLarge.copyWith(fontSize: 18.sp)),
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
                                        itemCount: model.activity!.workdaysList!.length,
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
                                                Flexible(child: Text(model.activity!.workdaysList![index].day!,style: AppTheme.titleLarge.copyWith(color: AppColors.primaryColor))),
                                                Flexible(child: Text("${model.activity!.workdaysList![index].start} - ${model.activity!.workdaysList![index].end}",style: AppTheme.labelLarge)),
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
                    model.activity!.facilitiesList!.isEmpty ? Center() :
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
                                        itemCount: model.activity!.facilitiesList!.length,
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
                                                Flexible(child: CachedImage(imageUrl: model.activity!.facilitiesList![index].icon!, fit: BoxFit.cover)),
                                                SizedBox(height: 10.h),
                                                Flexible(child: Text(model.activity!.facilitiesList![index].name!,style: AppTheme.labelLarge.copyWith(color: AppColors.mediumGrayColor))),
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
                  Text(AppLocalization.of(context).translate("price"),
                    style: AppTheme.bodyMedium,
                  ),
                  Text(activityDetailsModel == null ? "" : activityDetailsModel!.price.toString(),
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
                buttonName: AppLocalization.of(context).translate("book"),
                function: () {
                  if(activityDetailsModel != null) {
                    CustomSheet.show(
                        isDismissible: true,
                        header: Text(AppLocalization.of(context).translate("book"),
                          style: AppTheme.titleLarge.copyWith(fontSize: 18.sp),
                        ),
                        padding: 30.w,
                        context: context,
                        child: BookActivitySheet(activity: activityDetailsModel!)
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}