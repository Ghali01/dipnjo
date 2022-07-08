class RateState {
  bool loaded;
  List? rateData;
  int? myRate;
  int? total;
  RateState({
    this.loaded = false,
    this.rateData,
    this.myRate,
    this.total,
  });

  RateState copyWith({
    bool? loaded,
    List? rateData,
    int? myRate,
    int? total,
  }) {
    return RateState(
      loaded: loaded ?? this.loaded,
      rateData: rateData ?? this.rateData,
      myRate: myRate ?? this.myRate,
      total: total ?? this.total,
    );
  }
}
