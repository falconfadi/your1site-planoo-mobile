import 'package:centro_partner/features/auth/ui/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/clasess/app_storage.dart';
import 'dart:async';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/end_point.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';

class SplashScreen extends StatefulWidget {

  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () async {
      if(((AppStorage.getData(key: accountType) == "court" && AppStorage.getData(key: isFillInfo) == 1) ||
          (AppStorage.getData(key: accountType) != "court" && AppStorage.getData(key: isFillInfo) == 1)) &&
          AppStorage.getData(key: kAccessToken) != null
      ) {
        if(AppStorage.getData(key: accountType) == "court") {
          // todo check info of court
        } else {
          // todo check info of trainer
        }
      } else {
        Navigation.pushReplacement(SignInScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: Image.asset(logo),
      ),
    );
  }
}
