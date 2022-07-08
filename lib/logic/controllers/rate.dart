import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/logic/models/rate.dart';
import 'package:user/logic/providers/account.dart';

class RateCubit extends Cubit<RateState> {
  RateCubit() : super(RateState()) {
    load().then((value) => null);
  }

  Future<void> load() async {
    try {
      String rawData = await AccountAPI.getRateData();
      var data = jsonDecode(rawData);
      int count = 0;
      List dataRate = data['rateData'];

      for (int r = 1; r <= 5; r++) {
        if (dataRate.any((element) => element['rate'] == r) == false) {
          dataRate.add({'rate': r, 'count': 0});
        }
      }
      dataRate.sort(
        (a, b) => a['rate'].compareTo(b['rate']),
      );
      dataRate = dataRate.reversed.toList();
      for (Map i in data['rateData']) {
        count += i['count'] as int;
      }
      emit(state.copyWith(
        loaded: true,
        myRate: data['myRate'],
        total: count,
        rateData: dataRate,
      ));
    } catch (e) {
      print(e);
    }
  }

  void setRate(int value) async {
    emit(state.copyWith(myRate: value));
    try {
      await AccountAPI.setRate(value);
    } catch (e) {}
  }
}
