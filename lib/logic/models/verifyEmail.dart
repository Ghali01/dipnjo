class VerifyEmailState {
  bool canSend;
  int count;
  String error;
  bool loading;
  VerifyEmailState(
      {required this.canSend,
      this.error = '',
      this.loading = false,
      this.count = 60});

  VerifyEmailState cpoyWith({
    bool? canSend,
    int? count,
    String? error,
    bool? loading,
  }) =>
      VerifyEmailState(
        canSend: canSend ?? this.canSend,
        count: count ?? this.count,
        loading: loading ?? this.loading,
        error: error ?? this.error,
      );
}
