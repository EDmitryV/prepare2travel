import 'dart:async';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:prepare2travel/consts.dart';
import 'package:prepare2travel/core/widgets/error_body_widget.dart';
import 'package:prepare2travel/data/repositories/travel_repository.dart';
import 'package:prepare2travel/data/repositories/weather_repository.dart';
import 'package:prepare2travel/data/repositories/local_travel_repository.dart';
import 'package:prepare2travel/domain/entities/travel_preset.dart';
import 'package:prepare2travel/features/create_travel/bloc/create_travel_bloc.dart';
import 'package:prepare2travel/features/create_travel/widget/error_field.dart';
import 'package:prepare2travel/route_names.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:go_router/go_router.dart';

class CreateTravelScreen extends StatefulWidget {
  const CreateTravelScreen({super.key});

  @override
  State<CreateTravelScreen> createState() => _CreateTravelScreenState();
}

class _CreateTravelScreenState extends State<CreateTravelScreen> {
  final CreateTravelBloc _createTravelBloc = CreateTravelBloc(
      GetIt.I<TravelRepository>(),
      GetIt.I<LocalTravelRepository>(),
      GetIt.I<ApiWeatherRepository>());
  @override
  void initState() {
    _createTravelBloc.add(CreateTravelScreenOpenedEvent());
    super.initState();
  }

  @override
  void dispose() {
    _createTravelBloc.add(CreateTravelScreenDisposedEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTravelBloc, CreateTravelState>(
      bloc: _createTravelBloc,
      builder: (context, state) {
        List<Widget> travelPresetWidgets = [];
        for (TravelPreset travelPreset in baseTravelPresets) {
          travelPresetWidgets.add(GestureDetector(
              onTap: () {
                //TODO check for bugs
                if (state.selectedTravelPresets.contains(travelPreset)) {
                  state.selectedTravelPresets.remove(travelPreset);
                } else {
                  state.selectedTravelPresets.add(travelPreset);
                }
                _createTravelBloc.add(ChangeSelectedPresetsListEvent(
                    travelsPresets: state.selectedTravelPresets));
              },
              child: Card(
                color: state.selectedTravelPresets.contains(travelPreset)
                    ? Colors.blue.withAlpha(20)
                    : Colors.white,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(travelPreset.icon),
                      const Divider(
                        color: Colors.grey,
                      ),
                      Text(travelPreset.name)
                    ]),
              )));
        }
        String title = "Create travel"; //TODO
        Widget body;
        if (state.errorMessage.isNotEmpty) {
          body = ErrorBodyWidget<CreateTravelScreenOpenedEvent>(
              bloc: _createTravelBloc,
              retryEvent: CreateTravelScreenOpenedEvent());
        } else if (state is CreateTravelBaseState) {
          body = SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CSCPicker(
                    showCities: true,
                    showStates: true,
                    flagState: CountryFlag.ENABLE,
                    countryDropdownLabel: "Country",
                    stateDropdownLabel: "State",
                    cityDropdownLabel: "City",
                    dropdownDialogRadius: 10.0,
                    searchBarRadius: 10.0,
                    onCountryChanged: (value) => _createTravelBloc
                        .add(UpdateCountryEvent(country: value)),
                    onStateChanged: (value) =>
                        _createTravelBloc.add(UpdateRegionEvent(region: value)),
                    onCityChanged: (value) =>
                        _createTravelBloc.add(UpdateCityEvent(city: value)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    children: [
                      Text(
                          "\tFrom: ${DateFormat("yyyy-MM-dd").format(state.travelStartDate)}"),
                      Text(
                          "\tTo: ${DateFormat("yyyy-MM-dd").format(state.travelEndDate)}")
                    ],
                  ), //TODO translate
                  if (state.travelEndDateErrorMessage.isNotEmpty)
                    ErrorField(
                        error: state
                            .travelEndDateErrorMessage), //TODO change style
                  FilledButton.icon(
                      onPressed: () {
                        showDateRangePicker(
                                context: context,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                initialDateRange: DateTimeRange(
                                    start: state.travelStartDate,
                                    end: state
                                        .travelEndDate)) //TODO translate all text in params
                            .then(
                          (value) {
                            if (value != null) {
                              _createTravelBloc.add(
                                  ValidateTravelDateRangeEvent(
                                      travelStartDate: value.start,
                                      travelEndDate: value.end));
                            }
                          },
                        );
                      },
                      icon: const Icon(Icons.edit_calendar),
                      label: const Text("Select date range")), //TODO translate
                  Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: travelPresetWidgets,
                  ),
                  //TODO add ai generator text field
                ],
              ),
            ),
          );
        } else {
          body = const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => context.pop()),
            title: Text(title),
            actions: [
              FilledButton.icon(
                  onPressed: () {
                    Completer completer = Completer();
                    _createTravelBloc
                        .add(SaveTravelEvent(completer: completer));
                    completer.future.then((value) {
                      if (value.travel != null) {
                        context.pushNamed(RouteNames.travel,
                            queryParameters: {"travel": value.travel!.toMap()});
                      }
                    });
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("Save")), //TODO translate
              if (kDebugMode)
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TalkerScreen(
                            talker: GetIt.I<Talker>(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.info))
            ],
          ),
          body: body,
        );
      },
    );
  }
}
