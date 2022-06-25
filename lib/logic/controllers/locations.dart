import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/logic/models/locations.dart';
import 'package:user/logic/providers/account.dart';

class LocationsCubit extends Cubit<LocationsState> {
  LocationsCubit() : super(LocationsState()) {
    load().then((value) => null);
  }
  Future<void> load() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      int? currentId = sp.getInt('currentLocationId');
      String rawData = await AccountAPI.getLocations();
      var data = jsonDecode(rawData);
      emit(state.copyWith(currentId: currentId, locations: data));
    } catch (e) {}
  }

  void setCurrentLocation(Map location) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('currentLocationId', location['id']);
    sp.setString('currentLocationName', location['name']);
    sp.setString('currentLocationDetails', location['details']);
    sp.setDouble('currentLocationLat', double.parse(location['lat']));
    sp.setDouble('currentLocationLng', double.parse(location['lng']));

    emit(state.copyWith(currentId: location['id']));
  }

  void addLocation(Map location) {
    List items = state.locations!.toList();
    items.add(location);
    emit(state.copyWith(locations: items));
  }
}

class AddLocationCubit extends Cubit<AddLocationState> {
  AddLocationCubit() : super(AddLocationState());
  void save(String name, String address) async {
    try {
      Location location = Location();
      if ((await location.hasPermission()) == PermissionStatus.denied) {
        await location.requestPermission();
        return;
      }
      if ((await location.serviceEnabled()) == false) {
        await location.requestService();
        return;
      }
      emit(state.copyWith(loading: true));
      LocationData locationData = await location.getLocation();
      print(locationData.latitude);
      String rawData = await AccountAPI.addLocation(
          name, address, locationData.latitude!, locationData.longitude!);
      var data = jsonDecode(rawData);
      emit(state.copyWith(loading: false, data: data, done: true));
    } catch (e) {
      emit(state.copyWith(error: 'Proccess Failed'));
    }
  }
}
