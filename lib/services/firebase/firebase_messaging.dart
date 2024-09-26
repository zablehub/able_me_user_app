import 'package:able_me/services/auth/user_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class FirebaseMessagingServices {
  final FirebaseMessaging _firebase = FirebaseMessaging.instance;
  final UserDataApi _api = UserDataApi();
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  FirebaseMessagingServices() {
    // Initialize local notifications settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: DarwinInitializationSettings());
    _localNotifications.initialize(initializationSettings);
  }

  Future<RemoteMessage?> getInitialMessage() async {
    return await _firebase.getInitialMessage();
  }

  void listen() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("ON APP MESSAGE: ${message.notification?.title ?? "NO TITLE"}");
      if (message.data['urgency'] != null &&
          message.data['urgency'] == "high") {
        _showUrgentDialog(message);
        return;
      }
      _showNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          "NOTIF CLICKED ${message.notification?.title ?? "NO TITLE ON OPENED"}");
      if (message.data['urgency'] != null &&
          message.data['urgency'] == "high") {
        _showUrgentDialog(message);
        return;
      }
      _showNotification(message);
      // Handle message when app is opened
    });
  }

  Future<bool> isEnabled() async {
    final PermissionStatus status = await Permission.notification.status;
    return status == PermissionStatus.granted ||
        status == PermissionStatus.provisional;
  }

  Future<void> _initializeFM() async {
    await _firebase.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    String? token = await _firebase.getToken();
    if (token != null) {
      await _api.addFCMToken(token);
      print("FCM TOKEN : $token");
      listen();
    }
  }

  Future<void> init() async {
    final bool isEnabled = await this.isEnabled();
    print("ENABLED FCM : $isEnabled");
    if (isEnabled) {
      await _initializeFM();
    } else {
      Fluttertoast.showToast(msg: "Notification disabled");
      final PermissionStatus status = await Permission.notification.request();
      final bool enable = status == PermissionStatus.granted ||
          status == PermissionStatus.provisional;
      if (enable) {
        await _initializeFM();
      } else {
        Fluttertoast.showToast(msg: "Notification disabled");
      }
    }
  }

  void _showNotification(RemoteMessage message) async {
    // Extract notification details
    final notification = message.notification;
    final notificationType =
        message.data['type']; // Assuming type is passed in the data payload

    // Default notification
    if (notification != null) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('your_channel_id', 'your_channel_name',
              channelDescription: 'your_channel_description',
              importance: Importance.max,
              priority: Priority.high,
              playSound: true);
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await _localNotifications.show(
        0,
        notification.title,
        notification.body,
        platformChannelSpecifics,
        payload: message.data['type'],
      );

      // Check if the notification type is urgent
      if (notificationType == 'urgent') {
        _showUrgentDialog(message);
      }
    }
  }

  void _showUrgentDialog(RemoteMessage message) {
    final BuildContext context = navigatorKey.currentContext!;

    showGeneralDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog dismissal
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return AlertDialog(
          title: Text(message.notification?.title ?? "Urgent"),
          content: Text(message.notification?.body ?? "Urgent message content"),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Optionally, you could add more logic here
              },
            ),
          ],
        );
      },
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
