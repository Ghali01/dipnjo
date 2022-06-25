import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/logic/models/loginEmail.dart';

class LoginEmailCubit extends Cubit<LoginEmailState> {
  LoginEmailCubit() : super(LoginEmailState());
  Future<void> login(String email, String password) async {
    try {
      emit(state.copyWith(loading: true));
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(state.copyWith(goNext: true, loading: false));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(state.copyWith(
            error: 'No user found for that email.', loading: false));
      } else if (e.code == 'wrong-password') {
        emit(state.copyWith(
            error: 'Wrong password provided for that user.', loading: false));
      }
    }
  }
}
