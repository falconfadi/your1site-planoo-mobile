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
import 'package:centro_partner/core/utils/project_utils/string_utils.dart';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/course/course_details_model.dart';
import 'package:centro_partner/features/home/data/model/course/course_model.dart';
import 'package:centro_partner/features/home/data/model/review_model.dart';
import 'package:centro_partner/features/home/data/usecase/course/course_details_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/course/delete_course_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/course/toggle_activation_course_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/reviews_usecase.dart';
import 'package:centro_partner/features/home/ui/course/add_course_screen.dart';
import 'package:centro_partner/features/home/ui/workdays_screen.dart';
import 'package:centro_partner/features/home/widget/customers_sheet.dart';
import 'package:centro_partner/features/home/widget/images_slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CourseDetailsScreen extends StatefulWidget {

  final int courseId;
  final VoidCallback? onRefresh;

  const CourseDetailsScreen({super.key,required this.courseId,this.onRefresh});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {

  GetModelCubit<CourseModel>? refreshCubit;
  CourseDetailsModel? courseDetailsModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: GetModel<CourseModel>(
        onCubitCreated: (cubit) {
          refreshCubit = cubit as GetModelCubit<CourseModel>;
        },
        useCaseCallBack: () {
          return CourseDetailsUseCase(HomeRepository()).call(
              params: CourseDetailsParams(courseId: widget.courseId));
        },
        onSuccess: (CourseModel result) {
          setState(() {
            courseDetailsModel = result.course;
          });
        },
        modelBuilder: (model) => SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ImagesSliderWidget(imgList: model.course!.mediaList!),
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
                                      return ToggleActivationCourseUseCase(HomeRepository()).call(
                                          params: ToggleActivationCourseParams(
                                              courseId: widget.courseId
                                          )
                                      );
                                    },
                                    child: Center(
                                      child: Text(
                                        AppLocalization.of(context).translate(
                                            model.course!.isActive == true ? "deactivate" : "activate"),
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
                                    onTap: () => Navigation.push(AddCourseScreen(
                                      isEdit: true,
                                      course: model.course,
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
                                      ownerType: "course",
                                      ownerId: model.course!.iD!,
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
                                            return DeleteCourseUseCase(HomeRepository()).call(
                                                params: DeleteCourseParams(
                                                  courseId: widget.courseId
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
                          child: Text(model.course!.category!.name!,style: AppTheme.headlineMedium.copyWith(
                              fontSize: 24.sp
                          )),
                        ),
                        SizedBox(width: 10.w),
                        InkWell(
                          onTap: () {
                            String courseUrl = 'https://www.google.com/maps/search/?api=1&query=${model.course!.location!.long!},${model.course!.location!.lat!}';
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
                          child: Text(model.course!.name!,style: AppTheme.labelLarge),
                        ),
                        SizedBox(width: 10.w),
                        Text("(${model.course!.capacity.toString()})",
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
                              Text(" ${model.course!.rate.toString()} ",
                                  style: AppTheme.labelLarge.copyWith(color: AppColors.mediumGrayColor)),
                              GetModel<ReviewModel>(
                                useCaseCallBack: () => ReviewsUseCase(HomeRepository()).call(
                                    params: ReviewsParams(ownerType: "course", ownerId: model.course!.iD!)
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
                                  child: Text("(${truncateNumber(reviewModel.reviewsList!.length,maxLength: 5)} ${AppLocalization.of(context).translate("reviews")})",
                                      style: AppTheme.labelLarge.copyWith(color: reviewModel.reviewsList!.isEmpty ? AppColors.mediumGrayColor : AppColors.primaryColor)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text("${model.course!.price} ${AppLocalization.of(context).translate("syr")}",
                          style: AppTheme.headlineSmall.copyWith(
                              color: AppColors.primaryColor,
                              fontSize: 24.sp
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    ExpandableTextWidget(
                      text: model.course!.description!,
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
                                      text: AppLocalization.of(context).translate("cancellation_fee"),
                                      style: AppTheme.headlineMedium,
                                      children: [
                                        TextSpan(text: " ${model.course!.cancellationFee} ${AppLocalization.of(context).translate("syr")}",
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
                                      text: AppLocalization.of(context).translate("course_duration"),
                                      style: AppTheme.headlineMedium,
                                      children: [
                                        TextSpan(text: " ${model.course!.courseDuration} ",style: AppTheme.labelLarge.copyWith(fontSize: 18.sp)),
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
                                      text: AppLocalization.of(context).translate("session_duration"),
                                      style: AppTheme.headlineMedium,
                                      children: [
                                        TextSpan(text: " ${model.course!.sessionDuration} ",style: AppTheme.labelLarge.copyWith(fontSize: 18.sp)),
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
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: model.course!.customersList!.isEmpty ? 0 : 10.h),
                    model.course!.customersList!.isEmpty ? Center() :
                    InkWell(
                      onTap: () {
                        CustomSheet.show(
                            isDismissible: true,
                            header: Text(AppLocalization.of(context).translate("participants"),
                              style: AppTheme.titleLarge.copyWith(fontSize: 18.sp),
                            ),
                            padding: 30.w,
                            context: context,
                            child: CustomersSheet(customers: model.course!.customersList!)
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
                                        itemCount: model.course!.workdaysList!.length,
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
                                                Flexible(child: Text(model.course!.workdaysList![index].day!,style: AppTheme.titleLarge.copyWith(color: AppColors.primaryColor))),
                                                Flexible(child: Text("${model.course!.workdaysList![index].start} - ${model.course!.workdaysList![index].end}",style: AppTheme.labelLarge)),
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
                    model.course!.facilitiesList!.isEmpty ? Center() :
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
                                        itemCount: model.course!.facilitiesList!.length,
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
                                                Flexible(child: CachedImage(imageUrl: model.course!.facilitiesList![index].icon!, fit: BoxFit.cover)),
                                                SizedBox(height: 10.h),
                                                Flexible(child: Text(model.course!.facilitiesList![index].name!,style: AppTheme.labelLarge.copyWith(color: AppColors.mediumGrayColor))),
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
              SizedBox(height: 30.h)
            ],
          ),
        ),
      ),
    );
  }
}