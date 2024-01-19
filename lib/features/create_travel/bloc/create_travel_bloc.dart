import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prepare2travel/consts.dart';
import 'package:prepare2travel/data/models/day.dart';
import 'package:prepare2travel/data/models/item.dart';
import 'package:prepare2travel/data/models/travel.dart';
import 'package:prepare2travel/data/models/user.dart';
import 'package:prepare2travel/data/repositories/api/api_travel_repository.dart';
import 'package:prepare2travel/data/repositories/api/api_weather_repository.dart';
import 'package:prepare2travel/data/repositories/local/local_travel_repository.dart';
import 'package:prepare2travel/domain/model/travel_preset.dart';
import 'package:prepare2travel/domain/repositories/abstract_travel_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'create_travel_event.dart';
part 'create_travel_state.dart';

class CreateTravelBloc extends Bloc<CreateTravelEvent, CreateTravelState> {
  final ApiTravelRepository apiTravelRepository;
  final LocalTravelRepository localTravelRepository;
  final ApiWeatherRepository apiWeatherRepository;
  late final User user;
  late final StreamSubscription<ConnectivityResult> connectivitySubscription;
  late AbstractTravelRepository actualRepository;
  CreateTravelBloc(this.apiTravelRepository, this.localTravelRepository,
      this.apiWeatherRepository)
      : super(CreateTravelUpdatingState(
            city: "",
            region: "",
            country: "",
            description: "",
            descriptionErrorMessage: "",
            errorMessage: '',
            selectedTravelPresets: [],
            generatedTravelPreset: null,
            travelStartDate: DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day + 1),
            travelEndDate: DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day + 2),
            travelEndDateErrorMessage: "")) {
    on<CreateTravelScreenOpenedEvent>((event, emit) async {
      user = event.user;
      await Hive.openBox<Travel>(travelsBoxName);
      await _initRepository();
      emit(CreateTravelBaseState(
          city: state.city,
          region: state.region,
          country: state.country,
          descriptionErrorMessage: state.descriptionErrorMessage,
          errorMessage: state.errorMessage,
          selectedTravelPresets: state.selectedTravelPresets,
          description: state.description,
          generatedTravelPreset: state.generatedTravelPreset,
          travelStartDate: state.travelStartDate,
          travelEndDate: state.travelEndDate,
          travelEndDateErrorMessage: state.travelEndDateErrorMessage));
    });

    on<CreateTravelScreenDisposedEvent>((event, emit) async {
      await connectivitySubscription.cancel();
    });

    on<ChangeSelectedPresetsListEvent>((event, emit) async {
      emit(state.copyWith(selectedTravelPresets: event.travelsPresets));
    });

    on<ValidateTravelDateRangeEvent>((event, emit) async {
      if (event.travelStartDate.isAfter(event.travelEndDate)) {
        emit(state.copyWith(
            travelStartDate: event.travelStartDate,
            travelEndDate: event.travelEndDate,
            travelDateRangeErrorMessage:
                "The start date of the trip cannot be greater than the end date")); //TODO translate
      } else {
        emit(state.copyWith(
            travelStartDate: event.travelStartDate,
            travelEndDate: event.travelEndDate,
            travelDateRangeErrorMessage: ""));
      }
    });

    on<GenerateTravelPresetEvent>((event, emit) async {
      _generateTravelPreset(event, emit);
    });

    on<RemoveGeneratedTravelPresetEvent>((event, emit) async {
      //TODO check for bug
      state.generatedTravelPreset = null;
      emit(state);
    });

    on<UpdateCityEvent>((event, emit) async {
      emit(state.copyWith(city: event.city));
    });

    on<UpdateRegionEvent>((event, emit) async {
      emit(state.copyWith(region: event.region));
    });

    on<UpdateCountryEvent>((event, emit) async {
      emit(state.copyWith(country: event.country!.split(' ').last));
    });

    on<SaveTravelEvent>((event, emit) async {
      emit(CreateTravelUpdatingState(
          city: state.city,
          region: state.region,
          country: state.country,
          errorMessage: state.errorMessage,
          description: state.description,
          descriptionErrorMessage: state.descriptionErrorMessage,
          selectedTravelPresets: state.selectedTravelPresets,
          travelStartDate: state.travelStartDate,
          travelEndDate: state.travelEndDate,
          travelEndDateErrorMessage: state.travelEndDateErrorMessage));
      List<TravelPreset> travelPressets = state.selectedTravelPresets;
      try {
        List<Day> daysDates = [];
        for (int i = 0;
            i <= state.travelEndDate.difference(state.travelStartDate).inDays;
            i++) {
          daysDates
              .add(Day(date: state.travelStartDate.add(Duration(days: i))));
        }
        Map<String, Item> itemsMap = {};
        for (TravelPreset travelPreset in travelPressets) {
          for (Item item in travelPreset.itemsPerTravel) {
            if (!itemsMap.containsKey(item.name)) {
              //TODO check for reuse bug when item changed
              itemsMap[item.name] = item.copyWith();
            }
          }
          for (Item item in travelPreset.itemsPerDay) {
            if (!itemsMap.containsKey(item.name)) {
              itemsMap[item.name] = item.copyWith(
                  needed: item.needed *
                      state.travelEndDate
                          .difference(state.travelStartDate)
                          .inDays);
            }
          }
        }
        if (state.generatedTravelPreset != null) {
          for (Item item in state.generatedTravelPreset!.items) {
            if (!itemsMap.containsKey(item.name)) {
              //TODO check for reuse bug when item changed
              itemsMap[item.name] = item.copyWith();
            }
          }
          for (int idx = 0;
              idx < state.generatedTravelPreset!.days.length;
              idx++) {
            if (daysDates.length > idx &&
                state
                    .generatedTravelPreset!.days[idx].interesting!.isNotEmpty) {
              daysDates[idx].interesting =
                  "${daysDates[idx].interesting}\n\t${state.generatedTravelPreset!.days[idx].interesting}";
            }
          }
        }
        for (Item item in await _generateRequiredItems()) {
          if (!itemsMap.containsKey(item.name) ||
              itemsMap[item.name]!.needed < item.needed) {
            //TODO check for reuse bug when item changed
            itemsMap[item.name] = item.copyWith();
          }
        }
        var weather = await apiWeatherRepository.getWeatherForecast(
            state.city,
            state.region,
            state.country,
            daysDates.first.date!,
            daysDates.last.date!);
        var i = 0;
        for (var dayWeather in weather) {
          String? preciption;
          var preciptype = dayWeather["presiptype"];
          if (preciptype != null) {
            for (String precip in preciptype) {
              if (preciption == null) {
                preciption = precip;
              } else {
                preciption += ", $precip";
              }
            }
          }
          daysDates[i] = daysDates[i].copyWith(
              minTemperature: dayWeather["tempmin"],
              maxTemperature: dayWeather["tempmax"],
              humidity: dayWeather["humidity"],
              precipitation: preciption);
          i++;
        }
        Travel travel = Travel(
            country: state.country,
            region: state.region,
            city: state.city,
            days: daysDates,
            items: itemsMap.values.toList(),
            creationDate: DateTime.now());
        travel = await actualRepository.createTravel(travel);
        emit(state.copyWith(travel: travel));
      } catch (e, st) {
        emit(CreateTravelErrorState(
            city: state.city,
            region: state.region,
            country: state.country,
            description: state.description,
            selectedTravelPresets: state.selectedTravelPresets,
            descriptionErrorMessage: state.descriptionErrorMessage,
            errorMessage: "Something went wrong",
            travelStartDate: state.travelStartDate,
            travelEndDate: state.travelEndDate,
            travelEndDateErrorMessage:
                state.travelEndDateErrorMessage)); //TODO translate
        GetIt.I<Talker>().handle(e, st);
      } finally {
        event.completer.complete(state);
      }
    });

    on<EndErrorMessageNotification>((event, emit) async {
      emit(state.copyWith(errorMessage: ""));
    });
  }
  Future<void> _generateTravelPreset(
      GenerateTravelPresetEvent event, Emitter<CreateTravelState> emit) async {
    //TODO add nlp model and test it on real device
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

  Future<List<Item>> _generateRequiredItems() async {
    //TODO
    return [];
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
