import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prepare2travel/consts.dart';
import 'package:prepare2travel/data/models/item.dart';
import 'package:prepare2travel/data/models/travel.dart';
import 'package:prepare2travel/data/repositories/api/api_travel_repository.dart';
import 'package:prepare2travel/data/repositories/local/local_travel_repository.dart';
import 'package:prepare2travel/domain/repositories/abstract_travel_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'edit_item_event.dart';
part 'edit_item_state.dart';

class EditItemBloc extends Bloc<EditItemEvent, EditItemState> {
  late final Item? initialItem;
  late final Travel travel;
  final ApiTravelRepository apiTravelRepository;
  final LocalTravelRepository localTravelRepository;
  late final StreamSubscription<ConnectivityResult> connectivitySubscription;
  late AbstractTravelRepository actualRepository;
  EditItemBloc(this.apiTravelRepository, this.localTravelRepository)
      : super(EditItemUpdatingState(
            haveErrorMessage: "",
            neededErrorMessage: "",
            name: "item", //TODO
            errorMessage: '',
            needed: 1,
            have: 0,
            nameErrorMessage: '')) {
    on<ItemScreenOpenedEvent>((event, emit) async {
      travel = event.travel;
      if (event.initialItem != null) {
        emit(state.copyWith(
            name: event.initialItem!.name,
            have: event.initialItem!.have,
            needed: event.initialItem!.needed));
        initialItem = event.initialItem;
      }
      await Hive.openBox<Travel>(travelsBoxName);
      await _initRepository();
      emit(EditItemLoadedState(
          errorMessage: state.errorMessage,
          nameErrorMessage: state.nameErrorMessage,
          haveErrorMessage: state.haveErrorMessage,
          neededErrorMessage: state.neededErrorMessage,
          needed: state.needed,
          have: state.have,
          name: state.name));
    });

    on<ScreenDisposedEvent>((event, emit) async {
      await connectivitySubscription.cancel();
    });

    on<ValidateNameEvent>((event, emit) async {
      await _validateName(event, emit);
    });

    on<ValidateHaveEvent>((event, emit) async {
      await _validateHave(event, emit);
    });

    on<ValidateNeededEvent>((event, emit) async {
      await _validateNeeded(event, emit);
    });

    on<CreateOrSaveEvent>((event, emit) async {
      await _validateName(ValidateNameEvent(name: state.name), emit);
      await _validateHave(ValidateHaveEvent(have: state.have.toString()), emit);
      await _validateNeeded(
          ValidateNeededEvent(needed: state.needed.toString()), emit);
      if ([
        state.nameErrorMessage,
        state.neededErrorMessage,
        state.haveErrorMessage
      ].where((e) => e.isNotEmpty).isNotEmpty) {
        emit(EditItemLoadedState(
            errorMessage: state.errorMessage,
            nameErrorMessage: state.nameErrorMessage,
            haveErrorMessage: state.haveErrorMessage,
            neededErrorMessage: state.neededErrorMessage,
            needed: state.needed,
            have: state.have,
            name: state.name));
        event.completer.complete(state);
        return;
      }
      emit(EditItemUpdatingState(
          errorMessage: state.errorMessage,
          nameErrorMessage: state.nameErrorMessage,
          haveErrorMessage: state.haveErrorMessage,
          neededErrorMessage: state.neededErrorMessage,
          needed: state.needed,
          have: state.have,
          name: state.name));
      try {
        if (initialItem == null) {
          travel.items.add(
              Item(name: state.name, needed: state.needed, have: state.have));
          await actualRepository.updateTravel(travel);
        } else {
          var idx = travel.items.indexOf(initialItem!);
          travel.items[idx] =
              Item(name: state.name, have: state.have, needed: state.needed);
          await actualRepository.updateTravel(travel);
        }
      } catch (e, st) {
        emit(EditItemLoadedState(
            errorMessage: initialItem == null
                ? "Error when creating a item" //TODO
                : "Error when updating item", //TODO
            nameErrorMessage: state.nameErrorMessage,
            haveErrorMessage: state.haveErrorMessage,
            neededErrorMessage: state.neededErrorMessage,
            needed: state.needed,
            have: state.have,
            name: state.name));
        GetIt.I<Talker>().handle(e, st);
      } finally {
        event.completer.complete(state);
      }
    });

    on<DeleteItemEvent>((event, emit) async {
      emit(EditItemUpdatingState(
          errorMessage: state.errorMessage,
          nameErrorMessage: state.nameErrorMessage,
          haveErrorMessage: state.haveErrorMessage,
          neededErrorMessage: state.neededErrorMessage,
          needed: state.needed,
          have: state.have,
          name: state.name));
      try {
        travel.items.remove(initialItem);
        await actualRepository.updateTravel(travel);
      } catch (e, st) {
        emit(EditItemLoadedState(
            errorMessage: "Error when deleting item",
            nameErrorMessage: state.nameErrorMessage,
            haveErrorMessage: state.haveErrorMessage,
            neededErrorMessage: state.neededErrorMessage,
            needed: state.needed,
            have: state.have,
            name: state.name));
        GetIt.I<Talker>().handle(e, st);
      } finally {
        event.completer.complete(state);
      }
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
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none ||
          result == ConnectivityResult.bluetooth) {
        actualRepository = localTravelRepository;
      } else {
        actualRepository = apiTravelRepository;
      }
    });
  }

  Future<void> _validateName(
      ValidateNameEvent event, Emitter<EditItemState> emit) async {
    if (event.name.isEmpty) {
      emit(state.copyWith(nameErrorMessage: "Item name can't be empty")); //TODO
    } else {
      emit(state.copyWith(name: event.name, nameErrorMessage: ""));
    }
  }

  Future<void> _validateNeeded(
      ValidateNeededEvent event, Emitter<EditItemState> emit) async {
    if (event.needed.isEmpty) {
      emit(state.copyWith(
          neededErrorMessage:
              "The number of items needed should not be empty")); //TODO
    } else if (int.tryParse(event.needed) == null) {
      emit(state.copyWith(
          neededErrorMessage:
              "The number of items needed must be an integer")); //TODO
    } else if (int.parse(event.needed) <= 0) {
      emit(state.copyWith(
          neededErrorMessage:
              "The number of items needed must be greater than zero")); //TODO
    } else if (int.parse(event.needed) < state.have) {
      emit(state.copyWith(
          needed: int.parse(event.needed),
          neededErrorMessage: "",
          haveErrorMessage: "You can't have more items than need"));
    } else {
      String haveErrorMessage = state.haveErrorMessage;
      if (haveErrorMessage == "You can't have more items than need") {
        haveErrorMessage = "";
      }
      emit(state.copyWith(
          needed: int.parse(event.needed),
          neededErrorMessage: "",
          haveErrorMessage: haveErrorMessage));
    }
  }

  Future<void> _validateHave(
      ValidateHaveEvent event, Emitter<EditItemState> emit) async {
    if (event.have.isEmpty) {
      emit(state.copyWith(
          haveErrorMessage:
              "The number of collected items should not be empty")); //TODO
    } else if (int.tryParse(event.have) == null) {
      emit(state.copyWith(
          haveErrorMessage:
              "The number of collected items must be an integer")); //TODO
    } else if (int.parse(event.have) > state.needed) {
      emit(state.copyWith(
          haveErrorMessage: "You can't have more items than need"));
    } else {
      emit(state.copyWith(have: int.parse(event.have), haveErrorMessage: ""));
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
