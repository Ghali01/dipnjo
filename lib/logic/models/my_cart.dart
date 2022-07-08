class MyCartState {
  List? itmes;
  Map? location;
  double? totalCurrency;
  int? totalPoints;
  bool loaded;
  bool clearLoading;
  MyCartState(
      {this.itmes,
      this.location,
      this.totalCurrency,
      this.totalPoints,
      this.loaded = false,
      this.clearLoading = false});

  MyCartState copyWith({
    List? itmes,
    Map? location,
    double? totalCurrency,
    int? totalPoints,
    bool? loaded,
    bool? clearLoading,
  }) {
    return MyCartState(
      itmes: itmes ?? this.itmes,
      location: location ?? this.location,
      totalCurrency: totalCurrency ?? this.totalCurrency,
      totalPoints: totalPoints ?? this.totalPoints,
      loaded: loaded ?? this.loaded,
      clearLoading: clearLoading ?? this.clearLoading,
    );
  }
}
