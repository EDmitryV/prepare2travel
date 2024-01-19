part of 'create_travel_bloc.dart';

abstract class CreateTravelEvent {}

class CreateTravelScreenOpenedEvent extends CreateTravelEvent {
  CreateTravelScreenOpenedEvent({
    required this.user,
  });
  User user;
}

class CreateTravelScreenDisposedEvent extends CreateTravelEvent {}

class ChangeSelectedPresetsListEvent extends CreateTravelEvent {
  final List<TravelPreset> travelsPresets;

  ChangeSelectedPresetsListEvent({required this.travelsPresets});
}

class UpdateCityEvent extends CreateTravelEvent {
  final String? city;

  UpdateCityEvent({required this.city});
}

class UpdateRegionEvent extends CreateTravelEvent {
  final String? region;

  UpdateRegionEvent({required this.region});
}

class UpdateCountryEvent extends CreateTravelEvent {
  final String? country;

  UpdateCountryEvent({required this.country});
}

class ValidateTravelDateRangeEvent extends CreateTravelEvent {
  final DateTime travelStartDate;
  final DateTime travelEndDate;

  ValidateTravelDateRangeEvent(
      {required this.travelStartDate, required this.travelEndDate});
}

class GenerateTravelPresetEvent extends CreateTravelEvent {
  final String description;

  GenerateTravelPresetEvent({required this.description});
}

class RemoveGeneratedTravelPresetEvent extends CreateTravelEvent {}

class SaveTravelEvent extends CreateTravelEvent {
  SaveTravelEvent({required this.completer});
  Completer completer;
}

class EndErrorMessageNotification extends CreateTravelEvent {}
