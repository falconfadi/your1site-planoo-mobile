import 'package:centro_partner/core/boilerplate/get_model/cubits/get_model_cubit.dart';
import 'package:centro_partner/core/classes/app_storage.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';
import 'package:centro_partner/features/appointment/ui/appointment_details_screen.dart';
import 'package:centro_partner/features/home/ui/course/course_details_screen.dart';
import 'package:centro_partner/features/home/ui/event/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/constants/enum/notification_type.dart';
import 'package:centro_partner/core/ui/widgets/loading.dart';
import 'package:centro_partner/features/notification/data/model/notifications_model.dart';
import 'package:centro_partner/features/notification/data/notification_repository/notification_repository.dart';
import 'package:centro_partner/features/notification/data/usecase/delete_notification_usecase.dart';
import 'package:centro_partner/features/notification/data/usecase/notifications_usecase.dart';
import 'package:centro_partner/features/notification/data/usecase/view_notification_usecase.dart';

class NotificationScreen extends StatefulWidget {

  final GlobalKey<ScaffoldState>? scaffoldKey;

  const NotificationScreen({super.key,this.scaffoldKey});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {

  GetModelCubit<NotificationsModel>? getCubit;

  Future viewNotification(bool isViewed,int notificationId) async {
    if(isViewed == false) {
      final result = await ViewNotificationUseCase(NotificationRepository()).call(
        params: ViewNotificationParams(notifications: [notificationId]),
      );
      if(result.hasDataOnly) {
        getCubit!.getModel();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomHeader(scaffoldKey: widget.scaffoldKey,title: AppLocalization.of(context).translate("notifications"),isNavBar: true),
      body: GetModel<NotificationsModel>(
        loading: SizedBox(
          height: 1.sh * 0.5,
          child: const LoadingIndicator(),
        ),
        onCubitCreated: (cubit) {
          getCubit = cubit as GetModelCubit<NotificationsModel>;
        },
        useCaseCallBack: () {
          return NotificationsUseCase(NotificationRepository()).call(params: NotificationsParams());
        },
        modelBuilder: (newModel) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 10.h),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: newModel.notificationsList!.length,
                itemBuilder: (context,index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.w),
                    child: InkWell(
                      onTap: () async {
                        final notification = newModel.notificationsList![index];
                        final notificationType = NotificationType.fromInt(notification.payload!.type!);

                        viewNotification(notification.isViewed!, notification.notificationId!);

                        switch (notificationType) {
                          case NotificationType.verificationCode:
                          case NotificationType.normal:
                            break;
                          case NotificationType.appointment:
                            Navigation.push(AppointmentDetailsScreen(appointmentId: notification.payload!.appointment!));
                            break;
                          case NotificationType.course:
                            Navigation.push(CourseDetailsScreen(courseId: newModel.notificationsList![index].payload!.course!));
                            break;
                          case NotificationType.event:
                            Navigation.push(EventDetailsScreen(eventId: newModel.notificationsList![index].payload!.event!));
                            break;
                          // todo add (activity - session - chat) cases later
                          default:
                            break;
                        }
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Container(
                          padding: EdgeInsets.all(15.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.lightGrayColor.withOpacity(0.5)),
                            color: newModel.notificationsList![index].isViewed == true ?
                            AppColors.whiteColor : AppColors.lightGrayColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(child: Text(newModel.notificationsList![index].title!, style: AppTheme.titleLarge.copyWith(color: AppColors.primaryColor))),
                                  SizedBox(width: 10.w),
                                  SizedBox(
                                    width: 15.w,
                                    height: 30.h,
                                    child: PopupMenuButton(
                                      padding: EdgeInsets.zero,
                                      color: AppColors.whiteColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(8.r)),
                                      ),
                                      elevation: 10,
                                      shadowColor: AppColors.blackColor,
                                      itemBuilder: (BuildContext context) => [
                                        PopupMenuItem(
                                          value: "Delete",
                                          child: CreateModel(
                                            withValidation: false,
                                            onTap: () async {},
                                            onSuccess: (data) {
                                              Navigator.pop(context);
                                              getCubit!.getModel();
                                            },
                                            useCaseCallBack: (data) {
                                              return DeleteNotificationUseCase(NotificationRepository()).call(
                                                params: DeleteNotificationParams(notificationId: newModel.notificationsList![index].notificationId!),
                                              );
                                            },
                                            child: Center(
                                              child: Text(
                                                AppLocalization.of(context).translate("delete"),
                                                style: AppTheme.titleLarge.copyWith(color: AppColors.redColor),
                                              ),
                                            ),
                                          ),
                                          onTap: () {},
                                        ),
                                      ],
                                      offset: Offset(AppStorage.languageCode == "ar" ? -15 : 15,30),
                                      onSelected: (value) {},
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Text(newModel.notificationsList![index].body!, style: AppTheme.bodyLarge),
                              SizedBox(height: 5.h),
                              Text(newModel.notificationsList![index].type!,
                                style: AppTheme.headlineSmall.copyWith(color: AppColors.turquoiseColor),
                              ),
                              SizedBox(height: 5.h),
                              Text(timeAgo(dateTimeStr: newModel.notificationsList![index].createdAt!, context: context),
                                style: AppTheme.headlineMedium.copyWith(fontSize: 14.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
