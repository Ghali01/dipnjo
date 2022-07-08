class ProfileState {
  Map? data;
  bool editing;
  bool loading;
  ProfileState({
    this.data,
    this.editing = false,
    this.loading = false,
  });

  ProfileState copyWith({
    Map? data,
    bool? editing,
    bool? loading,
  }) {
    return ProfileState(
      data: data ?? this.data,
      editing: editing ?? this.editing,
      loading: loading ?? this.loading,
    );
  }
}
