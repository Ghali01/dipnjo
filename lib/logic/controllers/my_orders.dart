import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/logic/models/my_orders.dart';
import 'package:user/logic/providers/order.dart';

class MyOrdersCubit extends Cubit<MyOrdersState> {
  MyOrdersCubit() : super(MyOrdersState()) {
    load().then((value) => null);
  }
  Future<void> load() async {
    try {
      emit(state.copyWith(loading: true));
      String rawData = await OrderAPI.getOrders(state.page);
      var data = jsonDecode(rawData);
      int hsCount = data['history'].length;
      List current = [...(state.current), ...(data['current'])];
      List history = [...(state.history), ...(data['history'])];
      emit(state.copyWith(
          current: current,
          history: history,
          loaded: true,
          loading: false,
          page: state.page + 1,
          noMore: hsCount < 25));
    } catch (e) {
      print(e);
    }
  }

  void cancelOrder(int id) async {
    try {
      List current = state.current.toList();
      int index = current.indexWhere((element) => element['id'] == id);
      current[index]['loading'] = true;
      emit(state.copyWith(current: current));
      await OrderAPI.cancelOrder(id);
      current = current.toList();
      Map item = current[index];
      current.removeAt(index);
      List history = state.history.toList();
      item['status'] = 't';
      history.insert(0, item);
      emit(state.copyWith(current: current, history: history));
    } catch (e) {}
  }
}
