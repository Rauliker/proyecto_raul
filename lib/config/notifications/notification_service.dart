import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> initialize(BuildContext context) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationTap(response.payload, context);
      },
    );

    await requestPermissions();
    _configureForegroundNotifications();
    if (!context.mounted) return;

    _configureBackgroundNotifications(context);
  }

  Future<void> requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notifications_granted',
        settings.authorizationStatus == AuthorizationStatus.authorized);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('Permisos concedidos');
    } else {
      debugPrint('Permisos denegados');
    }
  }

  Future<String?> getToken() async {
    String? token = await _firebaseMessaging.getToken();
    debugPrint('FCM Token: $token');
    return token;
  }

  Future<bool> hasGrantedPermissions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notifications_granted') ?? false;
  }

  void _configureForegroundNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(
          "Mensaje recibido en primer plano: ${message.notification?.title}");
      _showNotificationBanner(message);
    });
  }

  void _configureBackgroundNotifications(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
          "Mensaje abierto desde segundo plano: ${message.notification?.title}");
      if (!context.mounted) return;

      _handleNotificationTap(message.data['screen'], context);
    });

    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        if (!context.mounted) return;
        _handleNotificationTap(message.data['screen'], context);
      }
    });
  }

  void _showNotificationBanner(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      icon: '@mipmap/ic_launcher',
      priority: Priority.high,
      importance: Importance.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: message.data['screen'],
    );
  }

  void _handleNotificationTap(String? screen, BuildContext context) {
    if (screen != null) {
      context.go(screen);
    }
  }
}
