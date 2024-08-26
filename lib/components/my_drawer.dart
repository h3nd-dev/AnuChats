import 'package:chat_app/service/auth/auth.dart';
import 'package:chat_app/views/my_homepage.dart';
import 'package:chat_app/views/settings.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // logo

          Column(

              children: [
            DrawerHeader(
                child: Icon(
              Icons.message,
              size: 62,
              color: Theme.of(context).colorScheme.primary,
            )),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                title: Text("H O M E"),
                leading: Icon(Icons.home),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const MyHomePage()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                title: Text("S E T T I N G S"),
                leading: Icon(Icons.settings),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const Settings()));
                },
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              title: Text("L O G O U T"),
              leading: Icon(Icons.logout),
              onTap: () {
                final authservice = AuthService();
                authservice.signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}
