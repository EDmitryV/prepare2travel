import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ErrorBodyWidget<Event> extends StatelessWidget {
  final Bloc bloc;
  final Event retryEvent;
  const ErrorBodyWidget({super.key, required this.bloc, required this.retryEvent});

  @override
  Widget build(BuildContext context) {
    return Center(
              child: Card(
                  child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Column(children: [
              Text("Something went wrong, please try again later"),//TODO translate
              FilledButton.icon(
                  onPressed: () {
                    bloc.add(retryEvent);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text("Retry"))//TODO translate
            ]),
          )));
  }
}
