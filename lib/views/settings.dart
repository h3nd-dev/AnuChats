import 'dart:io';

import 'package:chat_app/service/auth/profile/profile.dart';
import 'package:chat_app/theme/theme_provider.dart';
import 'package:chat_app/views/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../image_helper.dart';
import '../service/chats/chat_service.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  ChatService chatService = ChatService();
  ProfileService profileService = ProfileService();
   File? image;
   final picker = ImagePicker();

   Future<void> pickImage(userId)async {
     try{
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          image = File(pickedFile.path);
        }
      });

      if (image != null) {
        profileService.uploadImage(image: image, userId: userId);
      }
    }catch(e){
       print(e.toString());
     }
  }

  @override
  Widget build(BuildContext context) {

    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Settings')),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Circular Avatar for profile picture
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey, // Default background color
            child: StreamBuilder(
              stream: chatService.myDetails(),
              builder: (context, snapshot) {
                final userData = snapshot.data?.data() as Map<String, dynamic>?;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show a loader while waiting for the stream
                } else if (snapshot.hasError) {
                  return const Icon(Icons.error, size: 50, color: Colors.red); // Show an error icon if the stream fails
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const Icon(Icons.person, size: 50, color: Colors.white), // Placeholder icon if no data
                      GestureDetector(
                        onTap: () {
                          pickImage(userData?['uid']); // Handle image picking
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Icon(Icons.camera_alt, size: 30, color: Colors.blue),
                        ),
                      ),
                    ],
                  );
                } else {


                  if (userData == null || userData.isEmpty) {
                    return Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        const Icon(Icons.person, size: 50, color: Colors.white), // Placeholder icon if no user data
                        GestureDetector(
                          onTap: () {
                            pickImage(userData?['uid']); // Handle image picking
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(17.0),
                            child: Icon(Icons.camera_alt, size: 30, color: Colors.blue),
                          ),
                        ),
                      ],
                    );
                  }

                  final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

                  return Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: userData['profileImage'] != null
                            ? loadImage(userData['profileImage'])
                            : AssetImage(isDarkMode
                            ? 'assets/—Pngtree—gallery vector icon_37913362-01.png'
                            : 'assets/—Pngtree—gallery vector icon_3791336-01.png') as ImageProvider,
                      ),
                      GestureDetector(
                        onTap: () {
                          pickImage(userData['uid']); // Handle image picking
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Icon(Icons.camera_alt, size: 30, color: Colors.blue),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),


          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.all(29),
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Profile'),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(15)),
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dark Mode'),
                CupertinoSwitch(
                    value: Provider.of<ThemeProvider>(context, listen: false)
                        .isDarkMode,
                    onChanged: (value) {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme();
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
