import 'package:flutter/material.dart';
import 'package:stream/resources/colors.dart';
import 'package:stream/screens/login.dart';
import 'package:stream/screens/onboarding.dart';
import 'package:stream/screens/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stream',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: backgroundColor,
          appBarTheme: AppBarTheme.of(context).copyWith(
              backgroundColor: backgroundColor,
              elevation: 0,
              titleTextStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              iconTheme: const IconThemeData(color: primaryColor))),
      routes: {
        Onboarding.route: (context) => const Onboarding(),
        Login.route: (context) => const Login(),
        Signup.route: (context) => const Signup(),
      },
      home: const Onboarding(),
    );
  }
}
