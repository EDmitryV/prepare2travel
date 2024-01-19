part of 'edit_user_bloc.dart';

abstract class EditUserEvent {}

class EditUserScreenOpenedEvent extends EditUserEvent {
  EditUserScreenOpenedEvent({required this.initialUser});
  User? initialUser;
}

class EditUserScreenDisposedEvent extends EditUserEvent {}

class UpdateSexEvent extends EditUserEvent {
  UpdateSexEvent({required this.sex});
  final UserSex sex;
}

class CreateOrUpdateEvent extends EditUserEvent {
  CreateOrUpdateEvent({required this.completer});
  Completer completer;
}

class EndErrorMessageNotificationEvent extends EditUserEvent {}
