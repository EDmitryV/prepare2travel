import 'dart:async';
import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prepare2travel/core/error/failures.dart';
import 'package:prepare2travel/core/strings/failures.dart';
import 'package:prepare2travel/data/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository authRepo;

  Completer<void> completer = Completer<void>();

  AuthBloc({required this.authRepo}) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is CheckLoggingInEvent) {
        final theFirstPage = authRepo.firstPage();

        if (theFirstPage.isLoggedIn) {
          emit(SignedInPageState());
        } else if (theFirstPage.isVerifyingEmail) {
          emit(VerifyEmailPageState());
        }
      } else if (event is SignInEvent) {
        emit(LoadingState());

        final failureOrUserCredential =
            await authRepo.signIn(email: event.email, password: event.password);

        emit(eitherToState(failureOrUserCredential, SignedInState()));
      } else if (event is SignUpEvent) {
        emit(LoadingState());

        final failureOrUserCredential = await authRepo.signUp(
            name: event.name,
            email: event.email,
            password: event.password,
            repeatedPassword: event.repeatedPassword);

        emit(eitherToState(failureOrUserCredential, SignedUpState()));
      } else if (event is SendEmailVerificationEvent) {
        final failureOrSentEmail = await authRepo.verifyEmail();

        emit(eitherToState(failureOrSentEmail, EmailIsSentState()));
      } else if (event is CheckEmailVerificationEvent) {
        if (!completer.isCompleted) {
          completer.complete();

          completer = Completer<void>();
        }

        final failureOrEmailVerified =
            await authRepo.checkEmailVerification(completer);

        emit(eitherToState(failureOrEmailVerified, EmailIsVerifiedState()));
      } else if (event is LogOutEvent) {
        final failureOrLogOut = await authRepo.logOut();

        emit(eitherToState(failureOrLogOut, LoggedOutState()));
      } else if (event is SignInWithGoogleEvent) {
        emit(LoadingState());

        final failureOrUserCredential = await authRepo.googleSignIn();

        emit(eitherToState(failureOrUserCredential, GoogleSignInState()));
      }
    });
  }

  AuthState eitherToState(Either either, AuthState state) {
    return either.fold(
      (failure) => ErrorAuthState(message: _mapFailureToMessage(failure)),
      (_) => state,
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return SERVER_FAILURE_MESSAGE;

      case OfflineFailure _:
        return OFFLINE_FAILURE_MESSAGE;

      case WeekPassFailure _:
        return WEEK_PASS_FAILURE_MESSAGE;

      case ExistedAccountFailure _:
        return EXISTED_ACCOUNT_FAILURE_MESSAGE;

      case NoUserFailure _:
        return NO_USER_FAILURE_MESSAGE;

      case TooManyRequestsFailure _:
        return TOO_MANY_REQUESTS_FAILURE_MESSAGE;

      case WrongPasswordFailure _:
        return WRONG_PASSWORD_FAILURE_MESSAGE;

      case UnmatchedPassFailure _:
        return UNMATCHED_PASSWORD_FAILURE_MESSAGE;

      case NotLoggedInFailure _:
        return '';

      default:
        return "Unexpected Error, Please try again later.";
    }
  }
}
