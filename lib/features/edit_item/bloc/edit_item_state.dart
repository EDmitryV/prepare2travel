part of 'edit_item_bloc.dart';

abstract class EditItemState {
  final String name;
  final int have;
  final int needed;
  final String nameErrorMessage;
  final String haveErrorMessage;
  final String neededErrorMessage;
  final String errorMessage;

  EditItemState(
      {required this.name,
      required this.have,
      required this.needed,
      required this.errorMessage,
      required this.nameErrorMessage,
      required this.haveErrorMessage,
      required this.neededErrorMessage});

  EditItemState copyWith(
      {String? nameErrorMessage,
      String? neededErrorMessage,
      String? haveErrorMessage,
      String? name,
      int? have,
      int? needed,
      String? errorMessage});
}

class EditItemLoadedState extends EditItemState {
  EditItemLoadedState({
    required super.errorMessage,
    required super.nameErrorMessage,
    required super.haveErrorMessage,
    required super.neededErrorMessage,
    required super.needed,
    required super.have,
    required super.name,
  });

  @override
  EditItemLoadedState copyWith(
      {String? nameErrorMessage,
      String? neededErrorMessage,
      String? haveErrorMessage,
      String? name,
      int? have,
      int? needed,
      String? errorMessage}) {
    return EditItemLoadedState(
        nameErrorMessage: nameErrorMessage ?? this.nameErrorMessage,
        haveErrorMessage: haveErrorMessage ?? this.haveErrorMessage,
        neededErrorMessage: neededErrorMessage ?? this.neededErrorMessage,
        have: have ?? this.have,
        needed: needed ?? this.needed,
        name: name ?? this.name,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}

class EditItemUpdatingState extends EditItemState {
  EditItemUpdatingState({
    required super.errorMessage,
    required super.nameErrorMessage,
    required super.haveErrorMessage,
    required super.neededErrorMessage,
    required super.needed,
    required super.have,
    required super.name,
  });

  @override
  EditItemUpdatingState copyWith(
      {String? nameErrorMessage,
      String? haveErrorMessage,
      String? neededErrorMessage,
      int? have,
      int? needed,
      String? name,
      String? errorMessage}) {
    return EditItemUpdatingState(
        nameErrorMessage: nameErrorMessage ?? this.nameErrorMessage,
        have: have ?? this.have,
        needed: needed ?? this.needed,
        neededErrorMessage: neededErrorMessage ?? this.neededErrorMessage,
        name: name ?? this.name,
        haveErrorMessage: haveErrorMessage ?? this.haveErrorMessage,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}
