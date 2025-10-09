import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/features/auth/ui/sign_in_screen.dart';
import 'package:centro_partner/features/general/ui/nav_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/classes/app_storage.dart';
import 'dart:async';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/end_point.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () async {
      // todo later check account type
      if(AppStorage.getData(key: kAccessToken) != null) {
        Navigation.pushReplacement(NavBarScreen(pageIndex: 0));
      } else {
        Navigation.pushReplacement(SignInScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(splash),
                fit: BoxFit.fill
              )
            ),
          ),
          Container(
            color: Colors.transparent.withOpacity(0.1),
          ),
          Positioned(
            top: 1.sh * 0.05,
            left: 1.sw * 0.15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(logo,height: 100.h,width: 1.sw),
                RichText(
                  text: TextSpan(
                    text: AppLocalization.of(context).translate("plan_your"),
                    style: AppTheme.labelLarge.copyWith(fontSize: 24.sp,color: AppColors.primaryColor),
                    children: [
                      TextSpan(text: " "),
                      TextSpan(
                        text: AppLocalization.of(context).translate("life"),
                        style: AppTheme.bodyLarge.copyWith(fontSize: 26.sp,color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
