import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    try {
      // 1. Request Permission from the user
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        debugPrint('User declined push notifications');
        return;
      }

      // 2. Initialize Local Notifications (For Foreground display)
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInit = DarwinInitializationSettings();
      await _localNotifications.initialize(
        settings: InitializationSettings(android: androidInit, iOS: iosInit),
      );

      // Create the high priority channel for Android
      const channel = AndroidNotificationChannel(
        'fuse_high_priority',
        'High Priority Notifications',
        description: 'Used for dying posts and messages',
        importance: Importance.max,
      );
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);

      // 3. Get the FCM Token and send it to Supabase
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _registerTokenWithSupabase(token);
      }

      // Listen for token refreshes
      _firebaseMessaging.onTokenRefresh.listen(_registerTokenWithSupabase);

      // 4. Handle Foreground Messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _showLocalNotification(message);
      });
    } catch (e) {
      debugPrint('Failed to initialize notifications: $e');
    }
  }

  Future<void> _registerTokenWithSupabase(String token) async {
    // Supabase native method to store the FCM token for the current user
    try {
      // This assumes you are using the built-in Supabase push setup.
      // If you are using a custom table, you would insert the token into a `user_fcm_tokens` table here.
      // For now, we will use a custom RPC to store it securely.
      await Supabase.instance.client.rpc(
        'register_fcm_token',
        params: {'p_token': token},
      );
    } catch (e) {
      debugPrint('Error registering token: $e');
    }
  }

  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'fuse_high_priority',
          'High Priority Notifications',
          channelDescription: 'Used for dying posts and messages',
          importance: Importance.max,
          priority: Priority.high,
          color: Color(0xFFFF3366), // AppColors.danger
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
          presentBadge: true,
        ),
      ),
    );
  }
}
