import 'dart:convert';
import 'package:centro_partner/core/boilerplate/get_model/cubits/get_model_cubit.dart';
import 'package:centro_partner/core/classes/app_storage.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';
import 'package:centro_partner/features/appointment/ui/court_appointment_details_screen.dart';
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
  final VoidCallback? onNotificationsUpdated;

  const NotificationScreen({super.key,this.scaffoldKey,this.onNotificationsUpdated});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {

  GetModelCubit<NotificationsModel>? getCubit;
  bool _isConflictCardExpanded = false;

  Future viewNotification(bool isViewed,int notificationId) async {
    if(isViewed == false) {
      final result = await ViewNotificationUseCase(NotificationRepository()).call(
        params: ViewNotificationParams(notifications: [notificationId]),
      );
      if(result.hasDataOnly) {
        getCubit!.getModel();
        widget.onNotificationsUpdated?.call();
      }
    }
  }

  Map<String, String> flattenConflicts(dynamic data, [String prefix = '']) {
    Map<String, String> result = {};

    if (data == null) return result;

    if (data is String) {
      try {
        String cleanedData = data.trim();
        if (cleanedData.endsWith('...')) {
          cleanedData = cleanedData.substring(0, cleanedData.length - 3);
        }
        final decoded = jsonDecode(cleanedData);
        return flattenConflicts(decoded, prefix);
      } catch (e) {
        result[prefix.isEmpty ? 'Conflict' : prefix] = data;
        return result;
      }
    }

    if (data is Map) {
      data.forEach((key, value) {
        String newKey = prefix.isEmpty ? '$key' : '$prefix ➡️ $key';

        if (value is Map || value is List) {
          result.addAll(flattenConflicts(value, newKey));
        } else {
          result[newKey] = value.toString();
        }
      });
    }
    else if (data is List) {
      for (int i = 0; i < data.length; i++) {
        String newKey = prefix.isEmpty ? '[${i + 1}]' : '$prefix [${i + 1}]';

        if (data[i] is Map || data[i] is List) {
          result.addAll(flattenConflicts(data[i], newKey));
        } else {
          result[newKey] = data[i].toString();
        }
      }
    }
    return result;
  }


  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
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

                  final Map<String, String> conflictMap = flattenConflicts(newModel.notificationsList![index].payload!.conflicts);
                  final List<String> keys = conflictMap.keys.toList();

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
                            Navigation.push(CourtAppointmentDetailsScreen(appointmentId: notification.payload!.appointment!));
                            break;
                          case NotificationType.course:
                            Navigation.push(CourseDetailsScreen(courseId: newModel.notificationsList![index].payload!.course!));
                            break;
                          case NotificationType.event:
                            Navigation.push(EventDetailsScreen(eventId: newModel.notificationsList![index].payload!.event!));
                            break;
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
                                      iconSize: isTablet ? 20.sp : null,
                                      color: AppColors.whiteColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(8.r)),
                                      ),
                                      elevation: 10,
                                      shadowColor: AppColors.blackColor,
                                      itemBuilder: (BuildContext context) => [
                                        PopupMenuItem(
                                          value: "Delete",
                                          height: isTablet ? 80 : kMinInteractiveDimension,
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
                                      offset: Offset(AppStorage.languageCode == "ar" ? -15 : 15,isTablet ? 50 : 30),
                                      onSelected: (value) {},
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Text(newModel.notificationsList![index].body!, style: AppTheme.bodyLarge),
                              SizedBox(height: 5.h),
                              keys.isEmpty
                                  ? const SizedBox.shrink()
                                  : InkWell(
                                onTap: () {
                                  setState(() {
                                    _isConflictCardExpanded = !_isConflictCardExpanded;
                                  });
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: AnimatedSize(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInOut,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: _isConflictCardExpanded ? keys.length :
                                        (keys.length > 1 ? 1 : keys.length),
                                        itemBuilder: (context, conflictIndex) {
                                          final String currentKey = keys[conflictIndex];
                                          final String currentValue = conflictMap[currentKey]!;
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "$currentKey: ",
                                                  style: AppTheme.bodyMedium.copyWith(color: AppColors.redColor),
                                                ),
                                                Text(
                                                  currentValue,
                                                  style: AppTheme.bodySmall,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      if (keys.length > 1)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                _isConflictCardExpanded ? "" : AppLocalization.of(context).translate("see_more"),
                                                style: AppTheme.bodySmall.copyWith(
                                                    color: AppColors.primaryColor,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
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
