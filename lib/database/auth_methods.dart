import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/user.dart';
import '../resources/methods.dart';

class AuthMethods {
  final _userRef = FirebaseFirestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> getCurrentUser(String? uid) async {
    if (uid != null) {
      final snap = await _userRef.doc(uid).get();
      return snap.data();
    }
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
          uid: 'user_id_1',
          username: 'john_doe',
          email: 'john.doe@example.com',
        );

        // Store the UserModel object in Firestore using the user's unique id (uid).
        await _userRef.doc(cred.user!.uid).set(user.toMap());

        res = true; // Set the flag to true indicating successful sign-up.
      }
    } on FirebaseAuthException catch (e) {
      // If there is an exception during sign-up, show an error message using a SnackBar.
      showSnackBar(context, e.message!);
    }

    return res; // Return the flag indicating the success status of the sign-up process.
  }
}
