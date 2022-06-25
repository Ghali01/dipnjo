import 'package:flutter/material.dart';
import 'package:user/ui/screens/menu.dart';
import 'package:user/utilities/colors.dart';
import 'package:user/utilities/routes.dart';
import 'package:easy_localization/easy_localization.dart';

class AppBottomBar extends StatelessWidget {
  int currentIndex;
  AppBottomBar({Key? key, required this.currentIndex}) : super(key: key);
  final List items = [
    {
      'icon': Icons.home_outlined,
      'route': RoutesGenerater.home,
      'args': null,
      'label': "Home",
    },
    {
      'icon': Icons.menu,
      'args': const MenuPageArgs(MenuType.foods),
      'route': RoutesGenerater.menu,
      'label': "Menu"
    },
    {
      'icon': Icons.percent,
      'args': const MenuPageArgs(MenuType.offers),
      'route': RoutesGenerater.menu,
      'label': "Offers"
    },
    {
      'icon': Icons.diamond_outlined,
      'args': const MenuPageArgs(MenuType.points),
      'route': RoutesGenerater.menu,
      'label': "My Points"
    },
    {
      'icon': Icons.favorite_border_outlined,
      'route': RoutesGenerater.favorites,
      'args': null,
      'label': "Favorites"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items
            .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: items.indexOf(e) != currentIndex
                            ? () => Navigator.of(context).pushReplacementNamed(
                                e['route'],
                                arguments: e['args'])
                            : null,
                        child: Icon(
                          e['icon'],
                          color: items.indexOf(e) == currentIndex
                              ? AppColors.brown4
                              : Colors.grey.shade500,
                          size: 38,
                        ),
                      ),
                      items.indexOf(e) == currentIndex
                          ? Text(
                              e['label'],
                              style: const TextStyle(
                                  color: AppColors.brown4,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ).tr()
                          : const SizedBox()
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}
