import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class ProfileService extends ChangeNotifier{
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> uploadImage({required File? image, required String userId}) async {
    if (image == null) {
      throw Exception("Error uploading image: File is null");
    }

    try {
      final storageRef = _firebaseStorage
          .ref()
          .child("images/${image.path.split('/').last}");

      final uploadImage = storageRef.putFile(image);

      await uploadImage.whenComplete(() async {
        final downloadUrl = await storageRef.getDownloadURL();
        await firebaseFireStore
            .collection("Users")
            .doc(auth.currentUser!.uid)
            .update({"profileImage": downloadUrl});

        final userSnapshot = await firebaseFireStore.collection('MyUsers').where("uid", isEqualTo: userId).get();

        if (userSnapshot.docs.isNotEmpty) {
          // User exists, update profile image
          final docId = userSnapshot.docs.first.id;
          await firebaseFireStore.collection("MyUsers").doc(docId).update({
            "profileImage": downloadUrl, // Update with new image URL or keep existing one
          });
        }



      });
    } on FirebaseAuthException catch (e) {
      throw Exception("Authentication error: ${e.code}");
    } on FirebaseException catch (e) {
      throw Exception("Firebase error: ${e.code} - ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: ${e.toString()}");
    }
  }


}