import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream/models/user.dart';
import 'package:stream/providers/user_provider.dart';
import 'package:stream/resources/colors.dart';
import 'package:stream/screens/home.dart';
import 'package:stream/screens/login.dart';
import 'package:stream/screens/onboarding.dart';
import 'package:stream/screens/signup.dart';
import 'package:stream/widgets/loading_indicator.dart';

import 'database/auth_methods.dart';

void main() async {
  // Make sure Flutter is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Run the app by wrapping it with MultiProvider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// Main app class
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the app with MultiProvider to allow access to the UserProvider throughout the app
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      // Create a MaterialApp to define the app's title, theme, and routes
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stream',

        // Define the app's theme
        theme: ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: backgroundColor,
          appBarTheme: AppBarTheme.of(context).copyWith(
            backgroundColor: backgroundColor,
            elevation: 0,
            titleTextStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            iconTheme: const IconThemeData(color: primaryColor),
          ),
        ),

        // Define the routes for different screens
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

        // Define the home screen using FutureBuilder to handle async operations
        home: FutureBuilder(
          future: AuthMethods()
              .getCurrentUser(
            FirebaseAuth.instance.currentUser != null
                ? FirebaseAuth.instance.currentUser!.uid
                : null,
          )
              .then((value) {
            if (value != null) {
              // Set the user using UserProvider if user data is available
              Provider.of<UserProvider>(context, listen: false).setUser(
                UserModel.fromMap(value),
              );
            }
            return value;
          }),

          // Build the home screen based on the FutureBuilder snapshot
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while waiting for the data
              return const LoadingIndicator();
            }

            if (snapshot.hasData) {
              // If user data is available, show the Home screen
              return const Home();
            }

            // If no user data is available, show the Onboarding screen
            return const Onboarding();
          },
        ),
      ),
    );
  }
}
