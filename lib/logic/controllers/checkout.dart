import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/logic/models/checkout.dart';
import 'package:user/logic/providers/order.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit({
    required double totalCurrency,
    required double dist,
    required int points,
  }) : super(CheckoutState(
            totalCurrency: totalCurrency, points: points, dist: dist)) {
    load().then((value) => null);
  }

  Future<void> load() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Map userData = {
      'lat': sp.getDouble('currentLocationLat'),
      'lng': sp.getDouble('currentLocationLng'),
      'details': sp.getString('currentLocationDetails'),
      'name': sp.getString('currentLocationName'),
      'phone': sp.getString('userPhone'),
    };
    emit(state.copyWith(userData: userData, loaded: true));
  }

  void setTime(TimeOfDay time) => emit(state.copyWith(time: time));
  void clearTime() => emit(state.cleardTime());
  void setPayMethod(String payMethod) =>
      emit(state.copyWith(payMethod: payMethod));

  void validateCoupon(String key) async {
    try {
      emit(state.copyWith(promoLoading: true));
      String rawData = await OrderAPI.validateCoupon(key);
      var data = jsonDecode(rawData);
      late double totalCurrency;
      late String discount;
      if (data['type'] == 'p') {
        totalCurrency =
            state.totalCurrency - (state.totalCurrency * data['value'] / 100);
        discount = '${data['value']}%';
      } else if (data['type'] == 'c') {
        totalCurrency = state.totalCurrency - data['value'];
        discount = tr('amount', args: [data['value'].toString()]);

        if (totalCurrency < 0) {
          totalCurrency = 0;
        }
      }
      emit(state.copyWith(
          totalCurrency: totalCurrency,
          promoCode: key,
          promoDiscount: discount,
          promoLoading: false));
    } on CouponEx catch (e) {
      if (e.type == CouponExType.used) {
        emit(state.copyWith(couponError: tr('codeUsed'), promoLoading: false));
      } else if (e.type == CouponExType.notFound) {
        emit(state.copyWith(
            couponError: tr('codeInvalid'), promoLoading: false));
      }
    } catch (e) {}
  }

  void clearCouponError() => emit(state.copyWith(couponError: ''));

  void sendOrder() async {
    try {
      emit(state.copyWith(loading: true));
      SharedPreferences sp = await SharedPreferences.getInstance();
      String? time = state.time != null
          ? '${state.time!.hour}:${state.time!.minute}'
          : null;
      await OrderAPI.sendOrded(time, state.promoCode, state.payMethod,
          sp.getInt('currentLocationId')!);
      emit(state.copyWith(loading: false, done: true));
    } catch (e) {
      emit(state.copyWith(error: "Process Fialed", loading: false));
    }
  }
}
