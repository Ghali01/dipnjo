import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/logic/models/home.dart';
import 'package:user/logic/providers/foods.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState()) {
    load().then((value) => null);
  }

  Future<void> load() async {
    try {
      emit(state.copyWith(loading: true));
      String rawAds = await FoodAPI.getAds();
      var ads = jsonDecode(rawAds);
      String rawTops = await FoodAPI.getTopOfWeek();
      var tops = jsonDecode(rawTops);
      String rawOffers = await FoodAPI.getUserPointFood();
      var offersData = jsonDecode(rawOffers);
      emit(state.copyWith(
          ads: ads,
          offers: offersData['foods'],
          userPoints: offersData['points'],
          tops: tops,
          loading: false));
    } catch (e) {
      print(e);
    }
  }
}
