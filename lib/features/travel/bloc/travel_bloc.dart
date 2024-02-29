import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prepare2travel/consts.dart';
import 'package:prepare2travel/data/models/item.dart';
import 'package:prepare2travel/data/models/travel.dart';
import 'package:prepare2travel/data/repositories/travel_repository.dart';
import 'package:prepare2travel/data/repositories/local_travel_repository.dart';
import 'package:prepare2travel/domain/repositories/abstract_travel_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'travel_event.dart';
part 'travel_state.dart';

class TravelBloc extends Bloc<TravelEvent, TravelState> {
  final TravelRepository apiTravelRepository;
  final LocalTravelRepository localTravelRepository;
  late final Travel? travel;
  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  late AbstractTravelRepository actualRepository;
  TravelBloc(this.apiTravelRepository, this.localTravelRepository)
      : super(TravelInitState(
            travel: Travel(
                country: "",
                region: "",
                city: "",
                days: [],
                items: [],
                creationDate: DateTime.now()))) {
    on<TravelScreenOpenedEvent>((event, emit) async {
      emit(state.copyWith(travel: event.travel));
      await Hive.openBox<Travel>(travelsBoxName);
      await _initRepository();
      await _loadPage(event, emit);
    });

    on<TravelScreenDisposedEvent>((event, emit) async {
      await connectivitySubscription!.cancel();
    });

    on<TravelScreenReloadTravelEvent>((event, emit) async {
      emit(TravelLoadingState(travel: state.travel));
      Travel? travel = await actualRepository.getTravel(state.travel.key);
      emit(TravelLoadedState(travel: travel!));
    });

    on<ItemAddedEvent>((event, emit) async {
      await _addItem(event, emit);
    });

    on<ItemChangedEvent>((event, emit) async {
      emit(TravelLoadingState(travel: state.travel));
      state.travel.items[event.idx] = event.newItem;
      emit(TravelLoadedState(travel: state.travel));
    });
  }

  Future<void> _initRepository() async {
    actualRepository = localTravelRepository;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none ||
        connectivityResult == ConnectivityResult.bluetooth) {
      actualRepository = localTravelRepository;
    } else {
      actualRepository = apiTravelRepository;
    }
    connectivitySubscription ??= Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.none ||
          result == ConnectivityResult.bluetooth) {
        actualRepository = localTravelRepository;
      } else {
        actualRepository = apiTravelRepository;
      }
    });
  }

  Future<void> _loadPage(
      TravelScreenOpenedEvent event, Emitter<TravelState> emit) async {
    if (state is! TravelLoadingState) {
      emit(TravelLoadingState(travel: state.travel));
    }
    try {
      Travel? travel = await actualRepository.getTravel(state.travel.key);
      if (travel != null) {
        emit(TravelLoadedState(travel: travel));
      } else {
        emit(TravelErrorState(travel: state.travel));
      }
    } catch (e, st) {
      emit(TravelErrorState(travel: state.travel));
      GetIt.I<Talker>().handle(e, st);
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _addItem(ItemAddedEvent event, Emitter<TravelState> emit) async {
    var item = event.addedItem;
    try {
      //TODO check for bugs
      if (item.have < item.needed) {
        item.have += 1;
        var updatedTravel = await actualRepository.updateTravel(state.travel);
        emit(TravelLoadedState(travel: updatedTravel));
      }
    } catch (e, st) {
      emit(TravelErrorState(travel: state.travel));
      GetIt.I<Talker>().handle(e, st);
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
