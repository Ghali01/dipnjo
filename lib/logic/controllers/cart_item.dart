import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/logic/models/cart_item.dart';
import 'package:user/logic/providers/foods.dart';
import 'package:user/logic/providers/order.dart';
import 'package:user/ui/screens/cart_item.dart';

class CartItemCubit extends Cubit<CartItemState> {
  int id;
  late final int userPoints;
  CartItemStatus status;
  CartItemCubit(this.id, this.status) : super(CartItemState()) {
    load().then((value) => null);
  }

  void inc() {
    if (status == CartItemStatus.free &&
        (state.freeItems + 1) * state.food!['points'] <= userPoints) {
      emit(state.copyWith(freeItems: state.freeItems + 1));
    }
    double total = (state.count + 1 - state.freeItems) * state.price!;
    emit(state.copyWith(count: state.count + 1, total: total));
  }

  void dec() {
    if (state.count > 1) {
      if (status == CartItemStatus.free &&
          state.freeItems > 0 &&
          state.count * state.food!['points'] <= userPoints) {
        emit(state.copyWith(freeItems: state.freeItems - 1));
      }
      double total = (state.count - 1 - state.freeItems) * state.price!;
      emit(state.copyWith(count: state.count - 1, total: total));
    }
  }

  void setAddtionVal(e, bool v) {
    List items = state.addtions!.toList();
    int index = items.indexOf(e);
    items[index]['value'] = v;

    emit(state.copyWith(
        addtions: items,
        total: state.total! +
            (v ? items[index]['price'] : -1 * items[index]['price'])));
  }

  Future<void> load() async {
    try {
      String rawData = await FoodAPI.getFood(id);
      var data = jsonDecode(rawData);
      var addtions = (data['additions'] ?? [])
          .map((e) => {
                'id': e['id'],
                'name': e['name'],
                'price': e['price'],
                'value': e.containsKey('value') ? e['value'] : false,
              })
          .toList();
      double price = data['price'];
      if (data['offer'] != null) {
        if (data['offer']['type'] == '1') {
          price = price - (price * data['offer']['value'] / 100);
        }
        if (data['offer']['type'] == '2') {
          price = data['offer']['value'];
        }
      }
      userPoints = data['userPoints'];
      int freeItems = 0;
      double total = price;
      if (status == CartItemStatus.free && data['points'] <= userPoints) {
        freeItems++;
        total = 0;
      }
      emit(state.copyWith(
          food: data,
          addtions: addtions,
          fav: data['fav'],
          price: price,
          freeItems: freeItems,
          rPrice: data['price'],
          total: total));
    } catch (e) {
      print(e);
    }
  }

  void addToFav() async {
    try {
      emit(state.copyWith(favLoading: true));
      await FoodAPI.addToFav(id);
      emit(state.copyWith(fav: true, favLoading: false));
    } catch (e) {}
  }

  void removeFromFav() async {
    try {
      emit(state.copyWith(favLoading: true));
      await FoodAPI.removeFromFav(id);
      emit(state.copyWith(fav: false, favLoading: false));
    } catch (e) {}
  }

  void setNote(String note) => emit(state.copyWith(note: note));
  void addToCart() async {
    try {
      emit(state.copyWith(loading: true));
      List additions = state.addtions!
          .where((element) => element['value'] == true)
          .toList()
          .map((e) => e['id'])
          .toList();
      await OrderAPI.addItemToCart(
          state.food!['id'], state.count, state.freeItems, additions);
      emit(state.copyWith(loading: false, done: true));
    } catch (e) {
      print(e);
      emit(state.copyWith(error: 'Procces Failed', loading: false));
    }
  }
}
