import 'package:centro_partner/core/boilerplate/pagination/cubits/pagination_cubit.dart';
import 'package:centro_partner/core/boilerplate/pagination/widgets/pagination_list.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/constants/enum/status_enum.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/shared_widgets/tabs_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_sheet.dart';
import 'package:centro_partner/features/appointment/data/appointment_repository/appointment_repository.dart';
import 'package:centro_partner/features/appointment/data/model/appointment_details_model.dart';
import 'package:centro_partner/features/appointment/data/usecase/all_appointments_usecase.dart';
import 'package:centro_partner/features/appointment/widget/appointment_widget.dart';
import 'package:centro_partner/features/appointment/widget/filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppointmentsScreen extends StatefulWidget {

  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {

  int selectedTab = 0;
  late PaginationCubit cubit;
  StatusEnum selectedStatus = StatusEnum.accepted;
  String? date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: CustomHeader(title: AppLocalization.of(context).translate("appointments"), isNavBar: true),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              Row(
                children: [
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
                    child: SvgPicture.asset(filter,color: AppColors.turquoiseColor)
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: TabsWidget(
                      selectedTab: selectedTab,
                      onTabChanged: (index) {
                        setState(() {
                          selectedTab = index;
                        });
                        selectedStatus = StatusEnum.accepted;
                        date = null;
                        cubit.getList();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
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
                          ownerType: selectedTab == 0 ?
                          "activity" : selectedTab == 1 ? "course" : "event",
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
                        return AppointmentWidget(
                          appointment: list[index],
                          onRefresh: () async {
                            await cubit.getList();
                          },
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        )
    );
  }
}
