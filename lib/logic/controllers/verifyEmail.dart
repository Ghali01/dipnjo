import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/logic/models/verifyEmail.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  late Timer timer;
  VerifyEmailCubit(bool canSend) : super(VerifyEmailState(canSend: canSend)) {
    if (!canSend) {
      timeCount();
    } else {
      resent();
    }
  }
  void timeCount() {
    emit(state.cpoyWith(count: 60));
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      try {
        emit(state.cpoyWith(count: state.count - 1));

        if (state.count == 0) {
          emit(state.cpoyWith(canSend: true));
          timer.cancel();
        }
      } catch (e) {
        timer.cancel();
      }
    });
  }

  void resent() async {
    try {
      emit(state.cpoyWith(loading: true));
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      emit(state.cpoyWith(canSend: false, loading: false));
      timeCount();
    } on FirebaseAuthException catch (e) {
      print(e.code);
      emit(state.cpoyWith(error: "Process failed", loading: false));
    }
  }
}
