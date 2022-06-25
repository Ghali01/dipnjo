import 'package:user/logic/models/confirmAuth.dart';

class LoginPhoneState {
  bool loading;
  String error;
  bool goNext;
  int? token;
  String? vfId;
  LoginPhoneState({
    this.loading = false,
    this.error = '',
    this.goNext = false,
    this.token,
    this.vfId,
  });

  LoginPhoneState copyWith({
    bool? loading,
    String? error,
    bool? goNext,
    int? token,
    String? vfId,
  }) {
    return LoginPhoneState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      goNext: goNext ?? this.goNext,
      token: token ?? this.token,
      vfId: vfId ?? this.vfId,
    );
  }
}
