part of 'travel_bloc.dart';

abstract class TravelState {
  final Travel travel;
  TravelState({required this.travel});
  TravelState copyWith({Travel? travel});
}

class TravelInitState extends TravelState {
  TravelInitState({required super.travel});
  @override
  TravelInitState copyWith({Travel? travel}) {
    return TravelInitState(
      travel: travel ?? this.travel,
    );
  }
}

class TravelLoadingState extends TravelState {
  TravelLoadingState({required super.travel});
  @override
  TravelLoadingState copyWith({Travel? travel}) {
    return TravelLoadingState(
        travel: travel ?? this.travel);
  }
}

class TravelLoadedState extends TravelState {
  TravelLoadedState({required super.travel});
  @override
  TravelLoadedState copyWith({Travel? travel}) {
    return TravelLoadedState(travel: travel ?? this.travel);
  }
}

class TravelErrorState extends TravelState {
  TravelErrorState({required super.travel});
  @override
  TravelErrorState copyWith({Travel? travel}) {
    return TravelErrorState(travel: travel ?? this.travel);
  }
}
