import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:user/db/notification.dart';
import 'package:user/ui/widgets/app_bar.dart';
import 'package:user/utilities/colors.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({Key? key}) : super(key: key);
  final DateFormat dateFormat = DateFormat('d.M.yyyy');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 56),
        child: AppAppBar(
          title: 'Notifications',
          inNotificiation: true,
        ),
      ),
      body: ValueListenableBuilder<Box<NotificationModel>>(
        valueListenable:
            Hive.box<NotificationModel>('notifications').listenable(),
        builder: (context, value, child) {
          List notifications = value.values.toList().cast<NotificationModel>();
          notifications.sort(
            (a, b) => a.time.compareTo(b.time),
          );
          notifications = notifications.reversed.toList();
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
              child: Row(
                children: [
                  SizedBox.square(
                    dimension: 64,
                    child: Image.asset(
                      'assets/images/donuts2.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: notifications[index].title + ' ',
                                style: const TextStyle(
                                  color: AppColors.brown4,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: notifications[index].text,
                                style: const TextStyle(
                                  color: Color(0xff909090),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          dateFormat.format(notifications[index].time),
                          style: const TextStyle(
                            color: Color(0xff909090),
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
