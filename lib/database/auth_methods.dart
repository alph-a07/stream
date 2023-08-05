import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../resources/methods.dart';

class AuthMethods {
  final _userRef = FirebaseFirestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;

// Function to fetch the current user's data from Firestore based on the given uid.
// Returns a Future containing a Map of String keys to dynamic values, or null if the uid is null.
  Future<Map<String, dynamic>?> getCurrentUser(String? uid) async {
    // Check if the uid is not null.
    if (uid != null) {
      // Fetch the user document snapshot from Firestore using the uid.
      final snap = await _userRef.doc(uid).get();

      // Return the data from the snapshot, which is a Map of String keys to dynamic values.
      return snap.data();
    }

    // If uid is null, return null.
    return null;
  }

// Function to sign up a user with provided email, username, and password.
  Future<bool> signUpUser(String email, String username, String password,
      BuildContext context) async {
    bool res = false; // Initialize a flag to track successful sign-up.

    try {
      // Create a user with provided email and password using FirebaseAuth.
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (cred.user != null) {
        // If the user is successfully created, create a UserModel object with dummy data.
        UserModel user = UserModel(
          uid: cred.user!.uid,
          username: username.trim(),
          email: email.trim(),
        );

        // Store the UserModel object in Firestore using the user's unique id (uid).
        await _userRef.doc(cred.user!.uid).set(user.toMap());

        // Access the UserProvider using the Provider package and update the user data.
        Provider.of<UserProvider>(context, listen: false).setUser(user);

        res = true; // Set the flag to true indicating successful sign-up.
      }
    } on FirebaseAuthException catch (e) {
      // If there is an exception during sign-up, show an error message using a SnackBar.
      showSnackBar(context, e.message!);
    }

    return res; // Return the flag indicating the success status of the sign-up process.
  }

// Function to log in a user with the provided email and password.
  Future<bool> loginUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    bool res =
        false; // Variable to store the login result, initialized as false.
    try {
      // Attempt to sign in the user using provided email and password.
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the sign-in was successful and the user object is not null.
      if (cred.user != null) {
        // Fetch the user data and set it in the UserProvider for global access.
        Provider.of<UserProvider>(context, listen: false).setUser(
          UserModel.fromMap(
            await getCurrentUser(cred.user!.uid) ??
                {}, // Fetch user data based on the UID.
          ),
        );

        res =
            true; // Set the login result to true since the user is successfully logged in.
      }
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException if any occurs during the login process.
      showSnackBar(
          context, e.message!); // Display a SnackBar with the error message.
    }
    return res; // Return the login result (true if successful, false if not).
  }
}
