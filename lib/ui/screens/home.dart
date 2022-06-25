import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/logic/controllers/home.dart';
import 'package:user/logic/models/home.dart';
import 'package:user/ui/widgets/app_bar.dart';
import 'package:user/ui/widgets/bottom_nav.dart';
import 'package:user/ui/widgets/drawer.dart';
import 'package:user/ui/widgets/food_item.dart';
import 'package:user/ui/widgets/offeer_points_item.dart';
import 'package:user/utilities/colors.dart';
import 'package:user/utilities/server.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size(double.infinity, 56),
          child: AppAppBar(title: 'Home'),
        ),
        drawer: AppDrawer(),
        // d
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Delivering To',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ).tr(),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.brown1,
                        size: 32,
                      ),
                      Text(
                        'Dahiet-Alrasheed ...',
                        style: const TextStyle(
                            fontSize: 20,
                            color: AppColors.brown1,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CarouselSlider(
                      items: state.ads!
                          .map((e) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e['title'],
                                            style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            e['subTitle'],
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: AppColors.brown3,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox.square(
                                        dimension: 140,
                                        child: Image.network(
                                          Server.getAbsluteUrl(
                                            e['imageUrl'],
                                          ),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ))
                          .toList(),
                      options: CarouselOptions(
                          aspectRatio: 1.3,
                          autoPlay: true,
                          disableCenter: true,
                          viewportFraction: 1),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Tops Of Week',
                    style: TextStyle(
                      color: AppColors.brown4,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ).tr(),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                        itemCount: state.tops!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) => Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(end: 16),
                              child: SizedBox(
                                  width: 200,
                                  child: FoodItem(food: state.tops![index])),
                            )),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'My Point Offers',
                    style: TextStyle(
                      color: AppColors.brown4,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ).tr(args: [state.userPoints.toString()]),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      itemCount: state.offers!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index) => Padding(
                          padding: const EdgeInsetsDirectional.only(end: 16),
                          child: OfferPointsItem(food: state.offers![index])),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: AppBottomBar(
          currentIndex: 0,
        ),
      ),
    );
  }
}
