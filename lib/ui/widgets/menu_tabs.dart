import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/logic/controllers/menu.dart';
import 'package:user/utilities/colors.dart';

class MenuTabs extends StatelessWidget {
  final List categories;
  const MenuTabs({Key? key, required this.categories}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (_, index) => Container(
          decoration: BoxDecoration(
              border: categories[index]['id'] ==
                      context.read<MenuCubit>().state.currentCategory
                  ? const Border(
                      bottom: BorderSide(
                        color: AppColors.gold1,
                        width: 4,
                      ),
                    )
                  : null),
          child: TextButton(
            onPressed: categories[index]['id'] !=
                    context.read<MenuCubit>().state.currentCategory
                ? () => context
                    .read<MenuCubit>()
                    .setCategory(categories[index]['id'])
                : null,
            style: ButtonStyle(
                overlayColor:
                    MaterialStateProperty.all(AppColors.gold1.withOpacity(.1))),
            child: Text(
              categories[index]['name'],
              style: TextStyle(
                color: categories[index]['id'] ==
                        context.read<MenuCubit>().state.currentCategory
                    ? AppColors.gold1
                    : Colors.grey.shade500,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
