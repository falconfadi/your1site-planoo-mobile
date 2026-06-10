import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/boilerplate/get_model/cubits/get_model_cubit.dart';
import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_back_icon_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_popup_menu_button_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/expandable_text_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_sheet.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/project_utils/open_url.dart';
import 'package:centro_partner/features/appointment/widget/book_court_sheet.dart';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/court/court_details_model.dart';
import 'package:centro_partner/features/home/data/model/court/court_model.dart';
import 'package:centro_partner/features/home/data/model/review_model.dart';
import 'package:centro_partner/features/home/data/usecase/court/court_details_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/court/delete_court_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/court/toggle_activation_court_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/reviews_usecase.dart';
import 'package:centro_partner/features/home/ui/court/add_court_screen.dart';
import 'package:centro_partner/features/home/ui/workdays_screen.dart';
import 'package:centro_partner/features/home/widget/customers_sheet.dart';
import 'package:centro_partner/features/home/widget/facilities_preview_widget.dart';
import 'package:centro_partner/features/home/widget/images_slider_widget.dart';
import 'package:centro_partner/features/home/widget/workdays_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CourtDetailsScreen extends StatefulWidget {

  final int courtId;
  final VoidCallback? onRefresh;

  const CourtDetailsScreen({super.key,required this.courtId,this.onRefresh});

  @override
  State<CourtDetailsScreen> createState() => _CourtDetailsScreenState();
}

class _CourtDetailsScreenState extends State<CourtDetailsScreen> {

  GetModelCubit<CourtModel>? refreshCubit;
  CourtDetailsModel? courtDetailsModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: GetModel<CourtModel>(
        onCubitCreated: (cubit) {
          refreshCubit = cubit as GetModelCubit<CourtModel>;
        },
        useCaseCallBack: () {
          return CourtDetailsUseCase(HomeRepository()).call(
              params: CourtDetailsParams(courtId: widget.courtId));
        },
        onSuccess: (CourtModel result) {
          setState(() {
            courtDetailsModel = result.court;
          });
        },
        modelBuilder: (model) => SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ImagesSliderWidget(imgList: model.court!.mediaList!),
                  Positioned(
                    right: 20,
                    left: 20,
                    top: 45.h,
                    child: SizedBox(
                      width: 1.sw,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomBackIconWidget(),
                          CustomPopupMenuButtonWidget(
                            itemBuilder: [
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
                                    return ToggleActivationCourtUseCase(HomeRepository()).call(
                                        params: ToggleActivationCourtParams(
                                            courtId: widget.courtId
                                        )
                                    );
                                  },
                                  child: Center(
                                    child: Text(
                                      AppLocalization.of(context).translate(
                                          model.court!.isActive == true ? "deactivate" : "activate"),
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
                                  onTap: () => Navigation.push(AddCourtScreen(
                                    isEdit: true,
                                    court: model.court,
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
                                    ownerId: model.court!.iD!,
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
                                            title: Text(AppLocalization.of(context).translate("are_you_sure") +
                                                AppLocalization.of(context).translate("?"),
                                              textAlign: TextAlign.center,
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
                                          return DeleteCourtUseCase(HomeRepository()).call(
                                              params: DeleteCourtParams(
                                                  courtId: widget.courtId
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
                          child: Text(model.court!.category!.name!,style: AppTheme.headlineMedium.copyWith(
                              fontSize: 24.sp
                          )),
                        ),
                        SizedBox(width: 10.w),
                        InkWell(
                          onTap: () {
                            String courtUrl = 'https://www.google.com/maps/search/?api=1&query=${model.court!.location!.lat!},${model.court!.location!.long!}';
                            OpenUrl.launchUrls(Uri.parse(courtUrl));
                          },
                          child: Text(AppLocalization.of(context).translate("show_map"),
                              style: AppTheme.titleLarge.copyWith(
                                  color: AppColors.turquoiseColor
                              )),
                        ),
                      ],
                    ),
                    Text(model.court!.name!,style: AppTheme.labelLarge),
                    SizedBox(height: 5.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(star,color: AppColors.yellowColor,width: 15.w),
                        Text(" ${model.court!.rate.toString()} ",
                            style: AppTheme.labelLarge.copyWith(color: AppColors.mediumGrayColor)),
                        Expanded(
                          child: GetModel<ReviewModel>(
                            useCaseCallBack: () => ReviewsUseCase(HomeRepository()).call(
                                params: ReviewsParams(ownerType: "activity", ownerId: model.court!.iD!)
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
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    ExpandableTextWidget(
                      text: model.court!.description!,
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
                                    TextSpan(text: " ${model.court!.sessionDuration} ",style: AppTheme.labelLarge.copyWith(fontSize: 18.sp)),
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
                    WorkdaysPreviewWidget(workdaysList: model.court!.workdaysList!),
                    SizedBox(height: 10.h),
                    model.court!.facilitiesList!.isEmpty ? Center() :
                    FacilitiesPreviewWidget(facilitiesList: model.court!.facilitiesList!),
                  ],
                ),
              ),
              SizedBox(height: 20.h)
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
                  Text(courtDetailsModel == null ? "" : "${courtDetailsModel!.price} ${AppLocalization.of(context).translate("syr")}",
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
                  if(courtDetailsModel != null) {
                    CustomSheet.show(
                        isDismissible: true,
                        header: Text(AppLocalization.of(context).translate("book"),
                          style: AppTheme.titleLarge.copyWith(fontSize: 18.sp),
                        ),
                        padding: 30.w,
                        context: context,
                        child: BookCourtSheet(court: courtDetailsModel!)
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