import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/logic/controllers/menu.dart';
import 'package:user/logic/models/menu.dart';
import 'package:user/ui/widgets/app_bar.dart';
import 'package:user/ui/widgets/bottom_nav.dart';
import 'package:user/ui/widgets/drawer.dart';
import 'package:user/ui/widgets/food_item.dart';
import 'package:user/ui/widgets/menu_tabs.dart';
import 'package:user/ui/widgets/offeer_points_item.dart';
import 'package:user/ui/widgets/offer_pointa_item2.dart';
import 'package:user/utilities/colors.dart';

enum MenuType {
  foods('foods/search-food', 1),
  offers('foods/search-food/offers', 2),
  points('foods/search-food/points', 3);

  const MenuType(this.path, this.navIndex);
  final String path;
  final int navIndex;
}

class MenuPageArgs {
  final MenuType type;
  const MenuPageArgs(this.type);
}

class MenuPage extends StatelessWidget {
  final MenuPageArgs args;
  const MenuPage({Key? key, required this.args}) : super(key: key);
  ScrollController genScrollController(MenuCubit cubit) {
    ScrollController controller = ScrollController();
    controller.addListener(() {
      if (!cubit.state.noMore &&
          !cubit.state.loading &&
          controller.offset >= controller.position.maxScrollExtent &&
          !controller.position.outOfRange) {
        print('5');
        cubit.loadMoreFoods().then((value) => null);
      }
    });
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuCubit(args.type),
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size(double.infinity, 56),
          child: AppAppBar(title: 'Menu'),
        ),
        drawer: AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              Text(
                'Our Sweets',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
              ).tr(),
              const Text(
                'Special For You',
                style: TextStyle(
                    color: AppColors.brown4,
                    fontSize: 19,
                    fontWeight: FontWeight.w600),
              ).tr(),
              const SizedBox(
                height: 16,
              ),
              Builder(
                  builder: (context) => TextField(
                        onChanged: (v) =>
                            context.read<MenuCubit>().setTextSearch(v),
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintText: tr('Search Sweets ?'),
                          hintStyle: TextStyle(
                              color: Colors.grey.shade500, fontSize: 17),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade500,
                            size: 32,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      )),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: BlocBuilder<MenuCubit, MenuState>(
                  builder: (context, state) {
                    if (state.categories == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MenuTabs(categories: state.categories!),
                        const SizedBox(
                          height: 8,
                        ),
                        Expanded(
                          child: GridView.builder(
                            controller:
                                genScrollController(context.read<MenuCubit>()),
                            itemCount: state.foods.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: .55,
                                    crossAxisSpacing: 10),
                            itemBuilder: (_, index) =>
                                args.type == MenuType.points
                                    ? OfferPointsItem2(food: state.foods[index])
                                    : FoodItem(food: state.foods[index]),
                          ),
                        ),
                        state.loading
                            ? const Center(child: CircularProgressIndicator())
                            : const SizedBox()
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: AppBottomBar(
          currentIndex: args.type.navIndex,
        ),
      ),
    );
  }
}
