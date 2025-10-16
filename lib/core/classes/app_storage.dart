import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/end_point.dart';
import 'package:centro_partner/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {

  static late SharedPreferences sharedPreferences;

  static String languageCode = "ar";

  static Future<SharedPreferences> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences;
  }

  static Future<bool> saveData({required String key, required dynamic value}) async {
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);
    return await sharedPreferences.setDouble(key, value);
  }

  static dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  static Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

  /// language ///
  static Future<String> loadLanguage() async {
    try {
      String lang = getData(key: headerLanguageKey) ?? 'default';
      if(lang != "default") {
        languageCode = lang;
      }
      else {
        languageCode = "en";
      }
      return languageCode;
    } catch(e) {
      return "en";
    }
  }

  static Future<void> saveLanguage(BuildContext context, String lang) async {
    languageCode = lang;
    await saveData(key: headerLanguageKey, value: lang);
    if (context.mounted) {
      MyApp.setLocale(context, Locale(lang));
    }
  }

  static void changeLanguage(BuildContext context, String lang) {
    languageCode = lang;
    Locale locale = Locale(lang);
    MyApp.setLocale(context, locale);
    saveLanguage(context,lang);
  }

}
