import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String messageId;
  final String? senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timeStamp;

  Message( {required this.messageId,required this.senderId, required this.senderEmail, required this.receiverId, required this.message, required this.timeStamp});


  Map<String,dynamic> toMap (){
    return ({
      "senderId":senderId,
      "senderEmail":senderEmail,
      "receiverId":receiverId,
      "message":message,
      "timeStamp":timeStamp,
      "messageId":messageId
    });
  }

}