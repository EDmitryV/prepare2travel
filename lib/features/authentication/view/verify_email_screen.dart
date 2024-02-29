import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prepare2travel/features/authentication/bloc/auth_bloc.dart';
import 'package:prepare2travel/features/travels_list/view/travels_list_screen_dart.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  @override
  void initState() {
    BlocProvider.of<AuthBloc>(context).add(CheckEmailVerificationEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(50),
                child: Icon(
                  Icons.mail_lock,
                  size: 140,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Verify your E-Mail address',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ), //TODO translate
              ),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (BuildContext context, AuthState state) {
                  if (state is EmailIsVerifiedState) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => const TravelsListScreen()));
                  }
                },
                builder: (context, state) {
                  if (state is EmailIsSentState) {
                    return const Center(
                        child: Text(
                      'A verification email has been dispatched; kindly verify your account to proceed.',
                      textAlign: TextAlign.center,
                    )); //TODO translate
                  } else if (state is ErrorAuthState) {
                    return Center(
                        child: Text(state.message,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center));
                  } else {
                    return const Center(
                        child: Text('Sending verification email...',
                            textAlign: TextAlign.center)); //TODO translate
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Did not receive any email?"), //TODO translate
                  TextButton(
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context)
                            .add(SendEmailVerificationEvent());
                      },
                      child: const Text("resend email")) //TODO translate
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
