import 'dart:async';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prepare2travel/core/util/utils.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:prepare2travel/core/error/failures.dart';
import 'package:prepare2travel/data/models/first_page_model.dart';

class AuthenticationRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Utils _utils = GetIt.I<Utils>();

  Future<Either<Failure, UserCredential>> signIn(
      {required String email, required String password}) async {
    if (await _utils.networkConnected()) {
      try {
        await _auth.currentUser?.reload();
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        await _auth.signInWithCredential(userCredential.credential!);
        return Right(userCredential);
      } on FirebaseAuthException catch (e, st) {
        GetIt.I<Talker>().error(e, st);
        if (e.code == 'user-not-found') {
          return Left(ExistedAccountFailure());
        } else if (e.code == 'wrong-password') {
          return Left(WrongPasswordFailure());
        } else {
          return Left(ServerFailure());
        }
      } catch (e, st) {
        GetIt.I<Talker>().error(e, st);
        return Left(UnexpectedFailure());
      }
    } else {
      GetIt.I<Talker>().log("Can't sign in cause device is offline");
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, UserCredential>> signUp(
      {required String name,
      required String email,
      required String password,
      required String repeatedPassword}) async {
    if (!await _utils.networkConnected()) {
      GetIt.I<Talker>().log("Can't sign up cause device is offline");
      return Left(OfflineFailure());
    } else if (password != repeatedPassword) {
      GetIt.I<Talker>().log("Can't sign up cause passwords not same");
      return Left(UnmatchedPassFailure());
    } else {
      try {
        await _auth.currentUser?.reload();
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        return Right(userCredential);
      } on FirebaseAuthException catch (e, st) {
        GetIt.I<Talker>().error(e, st);
        if (e.code == 'weak-password') {
          return Left(WeekPassFailure());
        } else if (e.code == 'email-already-in-use') {
          return Left(ExistedAccountFailure());
        } else {
          return Left(ServerFailure());
        }
      } catch (e, st) {
        GetIt.I<Talker>().error(e, st);
        return Left(UnexpectedFailure());
      }
    }
  }

  FirstPageModel firstPage() {
    final userCredential = FirebaseAuth.instance.currentUser;

    if (userCredential != null && userCredential.emailVerified) {
      return const FirstPageModel(isVerifyingEmail: false, isLoggedIn: true);
    } else if (userCredential != null) {
      return const FirstPageModel(isVerifyingEmail: true, isLoggedIn: false);
    } else {
      return const FirstPageModel(isVerifyingEmail: false, isLoggedIn: false);
    }
  }

  Future<Either<Failure, void>> verifyEmail() async {
    if (await _utils.networkConnected()) {
      try {
        final user = _auth.currentUser;
        if (user != null) {
          await user.reload();
          await user.sendEmailVerification();
        } else {
          return Left(NoUserFailure());
        }
        return const Right(null);
      } on FirebaseAuthException catch (e, st) {
        GetIt.I<Talker>().error(e, st);
        if (e.code == 'too-many-requests') {
          return Left(TooManyRequestsFailure());
        } else {
          return Left(ServerFailure());
        }
      } catch (e, st) {
        GetIt.I<Talker>().error(e, st);
        return Left(UnexpectedFailure());
      }
    } else {
      GetIt.I<Talker>().log("Can't verify email, cause device is offline");
      return Left(OfflineFailure());
    }
  }

//TODO check for necesary?
  Future<void> waitForVerifiedUser(Completer completer) async {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      FirebaseAuth.instance.currentUser?.reload();

      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        completer.complete();

        timer.cancel();
      }
    });

    await completer.future;
  }

//TODO check for necesary?
  Future<Either<Failure, void>> checkEmailVerification(
      Completer completer) async {
    try {
      await waitForVerifiedUser(completer).timeout(const Duration(days: 30));

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, void>> logOut() async {
    if (await _utils.networkConnected()) {
      try {
        GoogleSignIn googleSignIn = GoogleSignIn();

        await googleSignIn.signOut();

        await _auth.signOut();
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      GetIt.I<Talker>().log("Can't log out cause device is offline");
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, UserCredential>> googleSignIn() async {
    if (!await _utils.networkConnected()) {
      GetIt.I<Talker>()
          .log("Can't pass google sign in cause device is offline");
      return Left(OfflineFailure());
    } else {
      try {
        await _auth.currentUser?.reload();
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        return Right(userCredential);
      } catch (e) {
        return Left(ServerFailure());
      }
    }
  }
}
