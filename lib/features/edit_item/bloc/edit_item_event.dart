part of 'edit_item_bloc.dart';

abstract class EditItemEvent {}

class EditItemScreenOpenedEvent extends EditItemEvent {
  EditItemScreenOpenedEvent({required this.initialItem, required this.travel});
  Item? initialItem;
  Travel travel;
}

class EditItemScreenDisposedEvent extends EditItemEvent {}

class ValidateNameEvent extends EditItemEvent {
  final String name;

  ValidateNameEvent({required this.name});
}

class ValidateHaveEvent extends EditItemEvent {
  final String have;

  ValidateHaveEvent({required this.have});
}

class ValidateNeededEvent extends EditItemEvent {
  final String needed;

  ValidateNeededEvent({required this.needed});
}

class CreateOrSaveEvent extends EditItemEvent {
  CreateOrSaveEvent({required this.completer});
  Completer completer;
}

class DeleteItemEvent extends EditItemEvent {
  DeleteItemEvent({required this.completer});
  Completer completer;
}
