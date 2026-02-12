import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/boilerplate/get_model/cubits/get_model_cubit.dart';
import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart' as image;
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/constants/end_point.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_rating_bar.dart';
import 'package:centro_partner/core/ui/shared_widgets/icon_text_widget.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';
import 'package:centro_partner/features/appointment/data/appointment_repository/appointment_repository.dart';
import 'package:centro_partner/features/appointment/data/model/appointment_details_model.dart';
import 'package:centro_partner/features/appointment/data/usecase/appointment_details_usecase.dart';
import 'package:centro_partner/features/appointment/data/usecase/cancel_activity_appointment_usecase.dart';
import 'package:centro_partner/features/appointment/widget/status_widget.dart';
import 'package:centro_partner/core/ui/widgets/cached_image.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/project_utils/status_type.dart';
import 'package:centro_partner/features/home/ui/activity/activity_details_screen.dart';
import 'package:centro_partner/features/home/ui/course/course_details_screen.dart';
import 'package:centro_partner/features/home/ui/event/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AppointmentDetailsScreen extends StatefulWidget {

  int appointmentId;
  VoidCallback? onRefresh;

  AppointmentDetailsScreen({super.key,required this.appointmentId,this.onRefresh});

  @override
  State<AppointmentDetailsScreen> createState() => _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {

  GetModelCubit<AppointmentDetailsModel>? refreshCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: CustomHeader(
          title: "",
          isNavBar: false,
        ),
        body: GetModel<AppointmentDetailsModel>(
          onCubitCreated: (cubit) {
            refreshCubit = cubit as GetModelCubit<AppointmentDetailsModel>;
          },
          useCaseCallBack: () {
            return AppointmentDetailsUseCase(AppointmentRepository()).call(
                params: AppointmentDetailsParams(appointmentId: widget.appointmentId));
          },
          modelBuilder: (model) => SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                InkWell(
                  onTap: () {
                    if(model.holder!.type == "Activity") {
                      Navigation.push(ActivityDetailsScreen(activityId: model.holder!.id!));
                    } else if(model.holder!.type == "Course") {
                      Navigation.push(CourseDetailsScreen(courseId: model.holder!.id!));
                    } else {
                      Navigation.push(EventDetailsScreen(eventId: model.holder!.id!));
                    }
                  },
                  child: Card(
                    color: AppColors.whiteColor,
                    elevation: 3,
                    shadowColor: AppColors.gray2Color,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      margin: EdgeInsets.symmetric(vertical: 5.h,horizontal: 5.w),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedImage(
                            width: 1.sw,
                            height: 180.h,
                            imageUrl: model.holder!.holderImage != null ?
                            serverUrl + model.holder!.holderImage!.url! : "",
                            fit: BoxFit.cover,
                            borderRadius: 10.r,
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(model.holder!.name!,
                                    maxLines: 2,overflow: TextOverflow.ellipsis,
                                    style: AppTheme.headlineMedium),
                              ),
                              SizedBox(width: 10.w),
                              Text("${model.holder!.price} ${AppLocalization.of(context).translate("syr")}",
                                  style: AppTheme.headlineMedium.copyWith(color: AppColors.turquoiseColor)),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(model.holder!.category!.name!,
                                    maxLines: 2,overflow: TextOverflow.ellipsis,
                                    style: AppTheme.headlineSmall.copyWith(
                                        color: AppColors.primaryColor
                                    )
                                ),
                              ),
                              SizedBox(width: 5.w),
                              CustomRatingBar(rate: model.holder!.rate!.toDouble(),size: 18)
                            ],
                          ),
                          Text(model.holder!.description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.labelMedium.copyWith(color: AppColors.darkGrayColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Card(
                  color: AppColors.whiteColor,
                  elevation: 3,
                  shadowColor: AppColors.gray2Color,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalization.of(context).translate("about_appointment"),
                                style: AppTheme.headlineMedium,
                              ),
                              SizedBox(height: 20.h),
                              StatusWidget(
                                statusText: model.status!,
                                statusColor: StatusType().getStatusInfo(model.status!)["color"],
                                width: 0.25.sw,
                                height: 32.h,
                              ),
                              SizedBox(height: 20.h),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                                  child: IconTextWidget(
                                    icon: image.appointment,
                                    iconSize: 20.w,
                                    text: convertDate(date: model.date!,format: 'dd/MM/yyyy'),
                                    textStyle: AppTheme.labelLarge.copyWith(
                                        fontSize: 18.sp, color: AppColors.mediumGrayColor),
                                  )
                              ),
                              SizedBox(height: 10.h),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                                  child: IconTextWidget(
                                    icon: image.time,
                                    iconSize: 22.w,
                                    text: DateFormat("HH:mm").format(DateFormat("HH:mm:ss").parse(model.time!)),
                                    textStyle: AppTheme.labelLarge.copyWith(
                                        fontSize: 18.sp, color: AppColors.mediumGrayColor),
                                  )
                              ),
                              SizedBox(height: model.notes == null ? 0 : 10.h),
                              model.notes == null ? Center() :
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${AppLocalization.of(context).translate("note")}: ",
                                        style: AppTheme.headlineMedium,
                                      ),
                                      Expanded(
                                        child: Text(model.notes!,
                                          style: AppTheme.bodyLarge.copyWith(fontSize: 18.sp),
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                              SizedBox(height: model.holder!.type == "Activity" ? 10.h : 0),
                              model.holder!.type == "Activity" ?
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                                  child: Row(
                                    children: [
                                      CachedImage(
                                        width: 45.w,
                                        height: 45.w,
                                        imageUrl: model.customer!.profileImage == null ? "" :
                                        model.customer!.profileImage!.url!,
                                        fit: BoxFit.cover,
                                        borderColor: AppColors.grayColor,
                                        borderRadius: 10.r,
                                        borderWidth: 1,
                                        errorForUser: true,
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 5.h),
                                          child: Text(model.customer!.name!,
                                            style: AppTheme.headlineMedium.copyWith(
                                                color: AppColors.mediumGrayColor),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                              ) : Center(),
                              SizedBox(height: 20.h),
                              Row(
                                  children: [
                                    (model.holder!.type == "Activity" && model.status == "accepted") ? Expanded(
                                      child: CustomButton(
                                        height: 40.h,
                                        backgroundColor: AppColors.redColor,
                                        borderRadius: 10.r,
                                        buttonName: AppLocalization.of(context).translate("cancel"),
                                        function: () {
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
                                              onSuccess: (result) {
                                                Navigation.pop();
                                                refreshCubit!.getModel();
                                                widget.onRefresh?.call();
                                              },
                                              useCaseCallBack: (_) {
                                                return CancelActivityAppointmentUseCase(AppointmentRepository()).call(
                                                    params: CancelActivityAppointmentParams(appointmentId: model.iD!)
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
                                        },
                                      ),
                                    ) : Expanded(child: Center()),
                                    SizedBox(width: 20.w),
                                    Expanded(
                                      child: CustomButton(
                                        height: 40.h,
                                        backgroundColor: AppColors.turquoiseColor,
                                        borderRadius: 10.r,
                                        buttonName: AppLocalization.of(context).translate("ok"),
                                        function: () {
                                          Navigation.pop();
                                        },
                                      ),
                                    )
                                  ]
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50.h),
              ],
            ),
          ),
        )
    );
  }
}
