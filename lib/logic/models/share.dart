class ShareState {
  bool loading;
  bool loaded;
  String error;
  int? code;
  int? usersSharedCount;
  bool? shareCodeValidated;
  ShareState({
    this.loading = false,
    this.loaded = false,
    this.error = '',
    this.code,
    this.usersSharedCount,
    this.shareCodeValidated,
  });

  ShareState copyWith({
    bool? loading,
    bool? loaded,
    String? error,
    int? code,
    int? usersSharedCount,
    bool? shareCodeValidated,
  }) {
    return ShareState(
      loading: loading ?? this.loading,
      loaded: loaded ?? this.loaded,
      error: error ?? this.error,
      code: code ?? this.code,
      usersSharedCount: usersSharedCount ?? this.usersSharedCount,
      shareCodeValidated: shareCodeValidated ?? this.shareCodeValidated,
    );
  }
}
