import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/boilerplate/get_model/cubits/get_model_cubit.dart';
import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/classes/app_storage.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_back_icon_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_popup_menu_button_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_row_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/expandable_text_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/ui/widgets/custom_sheet.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/project_utils/open_url.dart';
import 'package:centro_partner/core/utils/project_utils/string_utils.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/event/event_model.dart';
import 'package:centro_partner/features/home/data/model/review_model.dart';
import 'package:centro_partner/features/home/data/usecase/event/delete_event_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/event/event_details_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/event/toggle_activation_event_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/reviews_usecase.dart';
import 'package:centro_partner/features/home/ui/event/add_event_screen.dart';
import 'package:centro_partner/features/home/ui/workdays_screen.dart';
import 'package:centro_partner/features/home/widget/customers_sheet.dart';
import 'package:centro_partner/features/home/widget/facilities_preview_widget.dart';
import 'package:centro_partner/features/home/widget/images_slider_widget.dart';
import 'package:centro_partner/features/home/widget/workdays_preview_widget.dart';
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
  bool isExpanded = false;
  ScrollController scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 150,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
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
        onSuccess: (EventModel result) {},
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
                            ]
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
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
                            String courseUrl = 'https://www.google.com/maps/search/?api=1&query=${model.event!.location!.lat!},${model.event!.location!.long!}';
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
                              Text(" ${model.event!.rate.toString()} ",
                                  style: AppTheme.labelLarge.copyWith(color: AppColors.mediumGrayColor)),
                              GetModel<ReviewModel>(
                                useCaseCallBack: () => ReviewsUseCase(HomeRepository()).call(
                                    params: ReviewsParams(ownerType: "event", ownerId: model.event!.iD!)
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
                        Text("${model.event!.admissionFee} ${AppLocalization.of(context).translate("syr")}",
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
                        padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                                if(isExpanded) {
                                  Future.delayed(const Duration(milliseconds: 300), () {
                                    _scrollToBottom();
                                  });
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 5.h),
                                      child: Text(AppLocalization.of(context).translate("details"),
                                        style: AppTheme.headlineMedium,
                                      ),
                                    ),
                                  ),
                                  Icon(isExpanded ? Icons.arrow_circle_down_outlined :
                                  AppStorage.languageCode == "ar" ?
                                  Icons.arrow_circle_left_outlined :
                                  Icons.arrow_circle_right_outlined,color: AppColors.turquoiseColor,
                                    size: isTablet ? 22.sp : null,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: !isExpanded ? 0 : 20.h),
                            AnimatedSize(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: isExpanded
                                  ? Column(
                                children: [
                                  CustomRowWidget(title: AppLocalization.of(context).translate("cancellation_fee"),
                                      subTitle: "${model.event!.withdrawalFee} ${AppLocalization.of(context).translate("syr")}",
                                    titleTextStyle: AppTheme.headlineSmall,
                                    subTitleTextStyle: AppTheme.headlineSmall.copyWith(color: AppColors.redColor),
                                  ),
                                  SizedBox(height: 5.h),
                                  CustomRowWidget(title: AppLocalization.of(context).translate("event_duration"),
                                    subTitle: "${model.event!.eventDuration} ${AppLocalization.of(context).translate("day")}",
                                    titleTextStyle: AppTheme.headlineSmall,
                                    subTitleTextStyle: AppTheme.bodyLarge.copyWith(fontSize: 18.sp),
                                  ),
                                  SizedBox(height: 5.h),
                                  CustomRowWidget(title: AppLocalization.of(context).translate("start_date"),
                                    subTitle: convertDate(date: model.event!.startDate!,format: "dd/MM/yyyy"),
                                    titleTextStyle: AppTheme.headlineSmall,
                                    subTitleTextStyle: AppTheme.bodyLarge.copyWith(fontSize: 18.sp),
                                  ),
                                  SizedBox(height: 5.h),
                                  CustomRowWidget(title: AppLocalization.of(context).translate("end_date"),
                                    subTitle: convertDate(date: model.event!.endDate!,format: "dd/MM/yyyy"),
                                    titleTextStyle: AppTheme.headlineSmall,
                                    subTitleTextStyle: AppTheme.headlineSmall.copyWith(color: AppColors.primaryColor),
                                  ),
                                  SizedBox(height: 5.h),
                                  CustomRowWidget(title: AppLocalization.of(context).translate("status"),
                                    subTitle: model.event!.status!,
                                    titleTextStyle: AppTheme.headlineSmall,
                                    subTitleTextStyle: AppTheme.headlineSmall.copyWith(
                                        color: model.event!.status == "pending" ?
                                        AppColors.mediumGrayColor : model.event!.status == "canceled" ?
                                        AppColors.redColor : model.event!.status == "completed" ?
                                        AppColors.turquoiseColor : AppColors.darkGreenColor
                                    ),
                                  ),
                                ],
                              ) : const SizedBox.shrink(),

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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 5.h),
                                  child: Text(AppLocalization.of(context).translate("participants"),
                                    style: AppTheme.headlineMedium,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.h),
                              Icon(AppStorage.languageCode == "ar" ? Icons.arrow_circle_left_outlined :
                              Icons.arrow_circle_right_outlined,color: AppColors.turquoiseColor,
                                size: isTablet ? 22.sp : null,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    WorkdaysPreviewWidget(workdaysList: model.event!.workdaysList!),
                    SizedBox(height: 10.h),
                    model.event!.facilitiesList!.isEmpty ? Center() :
                    FacilitiesPreviewWidget(facilitiesList: model.event!.facilitiesList!),
                  ],
                ),
              ),
              SizedBox(height: 40.h)
            ],
          ),
        ),
      ),
    );
  }
}