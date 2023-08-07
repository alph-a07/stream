import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseStorage _storage =
      FirebaseStorage.instance; // Creating an instance of FirebaseStorage

  Future<String> uploadImageToStorage(
      String childName, Uint8List file, String uid) async {
    // Creating a reference to the storage location
    Reference ref = _storage.ref().child(childName).child(uid);

    // Initiating an upload task with the provided data
    UploadTask uploadTask = ref.putData(file);

    // Waiting for the upload task to complete and getting a snapshot
    TaskSnapshot snapshot = await uploadTask;

    // Getting the download URL for the uploaded file
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl; // Returning the download URL as a String
  }
}
