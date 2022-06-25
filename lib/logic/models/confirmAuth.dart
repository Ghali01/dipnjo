enum ConfirmMethod { email, phone }

class ConfirmState {
  bool sent;
  bool loading;
  String error;
  ConfirmMethod method;
  int? resendToken;
  String? vfId;
  ConfirmState(
      {this.sent = false,
      this.method = ConfirmMethod.phone,
      this.resendToken,
      this.vfId,
      this.error = '',
      this.loading = false});

  ConfirmState copyWith(
          {bool? sent,
          ConfirmMethod? method,
          int? resendToken,
          String? vfId,
          String? error,
          bool? loading}) =>
      ConfirmState(
        sent: sent ?? this.sent,
        method: method ?? this.method,
        resendToken: resendToken ?? this.resendToken,
        vfId: vfId ?? this.vfId,
        error: error ?? this.error,
        loading: loading ?? this.loading,
      );
}
