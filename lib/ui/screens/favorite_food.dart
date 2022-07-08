import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/logic/controllers/favorite_food.dart';
import 'package:user/logic/models/favorite_food.dart';
import 'package:user/ui/widgets/app_bar.dart';
import 'package:user/ui/widgets/bottom_nav.dart';
import 'package:user/ui/widgets/drawer.dart';
import 'package:user/ui/widgets/food_item.dart';

class FavoriteFoodsPage extends StatelessWidget {
  const FavoriteFoodsPage({Key? key}) : super(key: key);

  ScrollController genScrollController(FavoriteFoodsCubit cubit) {
    ScrollController controller = ScrollController();
    controller.addListener(() {
      if (!cubit.state.noMore &&
          !cubit.state.loading &&
          controller.offset >= controller.position.maxScrollExtent &&
          !controller.position.outOfRange) {
        cubit.load().then((value) => null);
      }
    });
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 56),
          child: AppAppBar(title: tr('Favorites'))),
      drawer: AppDrawer(),
      body: BlocProvider(
        create: (context) => FavoriteFoodsCubit(),
        child: BlocBuilder<FavoriteFoodsCubit, FavoriteFoodsState>(
          builder: (context, state) {
            if (!state.loaded) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.foods.isEmpty) {
              return Center(child: const Text("No Favorites").tr());
            }
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GridView.builder(
                      controller: genScrollController(
                          context.read<FavoriteFoodsCubit>()),
                      itemCount: state.foods.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width >= 600 ? 3 : 2,
                        childAspectRatio:
                            MediaQuery.of(context).size.width >= 600
                                ? 0.55
                                : 0.50,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (_, index) =>
                          FoodItem(food: state.foods[index]),
                    ),
                  ),
                  state.loading
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox()
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: AppBottomBar(currentIndex: 4),
    );
  }
}
