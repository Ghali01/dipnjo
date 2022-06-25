class CartItemState {
  Map? food;

  List? addtions;
  int count;
  bool loading;
  bool favLoading;
  bool done;
  bool? fav;
  double? price;
  double? rPrice;
  String error;
  double? total;
  int freeItems;
  String note;

  CartItemState({
    this.food,
    this.addtions,
    this.count = 1,
    this.loading = false,
    this.favLoading = false,
    this.done = false,
    this.fav,
    this.price,
    this.rPrice,
    this.error = '',
    this.total,
    this.freeItems = 0,
    this.note = '',
  });

  CartItemState copyWith({
    Map? food,
    List? addtions,
    int? count,
    bool? loading,
    bool? favLoading,
    bool? done,
    bool? fav,
    double? price,
    double? rPrice,
    String? error,
    double? total,
    int? freeItems,
    String? note,
  }) {
    return CartItemState(
      food: food ?? this.food,
      addtions: addtions ?? this.addtions,
      count: count ?? this.count,
      loading: loading ?? this.loading,
      favLoading: favLoading ?? this.favLoading,
      done: done ?? this.done,
      fav: fav ?? this.fav,
      price: price ?? this.price,
      rPrice: rPrice ?? this.rPrice,
      error: error ?? this.error,
      total: total ?? this.total,
      freeItems: freeItems ?? this.freeItems,
      note: note ?? this.note,
    );
  }
}
