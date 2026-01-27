import 'package:flutter/cupertino.dart';
import 'package:centro_partner/core/classes/Keys.dart';

class Navigation {

  static bool get hasNavigationStack =>
      Keys.navigatorKey.currentState?.canPop() ?? false;

  static Future? popThenPush(Widget page) async {
    Navigation.pop();
    return await Navigation.push(page);
  }

  static Future? push(Widget page) async {
    if (Keys.navigatorKey.currentContext != null) {
      return await Navigator.push(
        Keys.navigatorKey.currentContext!,
        CupertinoPageRoute(builder: (context) => page),
      );
    }
  }

  static Future<void> pop({dynamic value}) async {
    Navigator.pop(Keys.navigatorKey.currentContext!, value);
  }

  static Future? pushReplacement(Widget page) async {
    return await Navigator.pushReplacement(
      Keys.navigatorKey.currentContext!,
      CupertinoPageRoute(builder: (context) => page),
    );
  }

  static Future? pushAndRemoveUntil(Widget page) async {
    return await Navigator.pushAndRemoveUntil(Keys.navigatorKey.currentContext!,
        CupertinoPageRoute(builder: (BuildContext context) => page), (Route<dynamic> route) => false);
  }
}
