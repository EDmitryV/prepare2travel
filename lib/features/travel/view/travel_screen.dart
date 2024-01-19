import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:prepare2travel/data/models/travel.dart';
import 'package:prepare2travel/data/repositories/api/api_travel_repository.dart';
import 'package:prepare2travel/data/repositories/local/local_travel_repository.dart';
import 'package:prepare2travel/features/travel/bloc/travel_bloc.dart';
import 'package:prepare2travel/features/travel/widgets/day_list_card.dart';
import 'package:prepare2travel/features/travel/widgets/fake_item_list_tile.dart';
import 'package:prepare2travel/features/travel/widgets/item_list_tile.dart';
import 'package:prepare2travel/router/router.dart';
import 'package:talker_flutter/talker_flutter.dart';

@RoutePage()
class TravelScreen extends StatefulWidget {
  final Travel travel;
  const TravelScreen({super.key, required this.travel});

  @override
  State<TravelScreen> createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {
  final _travelBloc = TravelBloc(
      GetIt.I<ApiTravelRepository>(), GetIt.I<LocalTravelRepository>());

  @override
  void initState() {
    _travelBloc
        .add(TravelScreenOpenedEvent(completer: null, travel: widget.travel));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelBloc, TravelState>(
        bloc: _travelBloc,
        builder: (context, state) {
          const paddings =
              EdgeInsets.only(top: 16, bottom: 200, left: 40, right: 40);
          Widget body;
          if (state is TravelLoadedState) {
            body = CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => Navigator.of(context).pop()),
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
                  snap: true,
                  floating: true,
                  title: Text(
                      "${state.travel.city}, ${DateFormat("dd.MM.yy").format(state.travel.days.first.date!)} - ${DateFormat("dd.MM.yy").format(state.travel.days.last.date!)}" //TODO translate
                      ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                SliverToBoxAdapter(
                    child: SizedBox(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) =>
                              DayListCard(day: state.travel.days[index]),
                          itemCount: state.travel.days.length,
                        ))),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverList.builder(
                  itemBuilder: (context, idx) {
                    return ItemListTile(
                        travel: state.travel, idx: idx, bloc: _travelBloc);
                  },
                  itemCount: state.travel.items.length,
                )
              ],
            );
          } else if (state is TravelErrorState) {
            body = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Something went wrong', //TODO
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    'Please try again later', //TODO
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: () {
                      _travelBloc.add(TravelScreenOpenedEvent(
                          completer: null, travel: widget.travel));
                    },
                    child: const Text('Reload'), //TODO
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
                return const FakeItemListTile();
              },
            );
          }
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    AutoRouter.of(context) //TODO
                        .push(EditItemRoute(item: null, travel: widget.travel))
                        .then((_) {
                      _travelBloc.add(TravelScreenReloadTravelEvent());
                    });
                  }),
              body: RefreshIndicator(
                  onRefresh: () async {
                    final completer = Completer();
                    _travelBloc.add(TravelScreenOpenedEvent(
                        completer: completer, travel: widget.travel));
                    return completer.future;
                  },
                  child: body));
        });
  }

  @override
  void dispose() {
    _travelBloc.add(TravelScreenDisposedEvent());
    super.dispose();
  }
}
