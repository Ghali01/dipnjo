import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  late String title;
  late String text;
  late String channelId, channelDesc;
  switch (message.data['type']) {
    case NotificationTypes.orderStatus:
      {
        title = await translate('Order Status');
        text = await translate(message.data['status'] + 's',
            args: [message.data['order_id'].toString()]);
        channelId = 'foods-1';
        channelDesc = 'foods';
      }
      break;
    case NotificationTypes.notifiction:
      {
        title = message.notification!.title!;
        text = message.notification!.body!;
        channelId = 'noti-1';
        channelDesc = 'notifications';
      }
      break;
  }
  SharedPreferences sp = await SharedPreferences.getInstance();
  bool enabled =
      sp.getBool('notifications') ?? (Platform.isAndroid ? true : false);
  if (enabled) {
    FlutterLocalNotificationsPlugin().show(
      Random().nextInt(1000000),
      title,
      text,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelDesc,
          importance: Importance.max,
        ),
      ),
    );
  }
  await Hive.initFlutter();
  Hive.registerAdapter(NotificationModelAdapter());
  await Hive.openBox<NotificationModel>('notifications');
  var box = Hive.box<NotificationModel>('notifications');
  await box
      .add(NotificationModel(title: title, text: text, time: DateTime.now()));
  // print(box.values.cast<NotificationModel>().last.title);
}

Future<String> translate(String key, {List<String>? args}) async {
  var sp = await SharedPreferences.getInstance();
  // print(sp.getString('lang'));
  String trjs = await rootBundle
      .loadString('assets/translations/${sp.getString('lang') ?? 'en'}.json');
  var trData = jsonDecode(trjs);
  String t = trData[key];
  if (args != null) {
    for (String a in args) {
      t = t.replaceFirst('{}', a);
    }
  }
  return t;
}
