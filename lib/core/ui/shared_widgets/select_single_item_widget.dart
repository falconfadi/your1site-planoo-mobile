import 'package:centro_partner/core/ui/shared_widgets/custom_container_info_widget.dart';
import 'package:centro_partner/core/ui/widgets/cached_image.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/ui/widgets/custom_sheet.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';

class SelectSingleItemWidget<T, ID> extends StatefulWidget {
  final String title;
  final List<T> list;
  final ID? selectedId;
  final String Function(T) labelBuilder;
  final String? Function(T)? imageBuilder;
  final ID Function(T) idBuilder;
  final void Function(ID?) onSelect;
  final String subTitle;
  final Color? subTitleColor;

  const SelectSingleItemWidget({
    super.key,
    required this.title,
    required this.list,
    required this.selectedId,
    required this.labelBuilder,
    this.imageBuilder,
    required this.idBuilder,
    required this.onSelect,
    required this.subTitle,
    this.subTitleColor,
  });

  @override
  State<SelectSingleItemWidget<T, ID>> createState() => _SelectSingleItemWidgetState<T, ID>();
}

class _SelectSingleItemWidgetState<T, ID> extends State<SelectSingleItemWidget<T, ID>> {

  ID? tempSelectedId;

  @override
  void initState() {
    super.initState();
    tempSelectedId = widget.selectedId;
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    return Column(
      children: [
        InkWell(
          onTap: () {
            CustomSheet.show(
              isDismissible: true,
              height: 0.7.sh,
              header: Text(
                widget.title,
                style: AppTheme.titleLarge.copyWith(fontSize: 18.sp),
              ),
              padding: 30.w,
              context: context,
              child: StatefulBuilder(
                builder: (context, setSheetState) {
                  return Container(
                    constraints: BoxConstraints(
                      maxHeight: 0.7.sh - 120.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: widget.list.length,
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: false,
                            padding: EdgeInsets.only(bottom: 16.h),
                            itemBuilder: (context, index) {
                              final item = widget.list[index];
                              final id = widget.idBuilder(item);
                              final isSelected = tempSelectedId == id;
                              return InkWell(
                                onTap: () {
                                  setSheetState(() {
                                    tempSelectedId = id;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                                  margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: isSelected
                                        ? AppColors.primaryColor.withOpacity(0.3)
                                        : AppColors.extraLightGrayColor,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      if (widget.imageBuilder != null &&
                                          widget.imageBuilder!(item) != null &&
                                          widget.imageBuilder!(item)!.isNotEmpty) ...[
                                        CachedImage(
                                          width: isTablet ? 80 : 45.w,
                                          height: isTablet ? 80 : 45.w,
                                          imageUrl: widget.imageBuilder!(item)!,
                                          fit: BoxFit.cover,
                                          borderRadius: 10.r,
                                          borderColor: AppColors.primaryColor,
                                          borderWidth: 1.0,
                                        ),
                                        SizedBox(width: 10.w),
                                      ],
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.h),
                                        child: Text(
                                          widget.labelBuilder(item),
                                          style: AppTheme.labelLarge.copyWith(fontSize: 18.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                          child: CustomButton(
                            width: 1.sw,
                            backgroundColor: AppColors.primaryColor,
                            borderRadius: 10.r,
                            buttonName: AppLocalization.of(context).translate("save"),
                            function: () {
                              widget.onSelect(tempSelectedId);
                              Navigation.pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
          child: CustomContainerInfoWidget(
            title: widget.subTitle,
            textStyle: AppTheme.labelLarge.copyWith(
              fontSize: 18.sp,
              color: widget.subTitleColor,
            ),
          ),
        ),
      ],
    );
  }
}
