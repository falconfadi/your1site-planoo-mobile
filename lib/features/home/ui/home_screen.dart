import 'package:centro_partner/core/boilerplate/get_model/cubits/get_model_cubit.dart';
import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/shared_widgets/tabs_widget.dart';
import 'package:centro_partner/core/ui/widgets/cached_image.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/activity/all_activities_model.dart';
import 'package:centro_partner/features/home/data/model/course/all_courses_model.dart';
import 'package:centro_partner/features/home/data/model/event/all_events_model.dart';
import 'package:centro_partner/features/home/data/usecase/activity/all_activities_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/course/all_courses_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/event/all_events_usecase.dart';
import 'package:centro_partner/features/home/ui/activity/activity_details_screen.dart';
import 'package:centro_partner/features/home/ui/activity/add_activity_screen.dart';
import 'package:centro_partner/features/home/ui/course/add_course_screen.dart';
import 'package:centro_partner/features/home/ui/course/course_details_screen.dart';
import 'package:centro_partner/features/home/ui/event/add_event_screen.dart';
import 'package:centro_partner/features/home/ui/event/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int selectedTab = 0;
  GetModelCubit<AllActivitiesModel>? allActivitiesCubit;
  GetModelCubit<AllCoursesModel>? allCoursesCubit;
  GetModelCubit<AllEventsModel>? allEventsCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: CustomHeader(title: "",withLogo: true,isNavBar: true),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              InkWell(
                onTap: () {
                  if (selectedTab == 0) {
                    Navigation.push(AddActivityScreen(
                      onRefresh: () async {
                        await allActivitiesCubit?.getModel();
                      },
                    ));
                  } else if (selectedTab == 1) {
                    Navigation.push(AddCourseScreen(
                      onRefresh: () async {
                        await allCoursesCubit?.getModel();
                      },
                    ));
                  } else if (selectedTab == 2) {
                    Navigation.push(AddEventScreen(
                      onRefresh: () async {
                        await allEventsCubit?.getModel();
                      },
                    ));
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.add_circle_outline_outlined,color: AppColors.turquoiseColor),
                    SizedBox(width: 5.w),
                    Padding(
                      padding: EdgeInsets.only(top: 3.h),
                      child: Text(AppLocalization.of(context).translate("add"),
                        style: AppTheme.bodyLarge.copyWith(fontSize: 20.sp,color: AppColors.turquoiseColor),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              TabsWidget(
                selectedTab: selectedTab,
                onTabChanged: (index) {
                  setState(() {
                    selectedTab = index;
                  });
                },
              ),
              Expanded(
                child: selectedTab == 0 ?
                GetModel<AllActivitiesModel>(
                  onCubitCreated: (cubit) {
                    allActivitiesCubit = cubit as GetModelCubit<AllActivitiesModel>;
                  },
                  useCaseCallBack: () {
                    return AllActivitiesUseCase(HomeRepository()).call(params: AllActivitiesParams());
                  },
                  modelBuilder: (model) => ResponsiveGridList(
                    horizontalGridMargin: 10,
                    verticalGridMargin: 20,
                    minItemWidth: 100,
                    children: model.activitiesList!.map((e) => InkWell(
                      onTap: () {
                        Navigation.push(ActivityDetailsScreen(
                          activityId: e.iD!,
                          onRefresh: () async {
                            await allActivitiesCubit?.getModel();
                          },
                        ));
                      },
                      child: ColoredBox(
                          color: AppColors.lightGrayColor,
                          child: CachedImage(
                            imageUrl: e.mediaList!.isEmpty ? "" : e.mediaList!.first.url!,
                            height: 270.h,
                            fit: BoxFit.cover,
                          )
                      ),
                    )).toList(),
                  ),
                ) :
                selectedTab == 1 ?
                GetModel<AllCoursesModel>(
                  onCubitCreated: (cubit) {
                    allCoursesCubit = cubit as GetModelCubit<AllCoursesModel>;
                  },
                  useCaseCallBack: () {
                    return AllCoursesUseCase(HomeRepository()).call(params: AllCoursesParams());
                  },
                  modelBuilder: (model) => ResponsiveGridList(
                    horizontalGridMargin: 10,
                    verticalGridMargin: 20,
                    minItemWidth: 100,
                    children: model.coursesList!.map((e) => InkWell(
                      onTap: () {
                        Navigation.push(CourseDetailsScreen(
                          courseId: e.iD!,
                          onRefresh: () async {
                            await allCoursesCubit?.getModel();
                          },
                        ));
                      },
                      child: ColoredBox(
                          color: AppColors.lightGrayColor,
                          child: CachedImage(
                            imageUrl: e.mediaList!.isEmpty ? "" : e.mediaList!.first.url!,
                            height: 270.h,
                            fit: BoxFit.cover,
                          )
                      ),
                    )).toList(),
                  ),
                ) :
                GetModel<AllEventsModel>(
                      onCubitCreated: (cubit) {
                        allEventsCubit = cubit as GetModelCubit<AllEventsModel>;
                      },
                      useCaseCallBack: () {
                        return AllEventsUseCase(HomeRepository()).call(params: AllEventsParams());
                      },
                      modelBuilder: (model) => ResponsiveGridList(
                        horizontalGridMargin: 10,
                        verticalGridMargin: 20,
                        minItemWidth: 100,
                        children: model.eventsList!.map((e) => InkWell(
                          onTap: () {
                            Navigation.push(EventDetailsScreen(
                              eventId: e.iD!,
                              onRefresh: () async {
                                await allEventsCubit?.getModel();
                              },
                            ));
                          },
                          child: ColoredBox(
                              color: AppColors.lightGrayColor,
                              child: CachedImage(
                                imageUrl: e.mediaList!.isEmpty ? "" : e.mediaList!.first.url!,
                                height: 270.h,
                                fit: BoxFit.cover,
                              )
                          ),
                        )).toList(),
                      ),
                    ),
              ),
            ],
          ),
        )
    );
  }
}