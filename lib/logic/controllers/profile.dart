import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/logic/models/profile.dart';
import 'package:user/logic/providers/account.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState()) {
    load().then((value) => null);
  }

  Future<void> load() async {
    try {
      String rawData = await AccountAPI.getProfile();
      var data = jsonDecode(rawData);
      emit(state.copyWith(data: data));
    } catch (e) {
      print(e);
    }
  }

  void startEdit() => emit(state.copyWith(editing: true));
  void save(String phone) async {
    state.data!['phone'] = phone;
    emit(state.copyWith(loading: true));
    try {
      await AccountAPI.setPhone(phone);
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('userPhone', phone);
      emit(state.copyWith(editing: false, loading: false));
    } catch (e) {}
  }
}
