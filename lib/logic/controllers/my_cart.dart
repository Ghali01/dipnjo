import 'dart:math' show cos, sqrt, asin;
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/logic/models/my_cart.dart';
import 'package:user/logic/providers/order.dart';

class MyCartCubit extends Cubit<MyCartState> {
  MyCartCubit() : super(MyCartState()) {
    load().then((value) => null);
  }

  Future<void> load() async {
    try {
      String rawData = await OrderAPI.getCartItem();
      var data = jsonDecode(rawData);
      SharedPreferences sp = await SharedPreferences.getInstance();
      Map? location = sp.containsKey('currentLocationId')
          ? {
              'name': sp.getString('currentLocationName'),
              'details': sp.getString('currentLocationDetails'),
              'lat': sp.getDouble('currentLocationLat').toString(),
              'lng': sp.getDouble('currentLocationLng').toString(),
              'dist': calculateDistance(sp.getDouble('currentLocationLat'),
                  sp.getDouble('currentLocationLng'))
            }
          : null;
      emit(state.copyWith(
        itmes: data,
        location: location,
        loaded: true,
      ));
    } catch (e) {}
  }

  void setLocation(Map location) {
    print(location['lat'].runtimeType);
    print(location['lng'].runtimeType);
    location['dist'] = calculateDistance(
        double.parse(location['lat'].toString()),
        double.parse(location['lng'].toString()));
    emit(state.copyWith(
      location: location,
    ));
  }

  String calculateDistance(lat1, lon1) {
    // 32.539136552913256, 35.87706417036341 pr.husin jordon
// 33.51168665532067, 36.296951275345315 damascus
    // 33.43347967066062, 36.255868127463536 shnaya
    var lat2 = 33.51168665532067;
    var lon2 = 36.296951275345315;
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return (12742 * asin(sqrt(a))).toStringAsFixed(1) + ' ' + tr('km');
  }
}
