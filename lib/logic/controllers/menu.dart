import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/logic/models/menu.dart';
import 'package:user/logic/providers/foods.dart';
import 'package:user/ui/screens/menu.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuType type;
  MenuCubit(this.type) : super(MenuState()) {
    loadCategories().then((value) => null);
  }

  Future<void> loadCategories() async {
    try {
      emit(state.copyWith(loading: true));
      String rawData = await FoodAPI.getCategories();
      List data = jsonDecode(rawData);
      data.insert(0, {"name": tr('All'), "id": -1});
      emit(state.copyWith(
        categories: data,
        loading: false,
      ));
      loadMoreFoods().then((value) => null);
    } catch (e) {
      print(e);
    }
  }

  void setCategory(int id) {
    emit(
      state.copyWith(
        currentCategory: id,
        foods: [],
        noMore: false,
        page: 1,
      ),
    );
    loadMoreFoods().then((value) => null);
  }

  Future<void> loadMoreFoods() async {
    try {
      emit(state.copyWith(loading: true));
      List r = await FoodAPI.getFoodSearch(
          type.path, state.search, state.currentCategory, state.page);
      if (r[1] == state.search && r[2] == state.currentCategory) {
        String rawData = r[0];
        List data = jsonDecode(rawData);
        List items = [...(state.foods), ...data];
        emit(
          state.copyWith(
            foods: items,
            page: state.page + 1,
            loading: false,
            noMore: data.length < 20,
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  void setTextSearch(String text) {
    if (text == state.search) return;
    emit(state.copyWith(search: text, foods: [], noMore: false, page: 1));
    loadMoreFoods().then((value) => null);
  }
}
