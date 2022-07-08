class MyOrdersState {
  bool loaded;
  bool loading;
  List history;
  List current;
  int page;
  bool noMore;
  MyOrdersState({
    this.loaded = false,
    this.loading = false,
    this.noMore = false,
    this.history = const [],
    this.current = const [],
    this.page = 1,
  });

  MyOrdersState copyWith({
    bool? loaded,
    bool? loading,
    List? history,
    List? current,
    int? page,
    bool? noMore,
  }) {
    return MyOrdersState(
      loaded: loaded ?? this.loaded,
      loading: loading ?? this.loading,
      history: history ?? this.history,
      current: current ?? this.current,
      page: page ?? this.page,
      noMore: noMore ?? this.noMore,
    );
  }
}
