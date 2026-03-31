import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:centro_partner/core/utils/navigation/navigation.dart';
import 'package:centro_partner/features/appointment/ui/appointment_details_screen.dart';
import 'package:centro_partner/features/general/ui/nav_bar_screen.dart';
import 'package:centro_partner/features/home/ui/course/course_details_screen.dart';
import 'package:centro_partner/features/home/ui/event/event_details_screen.dart';
import 'package:centro_partner/features/notification/ui/notification_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  static String? deviceToken;
  static RemoteMessage? _initialMessage;
  static bool _appReady = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await requestNotificationPermission();
    await _initLocalNotifications();
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await getDeviceToken();
    _listenToMessages();
  }

  Future<void> requestNotificationPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('Permission: ${settings.authorizationStatus}');
  }

  Future<void> getDeviceToken() async {
    try {
      if (Platform.isIOS) {
        String? apnsToken;
        int retry = 0;

        while (apnsToken == null && retry < 10) {
          apnsToken = await _firebaseMessaging.getAPNSToken();
          await Future.delayed(const Duration(milliseconds: 500));
          retry++;
          debugPrint('APNS Token: $apnsToken');
        }

        debugPrint('APNS Token: $apnsToken');
      }

      deviceToken = await _firebaseMessaging.getToken();

      debugPrint('FCM Token: $deviceToken');
    } catch (e) {
      debugPrint('Error getting token: $e');
    }
  }

  void listenToTokenRefresh() {
    _firebaseMessaging.onTokenRefresh.listen((token) {
      deviceToken = token;
      debugPrint('🔄 Token refreshed: $token');
    });
  }

  void _listenToMessages() {
    /// Foreground
    FirebaseMessaging.onMessage.listen((message) {
      _showLocalNotification(message);
    });

    /// Background (opened from notification)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessageNavigation(message);
    });

    /// Terminated
    _firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {
        _initialMessage = message;
        _tryNavigate();
      }
    });
  }

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@drawable/notification_icon');

    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: android,
      iOS: ios,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {},
    );

    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.max,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const android = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const ios = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: android,
      iOS: ios,
    );

    await _localNotifications.show(
      Random().nextInt(100000),
      message.notification?.title,
      message.notification?.body,
      details,
    );
  }

  void appIsReady() {
    _appReady = true;
    _tryNavigate();
  }

  void _tryNavigate() {
    if (_initialMessage != null && _appReady) {
      _handleMessageNavigation(_initialMessage!);
      _initialMessage = null;
    }
  }

  void _handleMessageNavigation(RemoteMessage message) {
    final data = message.data;

    if (data.isEmpty || !data.containsKey('type')) return;

    final type = int.tryParse(data['type'].toString());
    if (type == null) return;

    Widget target;

    switch (type) {
      case 1:
        target = const NotificationScreen();
        break;

      case 3:
        target = CourseDetailsScreen(
          courseId: int.parse(data['course']),
        );
        break;

      case 4:
        target = EventDetailsScreen(
          eventId: int.parse(data['event']),
        );
        break;

      case 5:
        target = AppointmentDetailsScreen(
          appointmentId: int.parse(data['appointment']),
        );
        break;

      default:
        return;
    }

    if (Navigation.hasNavigationStack) {
      Navigation.push(target);
    } else {
      Navigation.pushReplacement(const NavBarScreen(pageIndex: 0));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigation.push(target);
      });
    }
  }
}

