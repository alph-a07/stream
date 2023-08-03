import 'package:flutter/material.dart';
import 'package:stream/screens/login.dart';
import 'package:stream/screens/signup.dart';
import 'package:stream/widgets/custom_button.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  static const route = "/onboarding";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to \n Stream',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: CustomButton(
                onTap: () {
                  Navigator.pushNamed(context, Login.route);
                },
                text: 'Log In',
              ),
            ),
            CustomButton(
              onTap: () {
                Navigator.pushNamed(context, Signup.route);
              },
              text: 'Sign Up',
            ),
          ],
        ),
      ),
    );
  }
}
