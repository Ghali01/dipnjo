class MenuState {
  List? categories;
  int currentCategory;
  List foods;
  bool loading;
  bool categoryLoaded;
  int page;
  String search;
  bool noMore;
  MenuState(
      {this.categories,
      this.currentCategory = -1,
      this.foods = const [],
      this.loading = true,
      this.categoryLoaded = false,
      this.noMore = false,
      this.page = 1,
      this.search = ''});

  MenuState copyWith({
    List? categories,
    int? currentCategory,
    List? foods,
    bool? loading,
    bool? categoryLoaded,
    int? page,
    String? search,
    bool? noMore,
  }) {
    return MenuState(
      categories: categories ?? this.categories,
      currentCategory: currentCategory ?? this.currentCategory,
      foods: foods ?? this.foods,
      loading: loading ?? this.loading,
      categoryLoaded: categoryLoaded ?? this.categoryLoaded,
      page: page ?? this.page,
      search: search ?? this.search,
      noMore: noMore ?? this.noMore,
    );
  }
}
