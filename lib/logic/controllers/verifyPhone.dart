import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/logic/models/verifyPhone.dart';
import 'package:user/logic/models/user.dart' as um;
import 'package:user/logic/providers/account.dart';
import 'package:user/ui/screens/auth/verifyPhone.dart';

class VerifyPhoneCubit extends Cubit<VerifyPhoneState> {
  late Timer timer;
  VerifyPhoneCubit(int token, String vfId)
      : super(VerifyPhoneState(token: token, vfId: vfId)) {
    timeCount();
  }

  void timeCount() {
    emit(state.copyWith(count: 60));
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      try {
        emit(state.copyWith(count: state.count - 1));

        if (state.count == 0) {
          emit(state.copyWith(canSend: true));
          timer.cancel();
        }
      } catch (e) {
        timer.cancel();
      }
    });
  }

  void verify(String code, VerifyPhoneFlag flag,
      [um.RegisterPhoneUser? user]) async {
    if (!state.codes.every((element) => element == true)) {
      emit(state.copyWith(error: tr("eneter 6-digets code")));
      return;
    }
    try {
      emit(state.copyWith(loading: true));
      var cred = await PhoneAuthProvider.credential(
          verificationId: state.vfId, smsCode: code);
      await FirebaseAuth.instance.signInWithCredential(cred);
      SharedPreferences sp = await SharedPreferences.getInstance();
      if (flag == VerifyPhoneFlag.register) {
        await AccountAPI.post(
            token: FirebaseAuth.instance.currentUser!.uid,
            name: user!.name,
            gender: user.gender,
            birth: user.birth,
            phone: user.phone);
        sp.setString('userPhone', user.phone);
      } else {
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
      }
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        AccountAPI.SetFCMToken(fcmToken);
      }
      sp.setBool('logedin', true);
      sp.setInt('authMethod', 2);
      emit(state.copyWith(verifed: true, loading: false));
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'invalid-verification-code') {
        emit(state.copyWith(error: 'Invalid code', loading: false));
      } else {
        emit(state.copyWith(error: 'Process failed', loading: false));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Process failed', loading: false));
    }
  }

  void resend(String phone) async {
    var auth = FirebaseAuth.instance;
    try {
      emit(state.copyWith(loading: true));
      await auth.verifyPhoneNumber(
        phoneNumber: phone,
        forceResendingToken: state.token,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // await auth.signInWithCredential(credential);
          // TODO: navigate to home
        },
        verificationFailed: (FirebaseAuthException e) {
          // TODO: notify user
        },
        codeSent: (String verificationId, int? resendToken) {
          print('resent');
          emit(state.copyWith(
              vfId: verificationId,
              loading: false,
              token: resendToken,
              canSend: false));
          timeCount();
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      emit(state.copyWith(error: 'Process failed', loading: false));
    }
  }

  void setNCStatus(int index) {
    var items = state.codes.toList();
    items[index] = true;
    emit(state.copyWith(codes: items));
  }
}
