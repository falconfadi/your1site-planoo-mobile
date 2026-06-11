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

class SelectMultiItemsWidget<T, ID> extends StatefulWidget {
  final String title;
  final List<T> list;
  final Set<ID> selectedIds;
  final String Function(T) labelBuilder;
  final String Function(T)? imageBuilder;
  final ID Function(T) idBuilder;
  final void Function(Set<ID>) onSelect;
  final bool? isDelete;
  final void Function(ID)? onDelete;

  const SelectMultiItemsWidget({
    super.key,
    required this.title,
    required this.list,
    required this.selectedIds,
    required this.labelBuilder,
    this.imageBuilder,
    required this.idBuilder,
    required this.onSelect,
    this.isDelete,
    this.onDelete
  });

  @override
  State<SelectMultiItemsWidget<T, ID>> createState() => _SelectMultiItemsWidgetState<T, ID>();
}

class _SelectMultiItemsWidgetState<T, ID> extends State<SelectMultiItemsWidget<T, ID>> {

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    return Column(
      children: [
        InkWell(
          onTap: () {
            final tempSelectedIds = Set<ID>.from(widget.selectedIds);
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
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = widget.list[index];
                          final id = widget.idBuilder(item);
                          final isSelected = tempSelectedIds.contains(id);
                          return InkWell(
                            onTap: () {
                              setSheetState(() {
                                if (isSelected) {
                                  tempSelectedIds.remove(id);
                                } else {
                                  tempSelectedIds.add(id);
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
                              margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: isSelected
                                    ? AppColors.primaryColor.withOpacity(0.3)
                                    : AppColors.extraLightGrayColor,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (widget.imageBuilder != null) ...[
                                    CachedImage(
                                      width: 45.w,
                                      height: 45.w,
                                      imageUrl: widget.imageBuilder!(item),
                                      fit: BoxFit.cover,
                                      borderRadius: 10.r,
                                      borderColor: AppColors.primaryColor,
                                      borderWidth: 0.5,
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
                      );
                    },
                  ),
                  CustomButton(
                    width: 1.sw,
                    backgroundColor: AppColors.primaryColor,
                    borderRadius: 10.r,
                    buttonName: AppLocalization.of(context).translate("save"),
                    function: () {
                      widget.onSelect(Set<ID>.from(tempSelectedIds));
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
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15.w,right: 15.w,top: widget.isDelete == true ? 20.h : 10.h,bottom: 10.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: AppColors.primaryColor.withOpacity(0.1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.imageBuilder != null) ...[
                          CachedImage(
                            width: 45.w,
                            height: 45.w,
                            imageUrl: widget.imageBuilder!(item),
                            fit: BoxFit.cover,
                            borderRadius: 10.r,
                            borderColor: AppColors.primaryColor,
                            borderWidth: 0.5,
                          ),
                          SizedBox(width: 10.w),
                        ],
                        Text(widget.labelBuilder(item), style: AppTheme.labelLarge.copyWith(fontSize: 18.sp)),
                      ],
                    ),
                  ),
                  if(widget.isDelete == true)
                    Positioned(
                      right: 0,
                      child: InkWell(
                          onTap: () {
                            if(widget.isDelete == true) {
                              widget.onDelete!(id);
                            }
                          },
                          child: Icon(Icons.close,size: isTablet ? 20.sp : null))
                    )
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
