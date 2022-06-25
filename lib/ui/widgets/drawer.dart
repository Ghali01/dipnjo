import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user/ui/screens/locations.dart';
import 'package:user/utilities/colors.dart';
import 'package:user/utilities/routes.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key}) : super(key: key);
  final List items = [
    {
      'label': 'My Cart',
      'icon': 'cart',
      'route': RoutesGenerater.myCart,
      'args': null
    },
    {'label': 'Your Orders', 'icon': 'orders', 'route': null, 'args': null},
    {'label': 'Share', 'icon': 'send', 'route': null, 'args': null},
    {'label': 'Rating Us', 'icon': 'star', 'route': null, 'args': null},
    {'label': 'Qr Code', 'icon': 'qr', 'route': null, 'args': null},
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                          color: AppColors.brown3,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(40)),
                      alignment: Alignment.center,
                      child: const Text(
                        "English",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ).tr(),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40)),
                      alignment: Alignment.center,
                      child: const Text(
                        "Arabic",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ).tr(),
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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    )
                  ],
                ),
                Material(
                  shadowColor: Colors.black.withOpacity(0.2),
                  elevation: 10,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  child: Switch(
                    value: false,
                    onChanged: (v) {},
                    thumbColor: MaterialStateProperty.all(AppColors.brown1),
                  ),
                )
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
            height: 64,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
              )
            ],
          )
        ],
      ),
    );
  }
}
