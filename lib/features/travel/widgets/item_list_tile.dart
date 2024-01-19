import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:prepare2travel/data/models/item.dart';
import 'package:prepare2travel/data/models/travel.dart';
import 'package:prepare2travel/features/travel/bloc/travel_bloc.dart';
import 'package:prepare2travel/router/router.dart';

class ItemListTile extends StatelessWidget {
  const ItemListTile({
    super.key,
    required this.travel,
    required this.idx,
    required this.bloc,
  });
  final Travel travel;
  final int idx;
  final TravelBloc bloc;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const BeveledRectangleBorder(),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          hoverColor: Colors.transparent,
          onTap: () {
            AutoRouter.of(context)
                .push(EditItemRoute(item: travel.items[idx], travel: travel))
                .then((_) {
              bloc.add(TravelScreenReloadTravelEvent());
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  travel.items[idx].name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Text(
                  "${travel.items[idx].have}/${travel.items[idx].needed}",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(width: 15),
                FilledButton.tonalIcon(
                    label: const Text("Add"), //TODO
                    onPressed: () {
                      bloc.add(ItemAddedEvent(
                        addedItem: travel.items[idx],
                        addedItemIdx: idx,
                      ));
                    },
                    icon: const Icon(
                      Icons.check,
                      color: Colors.green,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
