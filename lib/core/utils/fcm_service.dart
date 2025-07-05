import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/utils/cache_helper.dart';
import 'package:nahkum/core/utils/firebase_options.dart';
import 'package:nahkum/features/chat/presentation/controller/chat_controller.dart';

class FcmService {
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    '1',
    'channel',
    description: 'Nahkum notification channel',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isForegroundHandlerSet = false;

  Future<void> getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    cache.write(CacheHelper.fcmToken, token);
  }

  Future<void> refreshToken() async {
    await getToken();
  }

  displayNotification(RemoteNotification notification) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          color: AppColors.gold,
          importance: Importance.max,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  handleForeground() {
    if (!_isForegroundHandlerSet) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          try {
            Map<String, dynamic> map =
                jsonDecode(message.notification?.body ?? '');
            if (map.containsKey('type')) {
              if (map['type'] == 'chat') {
                if (Get.isRegistered<ChatController>()) {
                  Get.find<ChatController>().receiveMessage(message);
                } else {
                  RemoteNotification newNotification = RemoteNotification(
                    body: map['message'],
                    android: notification.android,
                    apple: notification.apple,
                    bodyLocArgs: notification.bodyLocArgs,
                    bodyLocKey: notification.bodyLocKey,
                    title: notification.title,
                    titleLocArgs: notification.titleLocArgs,
                    titleLocKey: notification.titleLocKey,
                    web: notification.web,
                  );
                  displayNotification(newNotification);
                }
              } else {
                displayNotification(notification);
              }
            } else {
              displayNotification(notification);
            }
          } catch (e) {
            print(e.toString() + "ssssssssssssssssssssssssssss 88");

            displayNotification(notification);
          }
        }
      });
      _isForegroundHandlerSet = true;
    }
  }

  handleBackground() {
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> init() async {
    final bool notificationsEnabled =
        cache.read(CacheHelper.notificationsEnabled) ?? true;
    if (!notificationsEnabled) return;
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    flutterLocalNotificationsPlugin.cancelAll();

    var pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    if (pendingNotificationRequests.isNotEmpty) {
      flutterLocalNotificationsPlugin.cancelAll();
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      cache.write(CacheHelper.fcmToken, newToken);
    });

    handleForeground();
    handleBackground();
    await getToken();
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    FcmService().displayNotification(notification);
  }
}
