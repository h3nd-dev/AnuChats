import 'package:chat_app/service/auth/auth_page.dart';
import 'package:chat_app/service/chats/chat_service.dart';
import 'package:chat_app/theme/light_mode.dart';
import 'package:chat_app/theme/theme_provider.dart';
import 'package:chat_app/views/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context)=> ThemeProvider() ,

      child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const Splashscreen(),
    );
  }
}
