import 'package:chat_app/components/my_drawer.dart';
import 'package:chat_app/service/chats/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/message.dart';
import '../components/user_tile.dart';
import '../service/auth/auth.dart';
import 'chat_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final authService = AuthService();
  final chatServices = ChatService();
  bool isLoading = false;
  bool added = false;

  String? getUser() {
    return authService.auth.currentUser?.email;
  }

  void logout({required BuildContext context}) {
    try {
      authService.signOut();
    } catch (e) {
      error(message: e.toString(), context: context);
    }
  }

  void addUsers({
    required String userId,
    required String userEmail,
    required String userImage,
    required String bio,
  }) {
    setState(() {
      isLoading = true;
    });
    try {
      chatServices.addChat(userId: userId, userEmail: userEmail, userImage: userImage, bio: bio);
      setState(() {
        isLoading = false;
        added = true;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      error(message: e.toString(), context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            title: const Center(child: Text('All Users')),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: _buildUserList(),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: chatServices.getUserDetails(),
      builder: (context, snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshots.hasError) {
          return const Text("Error");
        } else if (snapshots.data == null || snapshots.data!.isEmpty) {
          return const Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("No chats"),
                ),
                Icon(Icons.no_accounts, size: 50),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshots.data!.length,
          itemBuilder: (context, index) {
            var userData = snapshots.data![index];
            if (userData.isEmpty) {
              return const Center(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("No chats"),
                    ),
                    Icon(Icons.no_accounts),
                  ],
                ),
              );
            }
            return _buildUserData(userData, context, index);
          },
        );
      },
    );
  }

  Widget _buildUserData(Map<String, dynamic> userData, BuildContext context, int index) {
    String userId = userData['uid'];
    if (userData['email'] != getUser()) {
      return StreamBuilder<bool>(
        stream: chatServices.isUserAdded(userId: userId),
        builder: (context, snapshot) {
          bool added = snapshot.data ?? false;
          return UserTile(
            subtitle: userData['bio'],
            text: userData['email'] ?? "",
            profileImage: userData['profileImage'] ?? "",
            isUser: true,
            add: () {
              if (!added) {
                addUsers(
                  userId: userId,
                  userEmail: userData['email'],
                  userImage: userData['profileImage'] ?? '',
                  bio: userData['bio'],
                );
              }
            },
            added: added,
            loading: snapshot.connectionState == ConnectionState.waiting,
          );
        },
      );
    } else {
      return Container();
    }
  }
}
