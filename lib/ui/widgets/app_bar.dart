import 'package:flutter/material.dart';
import 'package:user/utilities/colors.dart';

class AppAppBar extends StatelessWidget {
  final String title;
  const AppAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
            color: AppColors.brown4, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_on_outlined,
              size: 32,
            ))
      ],
      leading: Navigator.of(context).canPop()
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: AppColors.brown3,
                      borderRadius: BorderRadius.circular(100)),
                  child: const Icon(Icons.arrow_back_ios_new),
                ),
              ),
            )
          : IconButton(
              icon: const Icon(
                Icons.menu,
                color: AppColors.brown2,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
    );
  }
}
