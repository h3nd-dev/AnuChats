import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // get user details

  Stream<List<Map<String, dynamic>>> getUserDetails() {
    return firebaseFirestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getMyUserDetails() {
    final currentUserId = firebaseAuth.currentUser!.uid;
    return firebaseFirestore
        .collection("MyUsers")
        .doc(currentUserId)
        .collection("addedUsers")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Stream<DocumentSnapshot> myDetails() {
    return firebaseFirestore
        .collection("Users")
        .doc(firebaseAuth.currentUser!.uid)
        .snapshots();
  }

  Future<void> addChat({
    required String userId,
    required String userEmail,
    required String userImage,
    required String bio,
  }) async {
    try {
      final currentUserId = firebaseAuth.currentUser!.uid;

      final user = ({
        "uid": userId,
        "email": userEmail,
        "profileImage": userImage,
        "success": true,
        "bio": bio,
      });

      await firebaseFirestore
          .collection("MyUsers")
          .doc(currentUserId)
          .collection("addedUsers")
          .add(user);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // send message

  Future<void> sendMessage(
      {required String receiverId, required String message}) async {
    final currentUid = firebaseAuth.currentUser!.uid;
    final currentUserEmail = firebaseAuth.currentUser!.email;
    Timestamp timeStamp = Timestamp.now();
    var uuid = Uuid();
    String reportId = uuid.v4();
   List<String> myMessageId = [reportId,currentUid];
   myMessageId.sort();
   final messageId = myMessageId.join("_");

    // create new message

    Message newMessage = Message(
        senderId: currentUid,
        messageId:messageId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        timeStamp: timeStamp);

    // create ids for chat room

    List<String> ids = [currentUid, receiverId];
    ids.sort();

    String chatRoomId = ids.join("_");

    // add new message to data base
   await firebaseFirestore
        .collection("Chat_room")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(
      {required String receiverId, required String currentUid}) {
    List<String> ids = [currentUid, receiverId];
    ids.sort();

    String chatRoomId = ids.join("_");
    return firebaseFirestore
        .collection("Chat_room")
        .doc(chatRoomId)
        .collection('messages')
        .orderBy("timeStamp", descending: false)
        .snapshots();
  }

  // report user

  Future<void> report(
      {required String messageId, required String userId}) async {
    final report = ({
      "reportBy": firebaseAuth.currentUser!.uid,
      "messageId": messageId,
      "messageOwnerId": userId,
      "timeStamp": Timestamp.now()
    });

    await firebaseFirestore.collection("report").add(report);
  }

  Future<void> blockUser({required String blockedUserId}) async {
    final currentUserId = firebaseAuth.currentUser!.uid;

    await firebaseFirestore
        .collection("Users")
        .doc(currentUserId)
        .collection('BlockedUser')
        .doc(blockedUserId)
        .set({"blocked": true});
  }

  Stream<bool> getBlockedUsers({required String blockedUserId}) {
    final currentUserId = firebaseAuth.currentUser!.uid;
    return firebaseFirestore
        .collection("Users")
        .doc(currentUserId)
        .collection('BlockedUser')
        .doc(blockedUserId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data()?["blocked"] == true) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<void> syncUserProfiles() async {
    try {
      final currentUserId = firebaseAuth.currentUser!.uid;

      final usersSnapshot = await firebaseFirestore.collection("Users").get();
      for (var userDoc in usersSnapshot.docs) {
        final userData = userDoc.data();
        final userId = userData['uid'];
        final userProfileImage = userData['profileImage'];
        final bio = userData['bio'];
        print("User Bio: $bio");

        final myUserSnapshot = await firebaseFirestore
            .collection("MyUsers")
            .doc(currentUserId)
            .collection("addedUsers")
            .where("uid", isEqualTo: userId)
            .get();

        for (var myUserDoc in myUserSnapshot.docs) {
          final myUserData = myUserDoc.data();
          print("MyUser Data: $myUserData");
          final currentBio = myUserData['bio'] ?? '';

          if (myUserData['profileImage'] != userProfileImage) {
            // Update profile image in MyUsers
            await firebaseFirestore
                .collection("MyUsers")
                .doc(currentUserId)
                .collection("addedUsers")
                .doc(myUserDoc.id)
                .update({
              "profileImage": userProfileImage,
            });
          }

          if (currentBio != bio) {
            // Update bio in MyUsers
            await firebaseFirestore
                .collection("MyUsers")
                .doc(currentUserId)
                .collection("addedUsers")
                .doc(myUserDoc.id)
                .update({
              "bio": bio,
            });
          }
        }
      }
    } catch (e) {
      print("Error syncing user profiles: ${e.toString()}");
    }
  }

  Stream<bool> isUserAdded({required String userId}) {
    final currentUserId = firebaseAuth.currentUser!.uid;
    return firebaseFirestore
        .collection("MyUsers")
        .doc(currentUserId)
        .collection("addedUsers")
        .where("uid", isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.isNotEmpty;
    });
  }

  Future<void> unBlockUser({required String blockedUserId}) async {
    final currentUserId = firebaseAuth.currentUser!.uid;

    await firebaseFirestore
        .collection("Users")
        .doc(currentUserId)
        .collection('BlockedUser')
        .doc(blockedUserId)
        .delete();
  }
}
