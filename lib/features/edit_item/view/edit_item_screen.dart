import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:prepare2travel/core/widgets/error_body_widget.dart';
import 'package:prepare2travel/data/models/item.dart';
import 'package:prepare2travel/data/models/travel.dart';
import 'package:prepare2travel/data/repositories/travel_repository.dart';
import 'package:prepare2travel/data/repositories/local_travel_repository.dart';
import 'package:prepare2travel/features/create_travel/widget/error_field.dart';
import 'package:prepare2travel/features/edit_item/bloc/edit_item_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

class EditItemScreen extends StatefulWidget {
  const EditItemScreen({super.key, required this.item, required this.travel});
  final Item? item;
  final Travel travel;

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final EditItemBloc _editItemBloc = EditItemBloc(
      GetIt.I<TravelRepository>(), GetIt.I<LocalTravelRepository>());
  @override
  void initState() {
    _editItemBloc.add(EditItemScreenOpenedEvent(
        initialItem: widget.item, travel: widget.travel));
    super.initState();
  }

  @override
  void dispose() {
    _editItemBloc.add(EditItemScreenDisposedEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditItemBloc, EditItemState>(
      bloc: _editItemBloc,
      builder: (context, state) {
        bool canSave = [
          state.nameErrorMessage,
          state.haveErrorMessage,
          state.neededErrorMessage,
          state.errorMessage
        ].where((element) => element.isNotEmpty).isEmpty;
        String title;
        if (widget.item == null) {
          title = "Create item"; //TODO
        } else {
          title = "Update item"; //TODO
        }
        Widget body;
        if (state.errorMessage.isNotEmpty) {
          body = ErrorBodyWidget(
              bloc: _editItemBloc,
              retryEvent: EditItemScreenOpenedEvent(
                  initialItem: widget.item, travel: widget.travel));
        } else if (state is EditItemLoadedState) {
          body = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  initialValue: state.name,
                  onChanged: (value) =>
                      _editItemBloc.add(ValidateNameEvent(name: value)),
                  decoration: const InputDecoration(labelText: 'Name'), //TODO
                ),
                if (state.nameErrorMessage.isNotEmpty)
                  ErrorField(error: state.nameErrorMessage),
                TextFormField(
                  initialValue: state.have.toString(),
                  onChanged: (value) =>
                      _editItemBloc.add(ValidateHaveEvent(have: value)),
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Have items'), //TODO
                ),
                if (state.haveErrorMessage.isNotEmpty)
                  ErrorField(error: state.haveErrorMessage),
                TextFormField(
                  initialValue: state.needed.toString(),
                  onChanged: (value) =>
                      _editItemBloc.add(ValidateNeededEvent(needed: value)),
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Item required'), //TODO
                ),
                if (state.neededErrorMessage.isNotEmpty)
                  ErrorField(error: state.neededErrorMessage),
                const SizedBox(
                  height: 12,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.save),
                      onPressed: () {
                        if (canSave) {
                          final completer = Completer();
                          _editItemBloc
                              .add(CreateOrSaveEvent(completer: completer));
                          completer.future.then((_) {
                            if ([
                              state.errorMessage,
                              state.haveErrorMessage,
                              state.neededErrorMessage,
                              state.nameErrorMessage
                            ].where((element) => element.isNotEmpty).isEmpty) {
                              context.pop();
                            }
                          });
                        }
                      },
                      label: const Text('Save'), //TODO
                    ),
                    if (widget.item != null)
                      TextButton.icon(
                          onPressed: () {
                            final completer = Completer();
                            _editItemBloc
                                .add(DeleteItemEvent(completer: completer));
                            completer.future.then((actualState) {
                              if (actualState.errorMessage == null ||
                                  actualState.errorMessage!.isEmpty) {
                                context.pop();
                              }
                            });
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text("Delete")) //TODO
                  ],
                ),
                if (!canSave)
                  const ErrorField(
                      error:
                          "Some fields are filled in incorrectly. You can't save the item."),
              ],
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
