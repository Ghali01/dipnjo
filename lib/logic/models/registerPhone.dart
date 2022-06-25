enum ConfirmMethod { email, phone }

class RegisterPhoneState {
  bool sent;
  bool loading;
  String error;
  ConfirmMethod method;
  int? resendToken;
  String? vfId;
  String gender;
  RegisterPhoneState(
      {this.sent = false,
      this.method = ConfirmMethod.phone,
      this.resendToken,
      this.vfId,
      this.gender = 'm',
      this.error = '',
      this.loading = false});

  RegisterPhoneState copyWith(
          {bool? sent,
          ConfirmMethod? method,
          int? resendToken,
          String? vfId,
          String? error,
          String? gender,
          bool? loading}) =>
      RegisterPhoneState(
        sent: sent ?? this.sent,
        method: method ?? this.method,
        resendToken: resendToken ?? this.resendToken,
        vfId: vfId ?? this.vfId,
        error: error ?? this.error,
        gender: gender ?? this.gender,
        loading: loading ?? this.loading,
      );
}
