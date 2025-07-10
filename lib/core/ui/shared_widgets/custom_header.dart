import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/widgets/cached_image.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/profile/ui/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {

  final String? title;
  final bool isNavBar;
  List<Widget>? actions;
  Widget? leading;

  CustomHeader({this.title, required this.isNavBar,this.leading,this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title!, style: AppTheme.titleSmall),
      centerTitle: true,
      elevation: 1,
      toolbarHeight: 200.h,
      surfaceTintColor: Colors.transparent,
      shadowColor: AppColors.blackColor.withOpacity(0.5),
      backgroundColor: AppColors.whiteColor,
      leadingWidth: isNavBar ? 1.sw : null,
      leading: isNavBar ?
      SizedBox(
        width: 1.sw,
        child: Row(
          children: [
            SizedBox(width: 10.w),
            Image.asset(logo,width: 100),
          ],
        ),
      ) : leading ?? IconButton(
        icon: Icon(Icons.arrow_back),
        color: AppColors.blackColor,
        onPressed: () {
          Navigation.pop();
        },
      ),
      actions: isNavBar ? [
        IconButton(
          onPressed: () {
            Navigation.push(ProfileScreen());
          },
          icon: CachedImage(
            imageUrl: "", // todo change image according to account type
            width: 37.w,
            height: 37.w,
            fit: BoxFit.cover,
            borderRadius: 10.r,
          ),
          color: AppColors.blackColor,
        ),
      ] : actions ?? [],
    );
  }

  @override
  Size get preferredSize => Size(1.sw, 50);
}
