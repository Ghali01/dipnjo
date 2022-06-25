import 'package:user/logic/models/confirmAuth.dart';

class LoginEmailState {
  bool loading;
  String error;
  bool goNext;
  LoginEmailState({
    this.loading = false,
    this.error = '',
    this.goNext = false,
  });

  LoginEmailState copyWith({
    bool? loading,
    String? error,
    bool? goNext,
    int? token,
    String? vfId,
  }) {
    return LoginEmailState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      goNext: goNext ?? this.goNext,
    );
  }
}
