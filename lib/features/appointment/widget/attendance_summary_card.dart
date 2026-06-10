import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/classes/app_storage.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_row_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/icon_text_widget.dart';
import 'package:centro_partner/core/ui/widgets/cached_image.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:centro_partner/core/utils/validators/convert_date_time.dart';
import 'package:centro_partner/features/appointment/widget/status_widget.dart';
import 'package:centro_partner/features/home/data/model/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/core/constants/app_images.dart' as image;

class AttendanceSummaryCard extends StatefulWidget {

  final String date;
  final int capacity;
  final int remainingSlots;
  final String status;
  final List<CustomerModel> participantsList;
  final bool isEvent;

  const AttendanceSummaryCard({
    super.key,
    required this.date,
    required this.capacity,
    required this.remainingSlots,
    required this.status,
    required this.participantsList,
    this.isEvent = false
  });

  @override
  State<AttendanceSummaryCard> createState() => _AttendanceSummaryCardState();
}

class _AttendanceSummaryCardState extends State<AttendanceSummaryCard> {

  ScrollController scrollController = ScrollController();
  Set<int> expandedItems = {};

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
    return Card(
      color: AppColors.whiteColor,
      elevation: 3,
      shadowColor: AppColors.gray2Color,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: IconTextWidget(
                    icon: image.appointment,
                    iconSize: 20.w,
                    text: convertDate(date: widget.date, format: 'dd/MM/yyyy'),
                    textStyle: AppTheme.labelLarge.copyWith(fontSize: 18.sp, color: AppColors.mediumGrayColor),
                  ),
                ),
                StatusWidget(
                  statusText: widget.status,
                  statusColor: widget.status == "pending" ?
                  AppColors.mediumGrayColor : widget.status == "canceled" ?
                  AppColors.redColor : widget.status == "completed" ?
                  AppColors.turquoiseColor : AppColors.darkGreenColor,
                  width: 0.25.sw,
                  height: isTablet ? 35.h : 32.h,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: IconTextWidget(
                    icon: image.capacity,
                    iconSize: 25.sp,
                    text: widget.capacity.toString(),
                    textStyle: AppTheme.labelLarge.copyWith(color: AppColors.mediumGrayColor),
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: RichText(
                    text: TextSpan(
                      text: "/  ",
                      style: AppTheme.bodyLarge.copyWith(fontSize: 18.sp, color: AppColors.primaryColor),
                      children: [
                        TextSpan(
                          text: AppLocalization.of(context).translate("remaining"),
                          style: AppTheme.bodyLarge.copyWith(fontSize: 18.sp, color: AppColors.primaryColor),
                        ),
                        const TextSpan(text: ": "),
                        TextSpan(
                          text: widget.remainingSlots.toString(),
                          style: AppTheme.labelLarge.copyWith(color: AppColors.mediumGrayColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            const Divider(),
            SizedBox(height: 10.h),
            Text(
              AppLocalization.of(context).translate("participants"),
              style: AppTheme.headlineMedium,
            ),
            SizedBox(height: 10.h),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: widget.participantsList.length,
              itemBuilder: (context, index) {
                final participant = widget.participantsList[index];
                final isExpanded = expandedItems.contains(index);
                return Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: Card(
                    color: AppColors.extraLightGrayColor,
                    child: Padding(
                      padding: EdgeInsets.all(10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (isExpanded) {
                                  expandedItems.remove(index);
                                } else {
                                  expandedItems.add(index);
                                }
                              });
                              if (!isExpanded) {
                                Future.delayed(
                                  const Duration(milliseconds: 350),
                                  _scrollToBottom,
                                );
                              }
                            },
                            child: Row(
                              children: [
                                CachedImage(
                                  width: 40.w,
                                  height: 40.w,
                                  imageUrl: participant.profileImage?.url ?? "",
                                  fit: BoxFit.cover,
                                  borderColor: AppColors.grayColor,
                                  borderRadius: 10.r,
                                  borderWidth: 1,
                                  errorForUser: true,
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    participant.name ?? "",
                                    style: AppTheme.headlineSmall.copyWith(
                                      color: AppColors.mediumGrayColor,
                                    ),
                                  ),
                                ),
                                Icon(
                                  isExpanded
                                      ? Icons.arrow_circle_down_outlined
                                      : AppStorage.languageCode == "ar" ?
                                      Icons.arrow_circle_left_outlined :
                                  Icons.arrow_circle_right_outlined,
                                  color: AppColors.turquoiseColor,
                                  size: isTablet ? 22.sp : null,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: isExpanded ? 10.h : 0),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: isExpanded ? Column(
                              children: [
                                CustomRowWidget(
                                  title: AppLocalization.of(context).translate("attendance_date"),
                                  subTitle: convertDate(date: participant.attendedAt!),
                                  titleTextStyle: AppTheme.bodyLarge,
                                  subTitleTextStyle: AppTheme.bodyLarge.copyWith(
                                    color: AppColors.mediumGrayColor,
                                  ),
                                ),
                                if (!widget.isEvent && participant.remainingSessions! > 0)
                                  CustomRowWidget(
                                    title: AppLocalization.of(context).translate("remaining_sessions"),
                                    subTitle: participant.remainingSessions.toString(),
                                    titleTextStyle: AppTheme.bodyLarge,
                                    subTitleTextStyle: AppTheme.bodyLarge.copyWith(
                                      color: AppColors.mediumGrayColor,
                                    ),
                                  ),
                                if (!widget.isEvent && participant.remainingSessions == 0)
                                  Row(
                                    children: [
                                      Text(AppLocalization.of(context).translate("completed"),
                                          style: AppTheme.headlineSmall.copyWith(color: AppColors.darkGreenColor)),
                                    ],
                                  ),
                              ],
                            ) : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}