import 'package:flutter/material.dart';
import 'package:prepare2travel/features/authentication/widgets/sign_up_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: const [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Icon(
                Icons.person_add,
                size: 200,
              ),
            ),
            Center(
                child: Text(
              "Signup",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: 10,
            ),
            SignUpForm(),
          ],
        ),
      ),
    );
  }
}
