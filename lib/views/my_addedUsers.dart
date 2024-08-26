import 'package:chat_app/components/my_alerts.dart';
import 'package:chat_app/components/my_drawer.dart';
import 'package:chat_app/service/chats/chat_service.dart';
import 'package:chat_app/views/my_homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/message.dart';
import '../components/user_tile.dart';
import '../service/auth/auth.dart';
import 'chat_page.dart';

class MyAddedUsers extends StatefulWidget {
  const MyAddedUsers({super.key});

  @override
  State<MyAddedUsers> createState() => _MyAddedUsersState();
}

class _MyAddedUsersState extends State<MyAddedUsers> {
  final authService = AuthService();
  final chatServices = ChatService();

  String? getUser (){
    return authService.auth.currentUser!.email;
  }
  void logout ({required BuildContext context}){
    try{
      authService.signOut();
    }catch(e){
      error(message: e.toString(), context: context) ;
    }


  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatServices.syncUserProfiles();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Center(child: Text('My Chats')),


      ),
      drawer: const MyDrawer(),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        child: _buildUserList(),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const MyHomePage()));
      },
        child: Icon(Icons.add),

      ),
    );
  }

  Widget _buildUserList (){
    return StreamBuilder(
        stream: chatServices.getMyUserDetails(),
        builder: (context, snapshots){
          // has error

          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show a loading spinner while waiting
          }  else if (snapshots.hasError){
            return const Text("Error");
          }else if (snapshots.data!.isEmpty){
            return const Center(child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("No chats"),
                ),
                Icon(Icons.no_accounts, size: 50,),
              ],
            ));

          }

          return ListView.builder(
            itemCount: snapshots.data!.length,
            itemBuilder: (context, index) {
              var userData = snapshots.data?[index];
              if (userData == null){
                return const Center(child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("No chats"),
                    ),
                    Icon(Icons.no_accounts),
                  ],
                ));

              }
              return _buildUserData(userData, context, index);
            },
          );
        });
  }

  Widget _buildUserData (Map<String, dynamic> userData, BuildContext context, int index){



   if (  userData['email'] != getUser()){
     print(getUser());
     return UserTile(text:  userData['email'], onTap: (){
       
       Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatPage(receiversEmail: userData['email'], receiverId: userData['uid'],)));
     }, profileImage: userData['profileImage'] ?? '',subtitle: userData['bio'], isUser: false, added: false, loading: false,

     );

   }else {
     return Container();
   }

}
}
