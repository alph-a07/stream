import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream/database/storage_methods.dart';
import 'package:uuid/uuid.dart';

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
        if (!((await _firestore.collection('livestream').doc('${provider.user.uid}${provider.user.username}').get())
            .exists)) {
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

          _firestore
              .collection('livestream')
              .doc(channelId)
              .set(liveStream.toMap()); // Storing LiveStream data in Firestore
        } else {
          showSnackBar(context, 'You are already live!'); // Showing a snackbar if user is already live
        }
      } else {
        // Showing a snack bar for missing fields
        if (title.isEmpty && image != null) {
          showSnackBar(context, 'Please enter a title.');
        } else if (image == null && title.isEmpty) {
          showSnackBar(context, 'Please select a thumbnail image.');
        } else {
          showSnackBar(context, 'Select thumbnail and title before starting the stream.');
        }
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message!); // Handling Firebase exceptions and showing error snackbar
    }

    return channelId; // Returning channelId
  }

  Future<void> endLiveStream(String channelId, BuildContext context) async {
    try {
      QuerySnapshot snap = await _firestore.collection('livestream').doc(channelId).collection('comments').get();

      for (int i = 0; i < snap.docs.length; i++) {
        await _firestore
            .collection('livestream')
            .doc(channelId)
            .collection('comments')
            .doc(
              ((snap.docs[i].data()! as dynamic)['commentId']),
            )
            .delete();
      }
      await _firestore.collection('livestream').doc(channelId).delete();

      showSnackBar(context, 'Live stream has ended!');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateViewCount(String id, bool isIncrease) async {
    try {
      await _firestore.collection('livestream').doc(id).update({
        'viewers': FieldValue.increment(isIncrease ? 1 : -1),
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> chat(String text, String channelId, BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false);

    try {
      String commentId = const Uuid().v1();
      await _firestore.collection('livestream').doc(channelId).collection('comments').doc(commentId).set({
        'username': user.user.username,
        'message': text,
        'uid': user.user.uid,
        'createdAt': DateTime.now(),
        'commentId': commentId,
      });
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message!);
    }
  }
}
