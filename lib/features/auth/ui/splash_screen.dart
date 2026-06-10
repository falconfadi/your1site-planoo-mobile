import 'package:centro_partner/core/classes/firebase_api.dart';
import 'package:centro_partner/features/auth/ui/sign_in_screen.dart';
import 'package:centro_partner/features/general/ui/nav_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/classes/app_storage.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/end_point.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToNextScreen();
      }
    });
  }

  void _navigateToNextScreen() {
    final token = AppStorage.getData(key: kAccessToken);

    if (token == null) {
      Navigation.pushReplacement(SignInScreen());
      return;
    }

    if (JwtDecoder.isExpired(token)) {
      AppStorage.removeData(key: kAccessToken);
      AppStorage.removeData(key: kAccessTokenExpirationDate);
      Navigation.pushReplacement(SignInScreen());
      return;
    }
    Navigation.pushReplacement(NavBarScreen(pageIndex: 0));
    FirebaseApi.instance.appIsReady();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Lottie.asset(
          splash,
          controller: _controller,
          animate: false,
          onLoaded: (composition) {
            _controller..duration = composition.duration..forward(from: 0.0);
          },
        ),
      ),
    );
  }
}
