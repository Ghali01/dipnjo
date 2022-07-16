import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/logic/models/registerEmail.dart';
import 'package:user/logic/models/user.dart' as um;
import 'package:user/logic/providers/account.dart';

class RegisterEmailCubit extends Cubit<RegisterEmailState> {
  RegisterEmailCubit() : super(RegisterEmailState());
  Future<void> send(um.RegisterEmailUser user) async {
    try {
      emit(state.copyWith(loading: true));
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: user.email, password: user.password!);
      await AccountAPI.post(
          token: FirebaseAuth.instance.currentUser!.uid,
          name: user.name,
          gender: user.gender,
          birth: user.birth,
          email: user.email);
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        AccountAPI.SetFCMToken(fcmToken);
      }
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setBool('logedin', true);
      sp.setInt('authMethod', 1);
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      print('sent');
      emit(state.copyWith(sent: true, loading: false));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        emit(state.copyWith(error: "email already in use", loading: false));
        print(e.code);
      } else {
        emit(state.copyWith(error: "Process failed", loading: false));
      }
    } catch (e) {
      print(e);
      emit(state.copyWith(error: "Process failed", loading: false));
    }
  }

  void setGender(String gender) => emit(state.copyWith(gender: gender));
}
