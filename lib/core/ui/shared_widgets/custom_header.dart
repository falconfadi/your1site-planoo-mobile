import 'package:centro_partner/core/classes/Keys.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {

  final String? title;
  final bool isNavBar;
  final bool? withLogo;
  final Widget? leading;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const CustomHeader({super.key, this.title, required this.isNavBar,this.withLogo = false,this.leading,this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    return AppBar(
      title: Padding(
        padding: EdgeInsets.only(top: 8),
        child: Text(title!, style: AppTheme.bodyLarge.copyWith(fontSize: 22.sp)),
      ),
      centerTitle: true,
      elevation: 1,
      toolbarHeight: 200.h,
      surfaceTintColor: Colors.transparent,
      shadowColor: AppColors.blackColor.withOpacity(0.5),
      backgroundColor: AppColors.whiteColor,
      leadingWidth: withLogo == true ? 1.sw : isTablet ? 40.w : null, // todo stop here
      leading: isNavBar ? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.menu,size: isTablet ? 30.sp : 35.sp),
            onPressed: () => scaffoldKey?.currentState?.openDrawer(),
          ),
          if (withLogo == true)
            SizedBox(
              width: isTablet ? 100.w : 150.w,
              child: Image.asset(logo, fit: BoxFit.contain),
            ),
        ],
      ) : leading ?? IconButton(
          icon: Icon(Icons.arrow_back,size: isTablet ? 20.sp : null),
          color: AppColors.blackColor,
          onPressed: () {
            Navigation.pop();
          },
        ),
    );
  }

  @override
  Size get preferredSize => Size(
    1.sw,
    Responsive.isTablet(
      Keys.navigatorKey.currentContext!) ? 100 : 50,
  );
}
