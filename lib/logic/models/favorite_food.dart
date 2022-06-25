import 'package:easy_localization/easy_localization.dart';

class FavoriteFoodsState {
  List foods;
  int page;
  bool noMore;
  bool loading;
  bool loaded;
  FavoriteFoodsState(
      {this.foods = const [],
      this.page = 1,
      this.noMore = false,
      this.loading = false,
      this.loaded = false});

  FavoriteFoodsState copyWith({
    List? foods,
    int? page,
    bool? noMore,
    bool? loading,
    bool? loaded,
  }) {
    return FavoriteFoodsState(
      foods: foods ?? this.foods,
      page: page ?? this.page,
      noMore: noMore ?? this.noMore,
      loading: loading ?? this.loading,
      loaded: loaded ?? this.loaded,
    );
  }
}
