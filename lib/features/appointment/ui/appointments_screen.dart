import 'package:centro_partner/core/boilerplate/get_model/cubits/get_model_cubit.dart';
import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/boilerplate/pagination/cubits/pagination_cubit.dart';
import 'package:centro_partner/core/boilerplate/pagination/widgets/pagination_list.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/constants/end_point.dart';
import 'package:centro_partner/core/constants/enum/status_enum.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/shared_widgets/icon_text_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/tabs_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_sheet.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/project_utils/status_type.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:centro_partner/features/appointment/data/appointment_repository/appointment_repository.dart';
import 'package:centro_partner/features/appointment/data/model/appointment_details_model.dart';
import 'package:centro_partner/features/appointment/data/usecase/all_appointments_usecase.dart';
import 'package:centro_partner/features/appointment/ui/course_appointment_details_screen.dart';
import 'package:centro_partner/features/appointment/ui/court_appointment_details_screen.dart';
import 'package:centro_partner/features/appointment/ui/event_appointment_details_screen.dart';
import 'package:centro_partner/features/appointment/widget/appointment_card.dart';
import 'package:centro_partner/features/appointment/widget/filter_sheet.dart';
import 'package:centro_partner/features/appointment/widget/status_widget.dart';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/course/all_courses_model.dart';
import 'package:centro_partner/features/home/data/model/event/all_events_model.dart';
import 'package:centro_partner/features/home/data/usecase/course/all_courses_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/event/all_events_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:centro_partner/core/constants/app_images.dart' as image;
import 'package:intl/intl.dart';

class AppointmentsScreen extends StatefulWidget {

  final GlobalKey<ScaffoldState>? scaffoldKey;

  const AppointmentsScreen({super.key,this.scaffoldKey});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {

  int selectedTab = 0;
  late PaginationCubit cubit;
  StatusEnum selectedStatus = StatusEnum.accepted;
  String? date;
  GetModelCubit<AllCoursesModel>? allCoursesCubit;
  GetModelCubit<AllEventsModel>? allEventsCubit;

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: CustomHeader(scaffoldKey: widget.scaffoldKey,title: AppLocalization.of(context).translate("appointments"), isNavBar: true),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              Row(
                children: [
                  selectedTab == 0 ?
                  InkWell(
                    onTap: () async {
                      final result = await CustomSheet.show(
                          isDismissible: true,
                          header: Text(AppLocalization.of(context).translate("filter"),
                            style: AppTheme.titleLarge.copyWith(fontSize: 18.sp),
                          ),
                          padding: 30.w,
                          context: context,
                          child: FilterSheet()
                      );
                      if (result != null) {
                        if(result.first == null) {
                          selectedStatus = StatusEnum.accepted;
                        } else {
                          selectedStatus = result.first;
                        }
                        if(result.last == null) {
                          date = null;
                        } else {
                          date = result.last.toString();
                        }
                        setState(() {});
                      }
                    },
                    child: SvgPicture.asset(filter,color: AppColors.turquoiseColor,
                      width: isTablet ? 20.w : null,
                    )
                  ) : Center(),
                  SizedBox(width: selectedTab == 0 ? 15.w : 0),
                  Expanded(
                    child: TabsWidget(
                      selectedTab: selectedTab,
                      onTabChanged: (index) {
                        setState(() {
                          selectedTab = index;
                        });
                        selectedStatus = StatusEnum.accepted;
                        date = null;
                        if(selectedTab == 0) {
                          cubit.getList();
                        } else if(selectedTab == 1) {
                          allCoursesCubit!.getModel();
                        } else {
                          allEventsCubit!.getModel();
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              selectedTab == 0 ?
              Expanded(
                child: PaginationList<AppointmentDetailsModel>(
                  key: ValueKey("$selectedStatus-$date"),
                  scrollDirection: Axis.vertical,
                  withPagination: true,
                  onCubitCreated: (cub) {
                    cubit = cub;
                  },
                  repositoryCallBack: (model) {
                    return AllAppointmentsUseCase(AppointmentRepository()).call(
                        params: AllAppointmentsParams(model,
                          ownerType: "activity",
                          date: date,
                          status: selectedStatus.name == "accepted" ? 0 :
                          selectedStatus.name == "completed" ? 1 : -1
                        ));
                  },
                  listBuilder: (list) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (context,index) {
                        return AppointmentCard(
                            onTap: () {
                              Navigation.push(CourtAppointmentDetailsScreen(appointmentId: list[index].iD!,
                                  onRefresh: () async{
                                    await cubit.getList();
                                  }));
                            },
                            imageHeight: 1.sh * 0.22,
                            title: list[index].holder!.name!,
                            imageUrl: list[index].holder!.holderImage == null ? "" :
                            serverUrl + list[index].holder!.holderImage!.url!,
                            header: StatusWidget(
                              statusText: list[index].status!,
                              statusColor: StatusType().getStatusInfo(list[index].status!)["color"],
                              width: 0.25.sw,
                              height: isTablet ? 35.h : 32.h,
                            ),
                            date: list[index].date!,
                            details: [
                              IconTextWidget(
                                icon: image.time,
                                iconSize: 20.w,
                                text: DateFormat("HH:mm").format(DateFormat("HH:mm:ss").parse(list[index].time!)),
                                textStyle: AppTheme.labelLarge.copyWith(color: AppColors.mediumGrayColor),
                              ),
                              IconTextWidget(
                                icon: image.user,
                                iconSize: 18.w,
                                text: list[index].customer!.name!,
                                textStyle: AppTheme.labelLarge.copyWith(
                                    color: AppColors.mediumGrayColor),
                              ),
                            ]
                        );
                      },
                    );
                  },
                ),
              ) : selectedTab == 1 ?
              GetModel<AllCoursesModel>(
                  onCubitCreated: (cubit) {
                    allCoursesCubit = cubit as GetModelCubit<AllCoursesModel>;
                  },
                  loadingHeight: 1.sh * 0.65,
                  useCaseCallBack: () {
                    return AllCoursesUseCase(HomeRepository()).call(params: AllCoursesParams());
                  },
                  modelBuilder: (model) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: model.coursesList!.length,
                    itemBuilder: (context,index) {
                      final course = model.coursesList![index];
                      return AppointmentCard(
                          onTap: () {
                            Navigation.push(CourseAppointmentDetailsScreen(course: course));
                          },
                          isAppointment: false,
                          imageHeight: 1.sh * 0.16,
                          title: course.name!,
                          imageUrl: course.mediaList!.isEmpty ? "" :
                          course.mediaList!.first.url!,
                          date: course.startDate!,
                          details: [
                            IconTextWidget(
                              icon: image.capacity,
                              iconSize: 23.sp,
                              text: course.capacity.toString(),
                              textStyle: AppTheme.labelLarge.copyWith(color: AppColors.mediumGrayColor),
                            ),
                            IconTextWidget(
                              icon: image.user,
                              iconSize: 18.sp,
                              text: course.customersList!.length.toString(),
                              textStyle: AppTheme.labelLarge.copyWith(color: AppColors.mediumGrayColor),
                            ),
                          ]
                      );
                    },
                  )
              ) :
              GetModel<AllEventsModel>(
                  onCubitCreated: (cubit) {
                    allEventsCubit = cubit as GetModelCubit<AllEventsModel>;
                  },
                  loadingHeight: 1.sh * 0.65,
                  useCaseCallBack: () {
                    return AllEventsUseCase(HomeRepository()).call(params: AllEventsParams());
                  },
                  modelBuilder: (model) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: model.eventsList!.length,
                    itemBuilder: (context,index) {
                      final event = model.eventsList![index];
                      return AppointmentCard(
                          onTap: () {
                            Navigation.push(EventAppointmentDetailsScreen(event: event));
                          },
                          isAppointment: false,
                          imageHeight: 1.sh * 0.16,
                          title: event.name!,
                          imageUrl: event.mediaList!.isEmpty ? "" :
                          event.mediaList!.first.url!,
                          date: event.startDate!,
                          details: [
                            IconTextWidget(
                              icon: image.capacity,
                              iconSize: 23.sp,
                              text: event.capacity.toString(),
                              textStyle: AppTheme.labelLarge.copyWith(color: AppColors.mediumGrayColor),
                            ),
                            IconTextWidget(
                              icon: image.user,
                              iconSize: 18.sp,
                              text: event.customersList!.length.toString(),
                              textStyle: AppTheme.labelLarge.copyWith(color: AppColors.mediumGrayColor),
                            ),
                          ]
                      );
                    },
                  )
              ),
            ],
          ),
        )
    );
  }
}
