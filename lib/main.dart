import 'package:centro_partner/core/classes/Keys.dart';
import 'package:centro_partner/core/classes/app_storage.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/constants/end_point.dart';
import 'package:centro_partner/features/auth/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:centro_partner/core/classes/app_localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStorage.init();
  await ScreenUtil.ensureScreenSize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(locale);
  }
}

class _MyAppState extends State<MyApp> {

  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    // AppStorage.removeData(key: kAccessToken);
    // AppStorage.removeData(key: userID);
    // AppStorage.removeData(key: userType);
    /// load application language:
    AppStorage.loadLanguage().then((languageCode) {
      setState(() {
        if(AppStorage.getData(key: headerLanguageKey) == null) {
          AppStorage.saveData(key: headerLanguageKey, value: languageCode);
        }
        _locale = Locale(languageCode);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(400, 900),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
            navigatorKey: Keys.navigatorKey,
            supportedLocales: const [Locale('en', ''), Locale('ar', '')],
            locale: _locale,
            localizationsDelegates: const [
              AppLocalization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (local, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == local!.languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            debugShowCheckedModeBanner: false,
            title: 'Planoo',
            theme: ThemeData(
              iconTheme: IconThemeData(color: AppColors.blackColor),
              textTheme: AppTheme.textTheme,
              useMaterial3: true,
            ),
            home: SplashScreen()
        );
      },
    );
  }
}