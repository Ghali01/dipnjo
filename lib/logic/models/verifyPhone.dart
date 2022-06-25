class VerifyPhoneState {
  bool canSend;
  int count;
  String error;
  int token;
  String vfId;
  bool verifed;
  bool loading;
  List<bool> codes;
  VerifyPhoneState(
      {this.canSend = false,
      this.verifed = false,
      this.count = 60,
      this.error = "",
      this.loading = false,
      required this.token,
      required this.vfId,
      this.codes = const [
        false,
        false,
        false,
        false,
        false,
      ]});
  VerifyPhoneState copyWith({
    bool? canSend,
    bool? verifed,
    int? count,
    String? error,
    int? token,
    String? vfId,
    bool? loading,
    List<bool>? codes,
  }) =>
      VerifyPhoneState(
          verifed: verifed ?? this.verifed,
          canSend: canSend ?? this.canSend,
          count: count ?? this.count,
          error: error ?? this.error,
          token: token ?? this.token,
          vfId: vfId ?? this.vfId,
          loading: loading ?? this.loading,
          codes: codes ?? this.codes);
}
