part of 'travels_list_bloc.dart';

abstract class TravelsListEvent {}

class TravelListScreenOpenedEvent extends TravelsListEvent {
  final Completer? completer;

  TravelListScreenOpenedEvent({required this.completer});
}

class LoadTravelsListEvent extends TravelsListEvent {
  final Completer? completer;
  final User? user;

  LoadTravelsListEvent({this.completer, this.user});
}

class TravelDeletedEvent extends TravelsListEvent {
  final int travelIdx;
  final Travel travelToDelete;

  TravelDeletedEvent({required this.travelIdx, required this.travelToDelete});
}

class TravelListScreenDisposedEvent extends TravelsListEvent {}

class UpdateUserEvent extends TravelsListEvent {}
