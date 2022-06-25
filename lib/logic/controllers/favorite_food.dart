import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/logic/models/favorite_food.dart';
import 'package:user/logic/providers/foods.dart';

class FavoriteFoodsCubit extends Cubit<FavoriteFoodsState> {
  FavoriteFoodsCubit() : super(FavoriteFoodsState()) {
    load().then((value) => null);
  }
  Future<void> load() async {
    try {
      emit(state.copyWith(loading: true));
      String rawData = await FoodAPI.getUserFavoritsFood(state.page);
      List data = jsonDecode(rawData);
      List foods = [...(state.foods), ...data];
      emit(
        state.copyWith(
            foods: data,
            page: state.page + 1,
            noMore: data.length < 20,
            loading: false,
            loaded: true),
      );
    } catch (e) {
      print(e);
    }
  }
}
