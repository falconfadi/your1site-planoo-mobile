import 'package:centro_partner/core/ui/shared_widgets/custom_container_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/ui/widgets/coustom_sheet.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';

class SelectMultiItemsWidget<T, ID> extends StatefulWidget {
  final String title;
  final List<T> list;
  final Set<ID> selectedIds;
  final String Function(T) labelBuilder;
  final ID Function(T) idBuilder;
  final void Function(Set<ID>) onSelect;

  const SelectMultiItemsWidget({
    super.key,
    required this.title,
    required this.list,
    required this.selectedIds,
    required this.labelBuilder,
    required this.idBuilder,
    required this.onSelect,
  });

  @override
  State<SelectMultiItemsWidget<T, ID>> createState() => _SelectMultiItemsWidgetState<T, ID>();
}

class _SelectMultiItemsWidgetState<T, ID> extends State<SelectMultiItemsWidget<T, ID>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            CustomSheet.show(
              isDismissible: true,
              header: Text(widget.title, style: AppTheme.titleLarge.copyWith(fontSize: 18.sp)),
              padding: 30.w,
              context: context,
              child: Column(
                children: [
                  StatefulBuilder(
                    builder: (context, setSheetState) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.list.length,
                        itemBuilder: (context, index) {
                          final item = widget.list[index];
                          final id = widget.idBuilder(item);
                          final isSelected = widget.selectedIds.contains(id);
                          return InkWell(
                            onTap: () {
                              setSheetState(() {
                                if (isSelected) {
                                  widget.selectedIds.remove(id);
                                } else {
                                  widget.selectedIds.add(id);
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 20.w,right: 20.w, top: 15.h,bottom: 8.h),
                              margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: isSelected
                                    ? AppColors.primaryColor.withOpacity(0.3)
                                    : AppColors.extraLightGrayColor,
                              ),
                              child: Center(
                                child: Text(widget.labelBuilder(item),style: AppTheme.labelLarge.copyWith(fontSize: 18.sp)),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  CustomButton(
                    width: 1.sw,
                    backgroundColor: AppColors.primaryColor,
                    borderRadius: 10.r,
                    buttonName: AppLocalization.of(context).translate("save"),
                    function: () {
                      widget.onSelect(widget.selectedIds);
                      Navigation.pop();
                    },
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            );
          },
          child: CustomContainerInfoWidget(title: widget.title),
        ),
        SizedBox(height: widget.selectedIds.isNotEmpty ? 20.h : 0),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: widget.selectedIds.map((id) {
            final item =
            widget.list.firstWhere((e) => widget.idBuilder(e) == id);
            return UnconstrainedBox(
              child: Container(
                padding: EdgeInsets.only(left: 10.w,right: 10.w,top: 10.h,bottom: 5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppColors.primaryColor.withOpacity(0.1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.labelBuilder(item), style: AppTheme.labelLarge.copyWith(fontSize: 18.sp)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
