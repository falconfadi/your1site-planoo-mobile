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
import 'package:centro_partner/features/home/data/usecase/activity/all_activities_usecase.dart';
import 'package:centro_partner/features/home/ui/activity_details_screen.dart';
import 'package:centro_partner/features/home/ui/add_activity_screen.dart';
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
                    // print('classes');
                  } else if (selectedTab == 2) {
                    // print("events");
                  } else {
                    // print("entertainment");
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
                child: GetModel<AllActivitiesModel>(
                  onCubitCreated: (cubit) {
                    allActivitiesCubit = cubit as GetModelCubit<AllActivitiesModel>;
                  },
                  useCaseCallBack: () {
                    return AllActivitiesUseCase(HomeRepository()).call(params: AllActivitiesParams());
                  },
                  withAnimation: false,
                  modelBuilder: (model) => ResponsiveGridList(
                    horizontalGridMargin: 10,
                    verticalGridMargin: 20,
                    minItemWidth: 100,
                    children: model.activitiesList!.map((e) => InkWell(
                      onTap: () {
                        if (selectedTab == 0) {
                          Navigation.push(ActivityDetailsScreen(
                            activityId: e.iD!,
                            onRefresh: () async {
                              await allActivitiesCubit?.getModel();
                            },
                          ));
                        }
                      },
                      child: ColoredBox(
                          color: AppColors.lightGrayColor,
                          child: CachedImage(
                            imageUrl: selectedTab == 0 ? e.mediaList!.isEmpty ? "" : e.mediaList!.first.url! :
                            selectedTab == 1 ? "https://media.istockphoto.com/id/1317564926/photo/athletic-woman-using-barbell-disk-while-being-in-lunge-position-during-exercise-class-at-the.jpg?s=612x612&w=0&k=20&c=OSmJFbIEfqn5ksbs9b7uWtkJWO598KDf6mG0QjB8rmg=" :
                            selectedTab == 2 ? "https://theenterpriseworld.com/wp-content/uploads/2024/03/49.-Top-10-Biggest-Sporting-Events-In-The-World-Image-by-Dmytro-Aksonov-.jpg" :
                            "https://smithhousestrategy.com/wp-content/uploads/2024/02/sports.jpg",
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
