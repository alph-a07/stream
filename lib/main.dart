import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream/providers/user_provider.dart';
import 'package:stream/resources/colors.dart';
import 'package:stream/screens/home.dart';
import 'package:stream/screens/login.dart';
import 'package:stream/screens/onboarding.dart';
import 'package:stream/screens/signup.dart';
import 'package:stream/widgets/loading_indicator.dart';

import 'database/auth_methods.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
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
          // Route for the onboarding screen
          Login.route: (context) => const Login(),
          // Route for the login screen
          Signup.route: (context) => const Signup(),
          // Route for the signup screen
          Home.route: (context) => const Home(),
          // Route for the home screen
        },
        home: FutureBuilder(
          // A FutureBuilder widget to fetch the current user's data
          future: AuthMethods()
              .getCurrentUser(
            FirebaseAuth.instance.currentUser != null
                ? FirebaseAuth.instance.currentUser!.uid
                : null,
          )
              .then((value) {
            print('Value : $value');

            // Once the user data is fetched, this function is called
            if (value != null) {
              // If the user data is not null, set the user in the UserProvider using the fetched data
              Provider.of<UserProvider>(context, listen: false).setUser(
                UserModel.fromMap(value),
              );

              print('Email : ${Provider.of<UserProvider>(context).user.email}');
            }
            print('Email : ${Provider.of<UserProvider>(context).user.email}');
            return value; // Return the fetched user data to the FutureBuilder
          }),
          builder: (context, snapshot) {
            // The builder function is called when the Future completes or updates
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingIndicator(); // While waiting for the future to complete, display a loading indicator
            }

            print('Snapshot : ${snapshot.data}');

            if (snapshot.hasData) {
              return const Home(); // If the snapshot has data (user data was fetched successfully), show the home screen
            }

            return const Onboarding(); // If no user data was fetched, show the onboarding screen
          },
        ),
      ),
    );
  }
}
