
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // sign up

  Future<UserCredential> signInWithEmailPassword(
      {required email, required password}) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      // save user details

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }


  Future<UserCredential> signUpWithEmailPassword(
      {required email, required password}) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseFirestore.collection("Users").doc(userCredential.user!.uid).set(
          {
            "uid": userCredential.user!.uid,
            "email": userCredential.user!.email,
            "profileImage":'data:image/png;base64,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',
            "username": userCredential.user!.email!.split("@")[0],
            "bio": "",
         "timeStamp": Timestamp.now()

          });


      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }



  // sign-out
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }


}
