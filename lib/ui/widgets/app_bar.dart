import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:user/utilities/colors.dart';
import 'package:user/utilities/routes.dart';

class AppAppBar extends StatelessWidget {
  final String title;
  final bool inNotificiation;
  const AppAppBar({Key? key, required this.title, this.inNotificiation = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
            color: AppColors.brown4, fontWeight: FontWeight.bold),
      ).tr(),
      centerTitle: true,
      actions: [
        !inNotificiation
            ? IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(RoutesGenerater.notifications);
                },
                icon: const Icon(
                  Icons.notifications_on_outlined,
                  size: 32,
                ))
            : const SizedBox()
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
                  child: Icon(context.locale.languageCode == 'en'
                      ? Icons.arrow_back_ios_new
                      : Icons.arrow_back),
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
