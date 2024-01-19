part of 'create_travel_bloc.dart';

abstract class CreateTravelState {
  Travel? travel;
  Travel? generatedTravelPreset;
  final String description;
  final String descriptionErrorMessage;
  final String errorMessage;
  final String city;
  final String region;
  final String country;
  final List<TravelPreset> selectedTravelPresets;
  final DateTime travelStartDate;
  final DateTime travelEndDate;
  final String travelEndDateErrorMessage;

  CreateTravelState({
    this.generatedTravelPreset,
    this.travel,
    required this.selectedTravelPresets,
    required this.travelStartDate,
    required this.travelEndDate,
    required this.travelEndDateErrorMessage,
    required this.city,
    required this.region,
    required this.country,
    required this.description,
    required this.errorMessage,
    required this.descriptionErrorMessage,
  });

  CreateTravelState copyWith(
      {String? descriptionErrorMessage,
      String? description,
      String? city,
      String? region,
      String? country,
      String? errorMessage,
      Travel? travel,
      List<TravelPreset>? selectedTravelPresets,
      Travel? generatedTravelPreset,
      DateTime? travelStartDate,
      DateTime? travelEndDate,
      String? travelDateRangeErrorMessage});
}

class CreateTravelBaseState extends CreateTravelState {
  CreateTravelBaseState(
      {required super.errorMessage,
      required super.city,
      required super.region,
      required super.country,
      required super.selectedTravelPresets,
      required super.descriptionErrorMessage,
      required super.description,
      super.generatedTravelPreset,
      super.travel,
      required super.travelStartDate,
      required super.travelEndDate,
      required super.travelEndDateErrorMessage});

  @override
  CreateTravelBaseState copyWith(
      {String? descriptionErrorMessage,
      String? description,
      String? errorMessage,
      String? city,
      String? region,
      String? country,
      Travel? travel,
      List<TravelPreset>? selectedTravelPresets,
      Travel? generatedTravelPreset,
      DateTime? travelStartDate,
      DateTime? travelEndDate,
      String? travelDateRangeErrorMessage}) {
    return CreateTravelBaseState(
        travel: travel ?? this.travel,
        selectedTravelPresets: selectedTravelPresets ?? this.selectedTravelPresets,
        travelStartDate: travelStartDate ?? this.travelStartDate,
        travelEndDate: travelEndDate ?? this.travelEndDate,
        travelEndDateErrorMessage:
            travelDateRangeErrorMessage ?? this.travelEndDateErrorMessage,
        city: city ?? this.city,
        region: region ?? this.region,
        country: country ?? this.country,
        description: description ?? this.description,
        descriptionErrorMessage:
            descriptionErrorMessage ?? this.descriptionErrorMessage,
        errorMessage: errorMessage ?? this.errorMessage,
        generatedTravelPreset:
            generatedTravelPreset ?? this.generatedTravelPreset);
  }
}

class CreateTravelUpdatingState extends CreateTravelState {
  CreateTravelUpdatingState(
      {required super.errorMessage,
      required super.selectedTravelPresets,
      required super.city,
      required super.region,
      required super.country,
      required super.description,
      required super.descriptionErrorMessage,
      super.generatedTravelPreset,
      super.travel,
      required super.travelStartDate,
      required super.travelEndDate,
      required super.travelEndDateErrorMessage});

  @override
  CreateTravelUpdatingState copyWith(
      {String? description,
      String? descriptionErrorMessage,
      String? errorMessage,
      String? city,
      String? region,
      String? country,
      Travel? travel,
      List<TravelPreset>? selectedTravelPresets,
      Travel? generatedTravelPreset,
      DateTime? travelStartDate,
      DateTime? travelEndDate,
      String? travelDateRangeErrorMessage}) {
    return CreateTravelUpdatingState(
        travel: travel ?? this.travel,
        selectedTravelPresets: selectedTravelPresets ?? this.selectedTravelPresets,
        travelStartDate: travelStartDate ?? this.travelStartDate,
        travelEndDate: travelEndDate ?? this.travelEndDate,
        travelEndDateErrorMessage:
            travelDateRangeErrorMessage ?? this.travelEndDateErrorMessage,
        city: city ?? this.city,
        region: region ?? this.region,
        country: country ?? this.country,
        description: description ?? this.description,
        descriptionErrorMessage:
            descriptionErrorMessage ?? this.descriptionErrorMessage,
        errorMessage: errorMessage ?? this.errorMessage,
        generatedTravelPreset:
            generatedTravelPreset ?? this.generatedTravelPreset);
  }
}

class CreateTravelErrorState extends CreateTravelState {
  CreateTravelErrorState(
      {required super.description,
      required super.selectedTravelPresets,
      required super.city,
      required super.region,
      required super.country,
      required super.descriptionErrorMessage,
      required super.errorMessage,
      super.generatedTravelPreset,
      super.travel,
      required super.travelStartDate,
      required super.travelEndDate,
      required super.travelEndDateErrorMessage});

  @override
  CreateTravelErrorState copyWith(
      {DateTime? travelStartDate,
      DateTime? travelEndDate,
      List<TravelPreset>? selectedTravelPresets,
      Travel? travel,
      String? travelDateRangeErrorMessage,
      String? description,
      String? descriptionErrorMessage,
      String? errorMessage,
      String? city,
      String? region,
      String? country,
      Travel? generatedTravelPreset}) {
    return CreateTravelErrorState(
        travel: travel ?? this.travel,
        selectedTravelPresets: selectedTravelPresets ?? this.selectedTravelPresets,
        travelStartDate: travelStartDate ?? this.travelStartDate,
        travelEndDate: travelEndDate ?? this.travelEndDate,
        travelEndDateErrorMessage:
            travelDateRangeErrorMessage ?? this.travelEndDateErrorMessage,
        city: city ?? this.city,
        region: region ?? this.region,
        country: country ?? this.country,
        description: description ?? this.description,
        descriptionErrorMessage:
            descriptionErrorMessage ?? this.descriptionErrorMessage,
        errorMessage: errorMessage ?? this.errorMessage,
        generatedTravelPreset:
            generatedTravelPreset ?? this.generatedTravelPreset);
  }
}
