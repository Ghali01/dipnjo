import 'package:hive_flutter/hive_flutter.dart';
part 'notification.g.dart';

@HiveType(typeId: 0)
class NotificationModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String text;

  @HiveField(2)
  DateTime time;
  NotificationModel({
    required this.title,
    required this.text,
    required this.time,
  });
}
