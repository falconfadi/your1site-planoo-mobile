import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:centro_partner/core/constants/enum/notification_type.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {

  final _firebaseMessaging = FirebaseMessaging.instance;
  static String? deviceToken;
  static final ValueNotifier<String?> verificationCodeNotifier = ValueNotifier(null);

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true
    );
  }

  void initLocalNotifications(RemoteMessage message) async {
    var androidInitializeSettings = const AndroidInitializationSettings('@drawable/notification_icon');
    var iOSInitializeSettings = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitializeSettings, iOS: iOSInitializeSettings);
    await _flutterLocalNotificationsPlugin.initialize(initializationsSettings,onDidReceiveNotificationResponse: (payload){
      handleMessage(message);
    });
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      if(kDebugMode){
      }
      if(Platform.isAndroid){
        initLocalNotifications(message);
        showNotifications(message);
      } else {
        showNotifications(message);
      }
    });
  }

  Future<void> showNotifications(RemoteMessage message) async {
    AndroidNotificationChannel channel =
    AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High Importance Notifications',
      importance: Importance.max,

    );
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: "Your channel descriptions",
        importance: Importance.high,
        priority: Priority.high,
        ticker: "ticker"
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails
    );


    Future.delayed(Duration.zero,() {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    });
  }

  Future<void> getDeviceToken() async {
    deviceToken = await _firebaseMessaging.getToken();
    print("******************************");
    print('Device Token: $deviceToken');
    print("******************************");
  }

  void isTokenRefresh() async {
    _firebaseMessaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    /// when app terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage != null) {
      handleMessage(initialMessage);
    }
    /// when app in inBackground
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(event);
    });
  }

  void handleMessage(RemoteMessage message) async {
    print(message.data);
    final notificationType = NotificationType.fromInt(int.parse(message.data['type']));
    switch (notificationType) {
      case NotificationType.verificationCode:
        final codeValue = jsonDecode(message.data['code'])['code'].toString();
        verificationCodeNotifier.value = null;
        verificationCodeNotifier.value = codeValue;
        break;

      default:
        break;
    }
  }
}