import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream/database/storage_methods.dart';

import '../models/live_stream.dart';
import '../providers/user_provider.dart';
import '../resources/methods.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
  final StorageMethods _storageMethods = StorageMethods(); // Storage methods instance

  Future<String> startLiveStream(BuildContext context, String title, Uint8List? image) async {
    final provider = Provider.of<UserProvider>(context, listen: false); // Accessing UserProvider using Provider

    String channelId = ''; // Initializing channelId

    try {
      if (title.isNotEmpty && image != null) {
        if (!((await _firestore.collection('livestream').doc('${provider.user.uid}${provider.user.username}').get()).exists)) {
          // Checking if the user is not already live
          String thumbnailUrl = await _storageMethods.uploadImageToStorage(
            'livestream-thumbnails',
            image,
            provider.user.uid,
          ); // Uploading image to storage

          channelId = '${provider.user.uid}${provider.user.username}'; // Generating channelId

          LiveStream liveStream = LiveStream(
            title: title,
            image: thumbnailUrl,
            uid: provider.user.uid,
            username: provider.user.username,
            viewers: 0,
            channelId: channelId,
            startedAt: DateTime.now(),
          ); // Creating a LiveStream object

          _firestore.collection('livestream').doc(channelId).set(liveStream.toMap()); // Storing LiveStream data in Firestore
        } else {
          showSnackBar(context, 'You are already live!'); // Showing a snackbar if user is already live
        }
      } else {
        // Showing a snack bar for missing fields
        if (title.isEmpty) showSnackBar(context, 'Please enter a title.');
        if (image == null) showSnackBar(context, 'Please select a thumbnail image.');
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message!); // Handling Firebase exceptions and showing error snackbar
    }

    return channelId; // Returning channelId
  }
}
