class HomeState {
  bool loading;
  List? ads;
  List? tops;
  List? offers;
  int? userPoints;
  String? location;
  HomeState({
    this.loading = true,
    this.ads,
    this.tops,
    this.offers,
    this.userPoints,
    this.location,
  });

  HomeState copyWith({
    bool? loading,
    List? ads,
    List? tops,
    List? offers,
    int? userPoints,
    String? location,
  }) {
    return HomeState(
      loading: loading ?? this.loading,
      ads: ads ?? this.ads,
      tops: tops ?? this.tops,
      offers: offers ?? this.offers,
      userPoints: userPoints ?? this.userPoints,
      location: location ?? this.location,
    );
  }
}
