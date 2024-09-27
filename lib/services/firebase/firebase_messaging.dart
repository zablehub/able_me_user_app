import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/services/app_src/data_cacher.dart';
import 'package:able_me/services/auth/user_data.dart';
import 'package:able_me/utils/notify_widget.dart';
import 'package:able_me/view_models/notifiers/my_booking_history_notifier.dart';
import 'package:able_me/view_models/notifiers/transsaction_notifier.dart';
import 'package:able_me/views/widget_components/full_screen_loader.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notify_inapp/notify_inapp.dart';
import 'package:permission_handler/permission_handler.dart';

class FirebaseMessagingServices {
  final FirebaseMessaging _firebase = FirebaseMessaging.instance;
  final UserDataApi _api = UserDataApi();
  final DataCacher _cacher = DataCacher.instance;
  final Notify _notify = Notify();
  Future<void> handleOnMessage(BuildContext context, WidgetRef ref) async {
    FirebaseMessaging.onMessage.listen((message) {
      print("ON APP MESSAGE: ${message.data}");
      if (message.data['type'] == 'update-booking') {
        ref.invalidate(userBookingHistory);
      } else if (message.data['type'] == 'update-transaction') {
        ref.invalidate(ongoingTransactionsProvider);
      }
      _notify.show(
        context,
        duration: 600,
        NotifyingWidget(
            body: message.notification?.body ?? "",
            title: message.notification?.title ?? ""),
      );
      // showGeneralDialog(
      //     context: context,
      //     pageBuilder: (BuildContext context, Animation<double> animation,
      //         Animation<double> secondaryAnimation) {
      //       return AlertDialog.adaptive(
      //         title: Text("ASDADASA"),
      //       );
      //     });
    });
  }

  Future<void> handleOnMessageOpened(WidgetRef ref) async {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.data['type'] == 'update-booking') {
        ref.invalidate(userBookingHistory);
      } else if (message.data['type'] == 'update-transaction') {
        ref.invalidate(ongoingTransactionsProvider);
      }
    });
  }

  Future<RemoteMessage?> getInitialMessage() async {
    return await _firebase.getInitialMessage();
  }

  // void listen() {
  //   // FirebaseMessaging.onMessage.listen(
  //   //   (RemoteMessage message) {
  //   //     print("ON APP MESSAGE: ${message.notification?.title ?? "NO TITLE"}");
  //   //     if (message.data['urgency'] != null &&
  //   //         message.data['urgency'] == "high") {
  //   //       _showUrgentDialog(message);
  //   //       return;
  //   //     }
  //   //     _showNotification(message);
  //   //   },
  //   // );
  //   // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   //   print(
  //   //       "NOTIF CLICKED ${message.notification?.title ?? "NO TITLE ON OPENED"}");
  //   //   if (message.data['urgency'] != null &&
  //   //       message.data['urgency'] == "high") {
  //   //     _showUrgentDialog(message);
  //   //     return;
  //   //   }
  //   //   _showNotification(message);
  //   //   // Handle message when app is opened
  //   // });
  // }

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
      await _cacher.saveFcmToken(token);
      print("FCM TOKEN : $token");
      // listen();
    }
  }

  Future<bool> init(int id) async {
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
    return isEnabled;
  }

  void _showNotification(RemoteMessage message, BuildContext context) async {
    // Extract notification details
    final notification = message.notification;
    final notificationType =
        message.data['type']; // Assuming type is passed in the data payload

    // Default notification
    if (notification != null) {
      if (notificationType == 'urgent') {
        _showUrgentDialog(message, context);
      } else {
        // final BuildContext context = navigatorKey.currentContext!;
        // _localNotifier.showMessage(context,
        //     title: message.notification!.title!);
      }
    }
  }

  void _showUrgentDialog(RemoteMessage message, BuildContext context) async {
    // final BuildContext context = navigatorKey.currentContext!;

    await showGeneralDialog(
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

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
