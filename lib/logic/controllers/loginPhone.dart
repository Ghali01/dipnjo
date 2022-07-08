import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:user/logic/models/confirmAuth.dart';
import 'package:user/logic/models/loginPhone.dart';
import 'package:user/logic/providers/account.dart';

class LoginPhoneCubit extends Cubit<LoginPhoneState> {
  LoginPhoneCubit() : super(LoginPhoneState());

  void login(String phone) async {
    var auth = FirebaseAuth.instance;
    emit(state.copyWith(loading: true));
    try {
      if (await AccountAPI.checkPhoneExists(phone)) {
        await auth.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (PhoneAuthCredential credential) async {
            // await auth.signInWithCredential(credential);
            // TODO: navigate to home
          },
          verificationFailed: (FirebaseAuthException e) {
            // TODO: notify user
          },
          codeSent: (String verificationId, int? resendToken) {
            emit(state.copyWith(
                goNext: true,
                loading: false,
                vfId: verificationId,
                token: resendToken));
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } else {
        emit(state.copyWith(error: tr('phone is not exists'), loading: false));
      }
    } catch (e) {
      emit(state.copyWith(error: "Process failed", loading: false));
    }
  }
}
