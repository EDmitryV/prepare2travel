import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:prepare2travel/data/models/user.dart';
import 'package:prepare2travel/data/models/user_sex.dart';
import 'package:prepare2travel/data/repositories/api/api_user_repository.dart';
import 'package:prepare2travel/data/repositories/local/local_user_repository.dart';
import 'package:prepare2travel/features/edit_user/bloc/edit_user_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

@RoutePage()
class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key, required this.user});
  final User? user;

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final EditUserBloc _editUserBloc = EditUserBloc(
      GetIt.I<LocalUserRepository>(), GetIt.I<ApiUserRepository>());
  late final FToast _fToast;
  @override
  void initState() {
    _fToast = FToast();
    _editUserBloc.add(EditUserScreenOpenedEvent(initialUser: widget.user));
    super.initState();
  }

  @override
  void dispose() {
    _editUserBloc.add(EditUserScreenDisposedEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditUserBloc, EditUserState>(
      bloc: _editUserBloc,
      builder: (context, state) {
        String title;
        if (state.initialUser == null) {
          title = "User creation"; //TODO
        } else {
          title = "User editing"; //TODO
        }
        Widget body;
        if (state is EditUserDefaultState) {
          if (state.errorMessage != null) {
            _showMessage(state.errorMessage!);
            _editUserBloc.add(EndErrorMessageNotificationEvent());
          }
          body = Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Choose your sex', //TODO
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 10.0),
                  Wrap(
                    spacing: 5.0,
                    children: List<Widget>.generate(
                      3,
                      (int index) {
                        return ChoiceChip(
                          label: Text(UserSex.getByValue(index).displayName),
                          selected: state.user.sex.value == index,
                          onSelected: (bool selected) {
                            _editUserBloc.add(
                                UpdateSexEvent(sex: UserSex.getByValue(index)));
                          },
                        );
                      },
                    ).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.save),
                        onPressed: () {
                          final completer = Completer();
                          _editUserBloc
                              .add(CreateOrUpdateEvent(completer: completer));
                          completer.future.then((actualState) {
                            if (actualState.errorMessage == null ||
                                actualState.errorMessage!.isEmpty) {
                              AutoRouter.of(context).pop();
                            }
                          });
                        },
                        label: const Text('Save'), //TODO
                      ),
                    ],
                  )
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
                onPressed: () => Navigator.of(context).pop()),
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

  _showMessage(String message) {
    _fToast.init(context);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Theme.of(context).colorScheme.error,
      ),
      child: Text(message),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fToast.showToast(
        child: toast,
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 3),
      );
    });
  }
}
