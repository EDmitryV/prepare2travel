import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart'; //TODO
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prepare2travel/consts.dart';
import 'package:prepare2travel/data/models/travel.dart';
import 'package:prepare2travel/data/models/user.dart';
import 'package:prepare2travel/data/repositories/api/api_travel_repository.dart';
import 'package:prepare2travel/data/repositories/api/api_user_repository.dart';
import 'package:prepare2travel/data/repositories/local/local_travel_repository.dart';
import 'package:prepare2travel/data/repositories/local/local_user_repository.dart';
import 'package:prepare2travel/domain/repositories/abstract_travel_repository.dart';
import 'package:prepare2travel/domain/repositories/abstract_user_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'travels_list_event.dart';
part 'travels_list_state.dart';

class TravelsListBloc extends Bloc<TravelsListEvent, TravelsListState> {
  final LocalTravelRepository localTravelsRepository;
  final ApiTravelRepository apiTravelsRepository;
  final LocalUserRepository localUserRepository;
  final ApiUserRepository apiUserRepository;
  late final StreamSubscription<ConnectivityResult> connectivitySubscription;
  late AbstractTravelRepository actualTravelRepository;
  late AbstractUserRepository actualUserRepository;

  TravelsListBloc(this.localTravelsRepository, this.apiTravelsRepository,
      this.localUserRepository, this.apiUserRepository)
      : super(TravelsListInitState(user: null, travelsList: [])) {
    on<TravelListScreenOpenedEvent>((event, emit) async {
      await Hive.openBox<Travel>(travelsBoxName);
      await Hive.openBox<User>(userBoxName);
      await _initRepository();
      User? user = await actualUserRepository.getUser();
      emit(state.copyWith(user: user));
      //TODO
        add(LoadTravelsListEvent());
    });

    on<TravelListScreenDisposedEvent>((event, emit) async {
      await connectivitySubscription.cancel();
    });

    on<LoadTravelsListEvent>((event, emit) async {
      await _loadTravelsList(event, emit);
    });

    on<UpdateUserEvent>((event, emit) async {
      User? user = await actualUserRepository.getUser();
      emit(TravelsListLoadedState(user: user, travelsList: state.travelsList));
    });

    on<TravelDeletedEvent>((event, emit) async {
      await _deleteTravel(event, emit);
    });
  }

  Future<void> _initRepository() async {
    actualTravelRepository = localTravelsRepository;
    actualUserRepository = localUserRepository;
    final connectivityResult = await (Connectivity().checkConnectivity());
    actualTravelRepository = localTravelsRepository;
    actualUserRepository = localUserRepository;
    if (connectivityResult == ConnectivityResult.none ||
        connectivityResult == ConnectivityResult.bluetooth) {
      actualTravelRepository = localTravelsRepository;
      actualUserRepository = localUserRepository;
    } else {
      actualTravelRepository = apiTravelsRepository;
      actualUserRepository = apiUserRepository;
    }
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.none ||
          result == ConnectivityResult.bluetooth) {
        actualTravelRepository = localTravelsRepository;
      } else {
        actualTravelRepository = apiTravelsRepository;
        actualUserRepository = apiUserRepository;
      }
    });
  }

  Future<void> _loadTravelsList(
      LoadTravelsListEvent event, Emitter<TravelsListState> emit) async {
    if (state is! TravelsListLoadingState) {
      emit(TravelsListLoadingState(
          user: state.user, travelsList: state.travelsList));
    }
    try {
      final travelsList = await actualTravelRepository.getAllTravels();
      emit(TravelsListLoadedState(user: state.user, travelsList: travelsList));
    } catch (e, st) {
      emit(TravelsListErrorState(
          user: state.user, travelsList: state.travelsList));
      GetIt.I<Talker>().handle(e, st);
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _deleteTravel(
      TravelDeletedEvent event, Emitter<TravelsListState> emit) async {
    try {
      await actualTravelRepository.deleteTravel(event.travelToDelete);
      if (state is TravelsListLoadedState) {
        TravelsListLoadedState previousState = state as TravelsListLoadedState;
        var travelsList = previousState.travelsList;
        travelsList.removeAt(event.travelIdx);
        emit(
            TravelsListLoadedState(user: state.user, travelsList: travelsList));
      }
    } catch (e, st) {
      emit(TravelsListErrorState(
          user: state.user, travelsList: state.travelsList));
      GetIt.I<Talker>().handle(e, st);
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
