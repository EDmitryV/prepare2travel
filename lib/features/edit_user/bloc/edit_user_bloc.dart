import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prepare2travel/consts.dart';
import 'package:prepare2travel/data/models/user.dart';
import 'package:prepare2travel/data/models/user_sex.dart';
import 'package:prepare2travel/data/repositories/api/api_user_repository.dart';
import 'package:prepare2travel/data/repositories/local/local_user_repository.dart';
import 'package:prepare2travel/domain/repositories/abstract_user_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'edit_user_event.dart';
part 'edit_user_state.dart';

class EditUserBloc extends Bloc<EditUserEvent, EditUserState> {
  final LocalUserRepository localUserRepository;
  final ApiUserRepository apiUserRepository;
  late final StreamSubscription<ConnectivityResult> connectivitySubscription;
  late AbstractUserRepository actualRepository;

  EditUserBloc(this.localUserRepository, this.apiUserRepository)
      : super(EditUserUpdatingState(
            user: User(sex: UserSex.male, username: 'user', id: 0),
            initialUser: null)) {
    on<EditUserScreenOpenedEvent>((event, emit) async {
      await Hive.openBox<User>(userBoxName);
      await _initRepository(emit);
      User user;
      User? initialUser = await actualRepository.getUser();
      if (initialUser != null) {
        user = User(
            sex: initialUser.sex,
            username: initialUser.username,
            id: initialUser.id);
      } else {
        user = User(
            sex: state.user.sex,
            username: state.user.username,
            id: state.user.id);
      }
      emit(EditUserDefaultState(user: user, initialUser: initialUser));
    });

    on<EditUserScreenDisposedEvent>((event, emit) async {
      await connectivitySubscription.cancel();
    });

    on<UpdateSexEvent>((event, emit) async {
      state.user.sex = event.sex;
      emit(state.copyWith());
    });

    on<CreateOrUpdateEvent>((event, emit) async {
      await _createOrUpdate(event, emit);
    });

    on<EndErrorMessageNotificationEvent>((event, emit) async {
      emit(state.copyWith(errorMessage: null));
    });
  }

  Future<void> _initRepository(emit) async {
    actualRepository = localUserRepository;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none ||
        connectivityResult == ConnectivityResult.bluetooth) {
      actualRepository = localUserRepository;
      emit(state.copyWith(errorMessage: "Internet connection not found"));
    } else {
      actualRepository = apiUserRepository;
    }
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none ||
          result == ConnectivityResult.bluetooth) {
        actualRepository = localUserRepository;
      } else {
        actualRepository = apiUserRepository;
      }
    });
  }

  Future<void> _createOrUpdate(event, emit) async {
    try {
      emit(EditUserUpdatingState(
          user: state.user, initialUser: state.initialUser));
      if (state.initialUser == null) {
        await actualRepository.createUser(state.user);
      } else {
        await actualRepository
            .updateUser(state.initialUser!.copyParamsFrom(user: state.user));
      }
    } catch (e, st) {
      emit(
          EditUserErrorState(user: state.user, initialUser: state.initialUser));
      GetIt.I<Talker>().handle(e, st);
    } finally {
      event.completer.complete(state);
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
