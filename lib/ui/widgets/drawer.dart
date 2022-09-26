import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/ui/screens/locations.dart';
import 'package:user/utilities/auth.dart';
import 'package:user/utilities/colors.dart';
import 'package:user/utilities/routes.dart';

class AppDrawer extends StatefulWidget {
  AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final List items = [
    {
      'label': 'My Cart',
      'icon': 'cart',
      'route': RoutesGenerater.myCart,
      'args': null
    },
    {
      'label': 'Your Orders',
      'icon': 'orders',
      'route': RoutesGenerater.myOrders,
      'args': null
    },
    {
      'label': 'Share',
      'icon': 'send',
      'route': RoutesGenerater.share,
      'args': null
    },
    {
      'label': 'Rating Us',
      'icon': 'star',
      'route': RoutesGenerater.rate,
      'args': null
    },
    {
      'label': 'Qr Code',
      'icon': 'qr',
      'route': RoutesGenerater.qrCode,
      'args': null
    },
    {
      'label': 'Location',
      'icon': 'location',
      'route': RoutesGenerater.locations,
      'args': LocationsArgs(intent: LocationsIntent.normal)
    },
    {'label': 'Payments', 'icon': 'wallet', 'route': null, 'args': null},
    {'label': 'Help', 'icon': 'help', 'route': null, 'args': null},
    // {'label': '', 'icon': '', 'route': null,'args':null},
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          SizedBox(
            height: 100,
            width: double.infinity,
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Image.asset(
                'assets/images/drawer-header.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Material(
              shadowColor: Colors.black,
              elevation: 10,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () async {
                        var sp = await SharedPreferences.getInstance();
                        sp.setString('lang', 'en');
                        context.setLocale(const Locale('en'));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        decoration: context.locale.languageCode == 'en'
                            ? BoxDecoration(
                                color: AppColors.brown3,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(40),
                              )
                            : BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                              ),
                        alignment: Alignment.center,
                        child: const Text(
                          "English",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ).tr(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () async {
                        var sp = await SharedPreferences.getInstance();
                        sp.setString('lang', 'ar');
                        // print(sp.getString('lang'));
                        context.setLocale(const Locale('ar'));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        decoration: context.locale.languageCode == 'ar'
                            ? BoxDecoration(
                                color: AppColors.brown3,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(40),
                              )
                            : BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                              ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Arabic",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ).tr(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.of(context)
                        .pushNamed(RoutesGenerater.notifications),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: SvgPicture.asset(
                            'assets/svg/notification.svg',
                            width: 30,
                            height: 30,
                            color: AppColors.brown4,
                          ),
                        ),
                        const Text(
                          'Notification',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColors.brown4),
                        ).tr()
                      ],
                    ),
                  ),
                ),
                FutureBuilder<SharedPreferences>(
                    future: SharedPreferences.getInstance(),
                    builder: (context, snap) {
                      if (!snap.hasData) {
                        return const SizedBox();
                      }
                      bool enabled = snap.data!.getBool('notifications') ??
                          (Platform.isAndroid ? true : false);
                      return Material(
                        shadowColor: Colors.black.withOpacity(0.2),
                        elevation: 10,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        child: Switch(
                          value: enabled,
                          onChanged: (v) async {
                            if (Platform.isIOS && v == true) {
                              FirebaseMessaging messaging =
                                  FirebaseMessaging.instance;

                              NotificationSettings settings =
                                  await messaging.requestPermission(
                                alert: true,
                                announcement: false,
                                badge: true,
                                carPlay: false,
                                criticalAlert: false,
                                provisional: false,
                                sound: true,
                              );
                              if (settings.authorizationStatus ==
                                  AuthorizationStatus.authorized) {
                                snap.data!.setBool('notifications', v);
                                setState(() {});
                              }
                            } else {
                              snap.data!.setBool('notifications', v);
                              setState(() {});
                            }
                          },
                          inactiveThumbColor: Colors.grey.shade500,
                          activeTrackColor: Colors.grey.shade700,
                          thumbColor:
                              MaterialStateProperty.all(AppColors.brown1),
                        ),
                      );
                    })
              ],
            ),
          ),
          ...(items
              .map((e) => InkWell(
                    onTap: () => Navigator.of(context)
                        .pushNamed(e['route'], arguments: e['args']),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SvgPicture.asset(
                              'assets/svg/${e['icon']}.svg',
                              width: 30,
                              height: 30,
                              color: AppColors.brown4,
                            ),
                          ),
                          Text(
                            e['label'],
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: AppColors.brown4),
                          ).tr()
                        ],
                      ),
                    ),
                  ))
              .toList()),
          const SizedBox(
            height: 32,
          ),
          InkWell(
            onTap: () {
              logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  RoutesGenerater.mainAuth, (_) => false);
            },
            child: Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SvgPicture.asset(
                    'assets/svg/logout.svg',
                    width: 30,
                    height: 30,
                    color: Colors.red.shade700,
                  ),
                ),
                Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade700,
                  ),
                ).tr()
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: InkWell(
                  onTap: () =>
                      Navigator.of(context).pushNamed(RoutesGenerater.profile),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'hi',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ).tr(args: [
                                  FirebaseAuth
                                      .instance.currentUser!.displayName!
                                ]),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Profile',
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 18),
                                ).tr()
                              ],
                            ),
                            Icon(
                              Icons.more_horiz,
                              color: Colors.grey.shade700,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
