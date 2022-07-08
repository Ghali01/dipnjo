import 'package:flutter/material.dart';

class CheckoutState {
  Map? userData;
  bool loaded;
  bool loading;
  bool done;
  TimeOfDay? time;
  String? promoCode;
  String error;
  String payMethod;
  double totalCurrency;
  double dist;
  String couponError;
  bool promoLoading;
  int points;
  String? promoDiscount;
  late double deliveryFee;

  CheckoutState({
    this.userData,
    this.loaded = false,
    this.loading = false,
    this.done = false,
    this.time,
    this.error = '',
    this.promoLoading = false,
    this.promoCode,
    this.couponError = '',
    this.payMethod = 'ca',
    required this.totalCurrency,
    required this.dist,
    this.promoDiscount,
    required this.points,
  }) {
    deliveryFee = (dist * 1).toInt().toDouble();
  }

  CheckoutState copyWith({
    Map? userData,
    bool? loaded,
    bool? loading,
    bool? done,
    TimeOfDay? time,
    String? promoCode,
    String? payMethod,
    double? totalCurrency,
    double? dist,
    String? error,
    int? points,
    String? promoDiscount,
    String? couponError,
    bool? promoLoading,
  }) {
    return CheckoutState(
        userData: userData ?? this.userData,
        loaded: loaded ?? this.loaded,
        loading: loading ?? this.loading,
        done: done ?? this.done,
        time: time ?? this.time,
        error: error ?? this.error,
        promoCode: promoCode ?? this.promoCode,
        promoDiscount: promoDiscount ?? this.promoDiscount,
        promoLoading: promoLoading ?? this.promoLoading,
        payMethod: payMethod ?? this.payMethod,
        totalCurrency: totalCurrency ?? this.totalCurrency,
        dist: dist ?? this.dist,
        points: points ?? this.points,
        couponError: couponError ?? this.couponError);
  }

  CheckoutState cleardTime() {
    return CheckoutState(
      userData: userData,
      loaded: loaded,
      loading: loading,
      promoCode: promoCode,
      payMethod: payMethod,
      done: done,
      error: error,
      totalCurrency: totalCurrency,
      promoDiscount: promoDiscount,
      points: points,
      dist: dist,
      promoLoading: promoLoading,
      couponError: couponError,
      time: null,
    );
  }

  double get total => totalCurrency + deliveryFee;
}
