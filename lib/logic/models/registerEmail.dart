enum ConfirmMethod { email, phone }

class RegisterEmailState {
  bool sent;
  bool loading;
  String gender;
  String error;
  RegisterEmailState({
    this.sent = false,
    this.error = '',
    this.loading = false,
    this.gender = 'm',
  });

  RegisterEmailState copyWith({
    bool? sent,
    bool? loading,
    String? gender,
    String? error,
  }) {
    return RegisterEmailState(
      sent: sent ?? this.sent,
      loading: loading ?? this.loading,
      gender: gender ?? this.gender,
      error: error ?? this.error,
    );
  }
}
