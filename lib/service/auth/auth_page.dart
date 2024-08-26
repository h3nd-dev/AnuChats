
import 'package:chat_app/views/login_register.dart';
import 'package:chat_app/views/my_addedUsers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../views/my_homepage.dart';
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if (snapshot.hasData){
            return const MyAddedUsers();
          } else {
            return const LoginOrRegister();
          }

        }
    );
  }
}
