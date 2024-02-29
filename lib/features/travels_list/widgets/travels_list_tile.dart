import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prepare2travel/data/models/item.dart';
import 'package:prepare2travel/data/models/travel.dart';
import 'package:prepare2travel/features/travels_list/bloc/travels_list_bloc.dart';
import 'package:prepare2travel/route_names.dart';

class TravelsListTile extends StatelessWidget {
  const TravelsListTile({
    super.key,
    required this.travel,
    required this.idx,
    required this.bloc,
  });
  final Travel travel;
  final int idx;
  final TravelsListBloc bloc;
  @override
  Widget build(BuildContext context) {
    int haveItems = 0;
    int needItems = 0;
    for (Item item in travel.items) {
      haveItems += item.have;
      needItems += item.needed;
    }
    int minsDifference =
        DateTime.now().difference(travel.days.first.date!).inMinutes;
    String status;
    Color statusColor;
    if (haveItems == needItems) {
      //TODO
      if (minsDifference < 0) {
        status = "Prepared";
        statusColor = Colors.lightGreen;
      } else {
        status = "Completed";
        statusColor = Colors.green;
      }
    } else {
      if (minsDifference < 0) {
        status = "In progress";
        statusColor = Colors.blue;
      } else {
        status = "Late";
        statusColor = Colors.red;
      }
    }
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          hoverColor: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            context.pushNamed(RouteNames.travel, extra: travel).then(
                (value) =>
                    bloc.add(LoadTravelsListEvent(user: bloc.state.user)));//TODO reload on new page open
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Text(
                        "${travel.city}, ${travel.region}, ${travel.country} \n ${DateFormat("dd.MM.yy").format(travel.days.first.date!)} - ${DateFormat("dd.MM.yy").format(travel.days.last.date!)}", //TODO add i18n
                        style: Theme.of(context).textTheme.headlineMedium),
                    IconButton.filledTonal(
                        color: Colors.red,
                        onPressed: () {
                          bloc.add(TravelDeletedEvent(
                              travelIdx: idx, travelToDelete: travel));
                        },
                        icon: const Icon(Icons.delete))
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Text(
                      //TODO
                      "Status: $status",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(color: statusColor),
                    ),
                    Text(
                      "Items: $haveItems/$needItems",
                      style: Theme.of(context).textTheme.labelLarge,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
