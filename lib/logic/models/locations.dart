class LocationsState {
  List? locations;
  int? currentId;
  LocationsState({
    this.locations,
    this.currentId,
  });

  LocationsState copyWith({
    List? locations,
    int? currentId,
  }) {
    return LocationsState(
      locations: locations ?? this.locations,
      currentId: currentId ?? this.currentId,
    );
  }
}

class AddLocationState {
  bool loading;
  bool done;
  String error;
  Map? data;
  AddLocationState({
    this.loading = false,
    this.done = false,
    this.error = '',
    this.data,
  });

  AddLocationState copyWith({
    bool? loading,
    bool? done,
    String? error,
    Map? data,
  }) {
    return AddLocationState(
      loading: loading ?? this.loading,
      done: done ?? this.done,
      error: error ?? this.error,
      data: data ?? this.data,
    );
  }
}
