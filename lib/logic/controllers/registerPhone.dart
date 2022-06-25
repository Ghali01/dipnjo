import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/logic/models/registerPhone.dart';
import 'package:user/logic/models/user.dart' as um;
import 'package:user/logic/providers/account.dart';

class RegisterPhoneCubit extends Cubit<RegisterPhoneState> {
  RegisterPhoneCubit() : super(RegisterPhoneState());
  Future<void> send(um.RegisterPhoneUser user) async {
    var auth = FirebaseAuth.instance;
    emit(state.copyWith(loading: true));
    try {
      if ((await AccountAPI.checkPhoneExists(user.phone)) == false) {
        await auth.verifyPhoneNumber(
          phoneNumber: user.phone,
          verificationCompleted: (PhoneAuthCredential credential) async {
            // await auth.signInWithCredential(credential);
            // TODO: navigate to home
          },
          verificationFailed: (FirebaseAuthException e) {
            // TODO: notify user
          },
          codeSent: (String verificationId, int? resendToken) {
            emit(state.copyWith(
                sent: true,
                loading: false,
                vfId: verificationId,
                resendToken: resendToken));
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } else {
        emit(state.copyWith(error: "phone already in use", loading: false));
      }
    } catch (e) {
      print(e);
      emit(state.copyWith(error: "Process failed", loading: false));
    }
  }

  void setGender(String gender) => emit(state.copyWith(gender: gender));
}
