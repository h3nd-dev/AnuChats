
import 'package:chat_app/components/text_box.dart';
import 'package:chat_app/service/chats/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ProfilePage extends StatefulWidget {

  const ProfilePage({super.key, });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  ChatService chatService = ChatService();
  final userCollections = FirebaseFirestore.instance.collection('Users');
  Future<void> editDetails (String field) async {
    String newValue = '';
    await  showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text ('Edit your ${field.toUpperCase()}',
          style: TextStyle(color: Colors.grey[300]),),
        content: TextField(
          autofocus: true,
          style: TextStyle(
              color: Colors.grey[300]
          ),
          decoration: InputDecoration(
              hintText: 'Enter a new $field',
              hintStyle: TextStyle(color: Colors.grey)
          ),
          onChanged: (value){
            newValue = value;
          },
        ),
        actions: [
          // cancel button and save button
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: Colors.grey[300]),)),
          TextButton(onPressed: ()=> Navigator.of(context).pop(newValue), child: Text('Save', style: TextStyle(color: Colors.grey[300]),)),
        ],

      );

    });

    if (newValue.trim().isNotEmpty){
      // only upfate the firestore textfield

      await userCollections.doc(currentUser.uid!).update({field:newValue});


    }

  }
  Future<void> EditBio (String Bio) async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: const Center(child: Text('Profile Page')),
        ),
        body: StreamBuilder(
          stream: chatService.myDetails(),
          builder: (context, snapshot){
            if (snapshot.hasData){
              // get user data
              final userData = snapshot.data?.data() as Map<String, dynamic>?;

              final bio = userData?['bio'] ?? "";
              final username = userData?['username'] ?? "";



              return ListView(
                children: [

                  const SizedBox(height: 50,),
                  // user details
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text('My Details', style: TextStyle(color: Colors.grey[600]),),
                  ),
                  TextBox(memberName:'username' , userDetails: username,
                      onTap: ()=> editDetails('username')),
                  TextBox(memberName: 'bio', userDetails: bio,
                    onTap: ()=> editDetails('bio'),),
                  const SizedBox(height: 25,),





                  //username
                  // bio

                  // user post
                ],
              );

            } else if (snapshot.hasError){
              return Center(child: Text('Error: ${snapshot.hasError.toString()}'),);
            } else {
              return const Center(child: CircularProgressIndicator(),);
            }
          },
        )
    );
  }
}