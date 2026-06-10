import 'package:centro_partner/core/classes/firebase_api.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:centro_partner/features/appointment/ui/appointments_screen.dart';
import 'package:centro_partner/features/home/ui/home_screen.dart';
import 'package:centro_partner/features/general/widget/drawer_widget.dart';
import 'package:centro_partner/features/notification/data/notification_repository/notification_repository.dart';
import 'package:centro_partner/features/notification/data/usecase/check_new_notifications_usecase.dart';
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late PersistentTabController _controller;
  final NavBarStyle _navBarStyle = NavBarStyle.style12;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: widget.pageIndex);
    checkNewNotifications();

    FirebaseApi.instance.onNotificationChange = () {
      checkNewNotifications();
    };
  }

  Future<void> checkNewNotifications() async {
    final result = await CheckNewNotificationsUseCase(NotificationRepository()).call(
      params: CheckNewNotificationsParams(),
    );
    if (result.hasDataOnly) {
      FirebaseApi.instance.hasNewNotificationsNotifier.value = result.data!.newNotifications!;
    }
  }

  List<Widget> _buildScreens() => [
    HomeScreen(scaffoldKey: _scaffoldKey),
    AppointmentsScreen(scaffoldKey: _scaffoldKey),
    NotificationScreen(scaffoldKey: _scaffoldKey, onNotificationsUpdated: checkNewNotifications,),
    ProfileScreen(scaffoldKey: _scaffoldKey)
  ];

  List<PersistentBottomNavBarItem> _navBarsItems(bool isTablet) => [
    PersistentBottomNavBarItem(
        icon: Padding(
          padding: EdgeInsets.only(top: isTablet ? 8.h : 0),
          child: SvgPicture.asset(home,width: 24.w,color: AppColors.primaryColor),
        ),
        inactiveIcon: Padding(
          padding: EdgeInsets.only(top: isTablet ? 8.h : 0),
          child: SvgPicture.asset(home,width: 24.w,color: AppColors.mediumGrayColor),
        ),
        title: "Home",
        activeColorPrimary: AppColors.primaryColor
    ),
    PersistentBottomNavBarItem(
        icon: Padding(
          padding: EdgeInsets.only(top: isTablet ? 8.h : 0),
          child: SvgPicture.asset(appointment,width: 24.w,color: AppColors.primaryColor),
        ),
        inactiveIcon: Padding(
          padding: EdgeInsets.only(top: isTablet ? 8.h : 0),
          child: SvgPicture.asset(appointment,width: 24.w,color: AppColors.mediumGrayColor),
        ),
        title: "Appointment",
        activeColorPrimary: AppColors.primaryColor
    ),
    PersistentBottomNavBarItem(
      icon: ValueListenableBuilder<bool>(
        valueListenable: FirebaseApi.instance.hasNewNotificationsNotifier,
        builder: (_, hasNew, __) {
          return notificationIcon(
            active: true,
            hasNewNotifications: hasNew,
            isTablet: isTablet
          );
        },
      ),
      inactiveIcon: ValueListenableBuilder<bool>(
        valueListenable: FirebaseApi.instance.hasNewNotificationsNotifier,
        builder: (_, hasNew, __) {
          return notificationIcon(
            active: false,
            hasNewNotifications: hasNew,
              isTablet: isTablet
          );
        },
      ),
      title: "Notification",
      activeColorPrimary: AppColors.primaryColor,
    ),
    PersistentBottomNavBarItem(
        icon: Padding(
          padding: EdgeInsets.only(top: isTablet ? 8.h : 0),
          child: SvgPicture.asset(user,width: 24.w,color: AppColors.primaryColor),
        ),
        inactiveIcon: Padding(
          padding: EdgeInsets.only(top: isTablet ? 8.h : 0),
          child: SvgPicture.asset(user,width: 24.w,color: AppColors.mediumGrayColor),
        ),
        title: "Profile",
        activeColorPrimary: AppColors.primaryColor
    ),
  ];

  Widget notificationIcon({required bool active, required bool hasNewNotifications,required bool isTablet}) {
    return SizedBox(
      width: 24.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: isTablet ? 8.h : 0),
              child: SvgPicture.asset(notifications, width: 24.w,
                color: active ? AppColors.primaryColor : AppColors.mediumGrayColor,
              ),
            ),
          ),
          if (hasNewNotifications)
            Positioned(
              top: 10.h,
              right: 1.w,
              child: Container(
                width: 7.w,
                height: 7.w,
                decoration: BoxDecoration(
                  color: AppColors.redColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    return Scaffold(
        key: _scaffoldKey,
        drawer: DrawerWidget(),
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(isTablet),
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: false,
          stateManagement: true,
          hideNavigationBarWhenKeyboardAppears: true,
          popBehaviorOnSelectedNavBarItemPress: PopBehavior.once,
          padding: EdgeInsets.symmetric(vertical: isTablet ? 0 : 5.h),
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
          navBarHeight: isTablet ? 75 : kBottomNavigationBarHeight,
          navBarStyle: _navBarStyle,
        )
    );
  }
}
