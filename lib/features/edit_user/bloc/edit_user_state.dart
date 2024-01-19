part of 'edit_user_bloc.dart';

abstract class EditUserState {
  final User user;
  final User? initialUser;
  String? errorMessage;

  EditUserState(
      {required this.user, required this.initialUser, this.errorMessage});

  EditUserState copyWith({User? user, User? initialUser, String? errorMessage});
}

class EditUserDefaultState extends EditUserState {
  EditUserDefaultState(
      {required super.user, required super.initialUser, super.errorMessage});

  @override
  EditUserDefaultState copyWith(
      {User? user, User? initialUser, String? errorMessage}) {
    return EditUserDefaultState(
        user: user ?? this.user,
        initialUser: initialUser ?? this.initialUser,
        errorMessage: errorMessage);
  }
}

class EditUserUpdatingState extends EditUserState {
  EditUserUpdatingState(
      {required super.user, required super.initialUser, super.errorMessage});

  @override
  EditUserUpdatingState copyWith(
      {User? user, User? initialUser, String? errorMessage}) {
    return EditUserUpdatingState(
        user: user ?? this.user,
        initialUser: initialUser ?? this.initialUser,
        errorMessage: errorMessage);
  }
}

class EditUserErrorState extends EditUserState {
  EditUserErrorState(
      {required super.user, required super.initialUser, super.errorMessage});

  @override
  EditUserUpdatingState copyWith(
      {User? user, User? initialUser, String? errorMessage}) {
    return EditUserUpdatingState(
        user: user ?? this.user,
        initialUser: initialUser ?? this.initialUser,
        errorMessage: errorMessage);
  }
}
