class MyCartState {
  List? itmes;
  Map? location;
  double? total;
  bool loaded;
  MyCartState({
    this.itmes,
    this.location,
    this.total,
    this.loaded = false,
  });

  MyCartState copyWith({
    List? itmes,
    Map? location,
    double? total,
    bool? loaded,
  }) {
    return MyCartState(
      itmes: itmes ?? this.itmes,
      location: location ?? this.location,
      total: total ?? this.total,
      loaded: loaded ?? this.loaded,
    );
  }
}
