import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:centro_partner/core/constants/enum/notification_type.dart';
import 'package:centro_partner/core/utils/navigation/navigation.dart';
import 'package:centro_partner/features/appointment/ui/appointment_details_screen.dart';
import 'package:centro_partner/features/general/ui/nav_bar_screen.dart';
import 'package:centro_partner/features/home/ui/course/course_details_screen.dart';
import 'package:centro_partner/features/home/ui/event/event_details_screen.dart';
import 'package:centro_partner/features/notification/ui/notification_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// todo add more code for ios later
class FirebaseApi {

  static String? deviceToken;
  static RemoteMessage? _initialMessage;
  static bool _appReady = false;

  final _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    _firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);
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

  void init() {
    /// Foreground
    FirebaseMessaging.onMessage.listen((message) {
      _showLocalNotification(message);
    });

    /// Background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _navigateFromMessage(message);
    });

    /// Terminated
    _firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {
        _initialMessage = message;
        _tryNavigate();
      }
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    if (Platform.isAndroid) {
      const android = AndroidInitializationSettings('@drawable/notification_icon');
      const init = InitializationSettings(android: android);
      await _flutterLocalNotificationsPlugin.initialize(init, onDidReceiveNotificationResponse: (_) {
        _navigateFromMessage(message);
      });
    }

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High Importance',
      importance: Importance.max,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high',
          'High',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  void appIsReady() {
    _appReady = true;
    _tryNavigate();
  }

  void _tryNavigate() {
    if (_initialMessage != null && _appReady) {
      _navigateFromMessage(_initialMessage!);
      _initialMessage = null;
    }
  }

  void _navigateFromMessage(RemoteMessage message) {
    final data = message.data;
    final notificationType = NotificationType.fromInt(int.parse(data['type']));
    Widget target;

    switch (notificationType) {
      case NotificationType.normal:
      case NotificationType.verificationCode:  /// example response: {code: 15979, type: 1}
        target = NotificationScreen();
        break;
      case NotificationType.appointment: /// example response: {appointment: 4, type: 5}
        target = AppointmentDetailsScreen(
          appointmentId: int.parse(data['appointment']),
        );
        break;
      case NotificationType.course: /// example response: {course: 55, type: 3}
        target = CourseDetailsScreen(
          courseId: int.parse(data['course']),
        );
      case NotificationType.event: /// example response: {event: 14, type: 4}
        target = EventDetailsScreen(
          eventId: int.parse(data['event']),
        );
        break;
      // todo more cases later for activity - chat - session
      default:
        return;
    }

    if (Navigation.hasNavigationStack) {
      Navigation.push(target);
      return;
    }
    Navigation.pushReplacement(NavBarScreen(pageIndex: 0));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigation.push(target);
    });
  }
}

