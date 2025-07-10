import 'package:centro_partner/core/clasess/Keys.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/features/home/ui/court/court_appointments_screen.dart';
import 'package:centro_partner/features/home/ui/home_screen.dart';
import 'package:centro_partner/features/home/ui/trainer/trainer_course_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:centro_partner/core/constants/app_images.dart';

class NavBarScreen extends StatefulWidget {

  int pageIndex;
  NavBarScreen({required this.pageIndex});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.pageIndex);
  }

  void setPage(int pageIndex) {
    setState(() {
      widget.pageIndex = pageIndex;
    });
    pageController.animateToPage(pageIndex, duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  List<Widget> get screens => [
    CourtAppointmentsScreen(onNavigate: setPage),
    // TrainerCourseScreen(onNavigate: setPage),
    HomeScreen(),
    Container(color: Colors.green),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Keys.scaffoldKey,
      backgroundColor: AppColors.whiteColor,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r)
        ),
        child: BottomAppBar(
          height: 65,
          color: AppColors.primaryColor,
          clipBehavior: Clip.antiAlias,
          shape: const CircularNotchedRectangle(),
          child: Row(children: [
            bottomNavItem(icon: widget.pageIndex == 0 ? filledAppointment : appointment, onTap: () => setPage(0)),
            bottomNavItem(icon: widget.pageIndex == 1 ? filledHome : home, onTap: () => setPage(1)),
            bottomNavItem(icon: widget.pageIndex == 2 ? filledNotifications : notifications, onTap: () => setPage(2)),
          ]),
        ),
      ),
      body: PageView.builder(
        controller: pageController,
        itemCount: screens.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return screens[index];
        },
      ),
    );
  }

  Widget bottomNavItem({
    required String icon,
    required VoidCallback onTap,
  }) {
    final bool isHomeIcon = icon == filledHome || icon == home;

    return Expanded(
      child: IconButton(
        icon: SvgPicture.asset(
          icon,
          width: isHomeIcon ? 60.w : 24.w,
          height: isHomeIcon ? 60.w : 24.w,
        ),
        onPressed: onTap,
      ),
    );
  }

}
