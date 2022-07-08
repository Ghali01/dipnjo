import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/logic/models/loginEmail.dart';
import 'package:user/logic/providers/account.dart';

class LoginEmailCubit extends Cubit<LoginEmailState> {
  LoginEmailCubit() : super(LoginEmailState());
  Future<void> login(String email, String password) async {
    try {
      emit(state.copyWith(loading: true));
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      SharedPreferences sp = await SharedPreferences.getInstance();
      String rawData = await AccountAPI.login();
      var data = jsonDecode(rawData);
      if (data['phone'] != null) {
        sp.setString('userPhone', data['phone']);
      }
      if (data['location'] != null) {
        sp.setInt('currentLocationId', data['location']['id']);
        sp.setString('currentLocationName', data['location']['name']);
        sp.setString('currentLocationDetails', data['location']['details']);
        sp.setDouble(
            'currentLocationLat', double.parse(data['location']['lat']));
        sp.setDouble(
            'currentLocationLng', double.parse(data['location']['lng']));
      }
      emit(state.copyWith(goNext: true, loading: false));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(state.copyWith(
            error: 'No user found for that email.', loading: false));
      } else if (e.code == 'wrong-password') {
        emit(state.copyWith(
            error: 'Wrong password provided for that user.', loading: false));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Process failed.', loading: false));
    }
  }
}
