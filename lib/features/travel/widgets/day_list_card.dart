import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prepare2travel/data/models/day.dart';

class DayListCard extends StatelessWidget {
  const DayListCard({super.key, required this.day});
  final Day day;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        width: 200,
        child: Column(mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (day.precipitation != null && day.precipitation!.isNotEmpty)
            Text("Precipitation: ${day.precipitation}"), //TODO
          Text("Date: ${DateFormat("dd.MM.yy").format(day.date!)}"),//TODO add i18n
          Text(
              "Temperature: ${day.maxTemperature}/${day.minTemperature}"), //TODO
          Text("Humidity: ${day.humidity}"), //TODO
          if (day.interesting != null && day.interesting!.isNotEmpty)
            ExpansionTile(
              title: const Text("Interesting"), //TODO
              children: [Text(day.interesting!)],
            )
        ]),
      ),
    );
  }
}
