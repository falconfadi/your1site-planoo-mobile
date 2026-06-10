import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPopupMenuButtonWidget extends StatelessWidget {

  final List<PopupMenuEntry<String>> itemBuilder;

  const CustomPopupMenuButtonWidget({super.key,
    required this.itemBuilder
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8.r)
      ),
      child: PopupMenuButton(
        icon: Icon(Icons.more_vert,size: isTablet ? 15.sp : 18),
        offset: Offset(0,isTablet ? 85 : 40),
        onSelected: (value) {},
        color: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
        ),
        elevation: 5,
        shadowColor: AppColors.lightGrayColor,
        itemBuilder: (BuildContext context) => itemBuilder
      ),
    );
  }
}