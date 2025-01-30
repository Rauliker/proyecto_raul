import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_raul/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Implementamos el patrón singleton
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Inicializamos el servicio de notificaciones
  Future<void> initialize() async {
    // Solicitar permisos
    await requestPermissions();
    _configureForegroundNotifications();
    _configureBackgroundNotifications();
  }

  // Solicitar permisos al usuario para recibir notificaciones
  Future<void> requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Guardar la elección del usuario en SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notifications_granted',
        settings.authorizationStatus == AuthorizationStatus.authorized);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('Permisos concedidos');
    } else {
      debugPrint('Permisos denegados');
    }
  }

  // Método para obtener el token de FCM
  Future<String?> getToken() async {
    String? token = await _firebaseMessaging.getToken();
    debugPrint('FCM Token: $token');
    return token;
  }

  // Comprobar si el usuario ha concedido permisos
  Future<bool> hasGrantedPermissions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notifications_granted') ?? false;
  }

  // Configuración de notificaciones en primer plano
  void _configureForegroundNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(
          "Mensaje recibido en primer plano: ${message.notification?.title}");
      _showNotificationBanner(message);
    });
  }

  // Configuración de notificaciones cuando la app está en segundo plano o terminada
  void _configureBackgroundNotifications() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
          "Mensaje abierto desde segundo plano: ${message.notification?.title}");
      _showNotificationBanner(message);
    });
  }

  // Mostrar una notificación en pantalla
  void _showNotificationBanner(RemoteMessage message) {
    final context = navigatorKey.currentState?.overlay?.context;
    if (context != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message.notification?.title ?? "Notificación"),
            content: Text(message.notification?.body ?? "Sin contenido"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cerrar"),
              ),
            ],
          );
        },
      );
    }
  }
}
