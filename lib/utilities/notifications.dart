import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' show Random;
import 'package:user/db/notification.dart';
import 'package:hive/hive.dart';

class NotificationTypes {
  static const orderStatus = '1';
  static const notifiction = '2';
}

Future<void> initNoitification() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('donuts');
  const IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (_) {});
}

Future<void> handleNotification(RemoteMessage message) async {
  switch (message.data['type']) {
    case NotificationTypes.orderStatus:
      {
        String title = tr('Order Status');
        String text = tr(message.data['status'] + 's',
            args: [message.data['order_id'].toString()]);
        SharedPreferences sp = await SharedPreferences.getInstance();
        bool enabled =
            sp.getBool('notifications') ?? (Platform.isAndroid ? true : false);
        if (enabled) {
          FlutterLocalNotificationsPlugin().show(
              Random().nextInt(1000000),
              title,
              text,
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  "foods-1",
                  'foods',
                  importance: Importance.max,
                ),
              ));
        }
        var box = Hive.box<NotificationModel>('notifications');
        await box.add(
            NotificationModel(title: title, text: text, time: DateTime.now()));
      }
      break;
  }
}
