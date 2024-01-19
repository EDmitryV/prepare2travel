// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'travel_bloc.dart';

abstract class TravelEvent {}

class TravelScreenOpenedEvent extends TravelEvent {
  final Completer? completer;
  final Travel travel;

  TravelScreenOpenedEvent({this.completer, required this.travel});
}

class TravelScreenReloadTravelEvent extends TravelEvent {}

class ItemAddedEvent extends TravelEvent {
  final Item addedItem;
  final int addedItemIdx;

  ItemAddedEvent({required this.addedItemIdx, required this.addedItem});
}

class ItemChangedEvent extends TravelEvent {
  final Item newItem;
  final int idx;
  ItemChangedEvent({
    required this.newItem,
    required this.idx,
  });
}

class TravelScreenDisposedEvent extends TravelEvent {}
