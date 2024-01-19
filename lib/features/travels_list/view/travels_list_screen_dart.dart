import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:prepare2travel/data/repositories/api/api_travel_repository.dart';
import 'package:prepare2travel/data/repositories/api/api_user_repository.dart';
import 'package:prepare2travel/data/repositories/local/local_travel_repository.dart';
import 'package:prepare2travel/data/repositories/local/local_user_repository.dart';
import 'package:prepare2travel/features/travels_list/bloc/travels_list_bloc.dart';
import 'package:prepare2travel/features/travels_list/widgets/fake_travels_list_tile.dart';
import 'package:prepare2travel/features/travels_list/widgets/travels_list_tile.dart';
import 'package:prepare2travel/router/router.dart';
import 'package:talker_flutter/talker_flutter.dart';

@RoutePage()
class TravelsListScreen extends StatefulWidget {
  const TravelsListScreen({super.key});

  @override
  State<TravelsListScreen> createState() => _TravelsListScreenState();
}

class _TravelsListScreenState extends State<TravelsListScreen> {
  final _travelsListBloc = TravelsListBloc(
      GetIt.I<LocalTravelRepository>(),
      GetIt.I<ApiTravelRepository>(),
      GetIt.I<LocalUserRepository>(),
      GetIt.I<ApiUserRepository>());

  @override
  void initState() {
    _travelsListBloc.add(TravelListScreenOpenedEvent(completer: null));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelsListBloc, TravelsListState>(
        bloc: _travelsListBloc,
        builder: (context, state) {
          const paddings =
              EdgeInsets.only(top: 16, bottom: 200, left: 40, right: 40);
          Widget body;
          if (state is TravelsListLoadedState && state.user == null) {
            AutoRouter.of(context).push(EditUserRoute(user: null)).then((_) {
              _travelsListBloc.add(UpdateUserEvent());
            });
            body = const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TravelsListLoadedState) {
            if (state.travelsList.isEmpty) {
              body = const Center(
                child: Text(
                  "You don't have any travels \non your list",
                  textAlign: TextAlign.center,
                ), //TODO translate
              );
            } else {
              body = ListView.separated(
                padding: paddings,
                itemCount: state.travelsList.length,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 12,
                ),
                itemBuilder: (context, i) {
                  final travel = state.travelsList[i];
                  return TravelsListTile(
                      travel: travel, idx: i, bloc: _travelsListBloc);
                },
              );
            }
          } else if (state is TravelsListErrorState) {
            body = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //TODO
                  Text(
                    'Something went wrong',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    'Please try again later',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: () {
                      _travelsListBloc.add(LoadTravelsListEvent());
                    },
                    child: const Text('Reload'),
                  ),
                ],
              ),
            );
          } else {
            body = ListView.separated(
              padding: paddings,
              itemCount: 3,
              separatorBuilder: (context, index) => const SizedBox(
                height: 12,
              ),
              itemBuilder: (context, i) {
                return const FakeTravelsListTile();
              },
            );
          }
          return Scaffold(floatingActionButton: FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    //TODO
                    AutoRouter.of(context)
                        .push(CreateTravelRoute(user: state.user!))
                        .then((value) =>
                            _travelsListBloc.add(LoadTravelsListEvent()));
                  }),
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.account_circle),
                  onPressed: () {
                    AutoRouter.of(context)
                        .push(EditUserRoute(user: null))
                        .then((_) {
                      _travelsListBloc.add(UpdateUserEvent());
                    });
                  },
                ),
                title: const Text("Travels"), //TODO
                actions: [
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
              body: RefreshIndicator(
                  onRefresh: () async {
                    final completer = Completer();
                    if (state is! TravelsListLoadedState) {
                      _travelsListBloc
                          .add(LoadTravelsListEvent(completer: completer));
                    } else {
                      _travelsListBloc
                          .add(LoadTravelsListEvent(completer: completer));
                    }
                    return completer.future;
                  },
                  child: body));
        });
  }
}
