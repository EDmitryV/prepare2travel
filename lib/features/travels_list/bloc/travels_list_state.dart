part of 'travels_list_bloc.dart';

abstract class TravelsListState {
  final LocalUserData? user;
  final List<Travel> travelsList;

  TravelsListState({required this.user, required this.travelsList});

  TravelsListState copyWith({LocalUserData? user});
}

class TravelsListInitState extends TravelsListState {
  TravelsListInitState({required super.user, required super.travelsList});

  @override
  TravelsListInitState copyWith(
      {LocalUserData? user, List<Travel>? travelsList}) {
    return TravelsListInitState(
        user: user ?? this.user, travelsList: travelsList ?? this.travelsList);
  }
}

class TravelsListLoadingState extends TravelsListState {
  TravelsListLoadingState({required super.user, required super.travelsList});

  @override
  TravelsListInitState copyWith(
      {LocalUserData? user, List<Travel>? travelsList}) {
    return TravelsListInitState(
        user: user ?? this.user, travelsList: travelsList ?? this.travelsList);
  }
}

class TravelsListLoadedState extends TravelsListState {
  TravelsListLoadedState({
    required super.travelsList,
    required super.user,
  });

  @override
  TravelsListInitState copyWith(
      {LocalUserData? user, List<Travel>? travelsList}) {
    return TravelsListInitState(
        user: user ?? this.user, travelsList: travelsList ?? this.travelsList);
  }
}

class TravelsListErrorState extends TravelsListState {
  TravelsListErrorState({required super.user, required super.travelsList});

  @override
  TravelsListInitState copyWith(
      {LocalUserData? user, List<Travel>? travelsList}) {
    return TravelsListInitState(
        user: user ?? this.user, travelsList: travelsList ?? this.travelsList);
  }
}
