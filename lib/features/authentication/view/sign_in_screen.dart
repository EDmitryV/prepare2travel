import 'package:flutter/material.dart';
import 'package:prepare2travel/features/authentication/widgets/sign_in_form.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: const [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Icon(
                Icons.key,
                size: 200,
              ),
            ),
            Center(
                child: Text(
              "Login",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: 10,
            ),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}
