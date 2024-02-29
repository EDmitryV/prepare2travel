part of 'auth_bloc.dart';


abstract class AuthEvent extends Equatable {

  @override

  List<Object> get props => [];

}


class CheckLoggingInEvent extends AuthEvent {}


class CheckEmailVerificationEvent extends AuthEvent {}


class SendEmailVerificationEvent extends AuthEvent {}


class SignInWithGoogleEvent extends AuthEvent {}


class LogOutEvent extends AuthEvent {}


class SignInEvent extends AuthEvent {

  final String email;


  final String password;


  SignInEvent({required this.email, required this.password});


  @override

  List<Object> get props => [email, password];

}


class SignUpEvent extends AuthEvent {

  final String name;


  final String email;


  final String password;


  final String repeatedPassword;


  SignUpEvent(

      {required this.name,

      required this.password,

      required this.email,

      required this.repeatedPassword});


  @override

  List<Object> get props => [name, password, email, repeatedPassword];

}

