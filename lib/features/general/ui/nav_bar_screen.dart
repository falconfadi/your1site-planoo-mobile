import 'package:centro_partner/core/classes/Keys.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/features/appointment/ui/appointments_screen.dart';
import 'package:centro_partner/features/home/ui/home_screen.dart';
import 'package:centro_partner/features/general/widget/drawer_widget.dart';
import 'package:centro_partner/features/notification/ui/notification_screen.dart';
import 'package:centro_partner/features/profile/ui/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class NavBarScreen extends StatefulWidget {

  final int pageIndex;

  const NavBarScreen({super.key, required this.pageIndex});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {

  late PersistentTabController _controller;
  final NavBarStyle _navBarStyle = NavBarStyle.style12;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: widget.pageIndex);
  }

  List<Widget> _buildScreens() => [
    HomeScreen(),
    AppointmentsScreen(),
    NotificationScreen(),
    ProfileScreen()
  ];


  List<PersistentBottomNavBarItem> _navBarsItems() => [
    PersistentBottomNavBarItem(
        icon: SvgPicture.asset(home,width: 24.w,color: AppColors.primaryColor),
        inactiveIcon: SvgPicture.asset(home,width: 24.w,color: AppColors.mediumGrayColor),
        title: "Home",
        activeColorPrimary: AppColors.primaryColor
    ),
    PersistentBottomNavBarItem(
        icon: SvgPicture.asset(appointment,width: 24.w,color: AppColors.primaryColor),
        inactiveIcon: SvgPicture.asset(appointment,width: 24.w,color: AppColors.mediumGrayColor),
        title: "Appointment",
        activeColorPrimary: AppColors.primaryColor
    ),
    PersistentBottomNavBarItem(
        icon: SvgPicture.asset(notifications,width: 24.w,color: AppColors.primaryColor),
        inactiveIcon: SvgPicture.asset(notifications,width: 24.w,color: AppColors.mediumGrayColor),
        title: "Notification",
        activeColorPrimary: AppColors.primaryColor
    ),
    PersistentBottomNavBarItem(
        icon: SvgPicture.asset(user,width: 24.w,color: AppColors.primaryColor),
        inactiveIcon: SvgPicture.asset(user,width: 24.w,color: AppColors.mediumGrayColor),
        title: "Profile",
        activeColorPrimary: AppColors.primaryColor
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: Keys.scaffoldKey,
        drawer: DrawerWidget(),
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: false,
          stateManagement: true,
          hideNavigationBarWhenKeyboardAppears: true,
          popBehaviorOnSelectedNavBarItemPress: PopBehavior.once,
          padding: EdgeInsets.symmetric(vertical: 5.h),
          backgroundColor: AppColors.whiteColor,
          decoration: NavBarDecoration(
            colorBehindNavBar: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withOpacity(0.4),
                blurRadius: 48,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          confineToSafeArea: true,
          navBarHeight: kBottomNavigationBarHeight,
          navBarStyle: _navBarStyle,
        )
    );
  }
}
