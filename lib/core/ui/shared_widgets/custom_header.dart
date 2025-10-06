import 'package:centro_partner/core/classes/Keys.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {

  final String? title;
  final bool isNavBar;
  final bool? withLogo;
  final Widget? leading;

  const CustomHeader({super.key, this.title, required this.isNavBar,this.withLogo = false,this.leading});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title!, style: AppTheme.bodyLarge.copyWith(fontSize: 22.sp)),
      centerTitle: true,
      elevation: 1,
      toolbarHeight: 200.h,
      surfaceTintColor: Colors.transparent,
      shadowColor: AppColors.blackColor.withOpacity(0.5),
      backgroundColor: AppColors.whiteColor,
      leadingWidth: withLogo == true ? 1.sw : null,
      leading: isNavBar ? Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: InkWell(
              onTap: () => Keys.scaffoldKey.currentState!.openDrawer(),
              child: SvgPicture.asset(menu),
            )
          ),
          withLogo == true ? Image.asset(logo,width: 150.w) : Center(),
        ],
      ) : leading ?? IconButton(
        icon: Icon(Icons.arrow_back),
        color: AppColors.blackColor,
        onPressed: () {
          Navigation.pop();
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size(1.sw, 50);
}
