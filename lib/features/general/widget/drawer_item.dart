import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback? onTap;

  const DrawerItem({
    super.key,
    required this.title,
    required this.iconPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    return ListTile(
      onTap: onTap,
      leading: SvgPicture.asset(iconPath,width: isTablet ? 20.w : null),
      title: Padding(
        padding: EdgeInsets.only(top: 5.h),
        child: Text(
          title,
          style: AppTheme.bodyLarge.copyWith(fontSize: 18.sp),
        ),
      ),
    );
  }
}
