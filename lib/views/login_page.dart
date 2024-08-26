import 'dart:developer';

import 'package:chat_app/components/message.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/text_field.dart';
import 'package:chat_app/service/auth/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();
  bool isLoading = false;
  void login({required BuildContext context}) async {
    setState(() {
      isLoading = true;
    });
    try {
      final userCredential = await authService.signInWithEmailPassword(
          email: emailController.text, password: passwordController.text);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (context.mounted){
        error(message: e.toString(), context: context) ;
        log(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Visibility(
          visible: !isLoading,
          replacement:  const Center(child: CircularProgressIndicator()),

          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // logo
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Icon(
                      Icons.message,
                      size: 60,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  // welcome back message

                  Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Text(
                      'Welcome back you have been missed',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: MyTextField(
                        obscureText: false,
                        controller: emailController,
                        hintText: 'Enter your email'),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: MyTextField(
                        obscureText: true,
                        controller: passwordController,
                        hintText: 'Enter your password'),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: MyButton(
                      text: "Login",
                      onTap: ()=> login(context: context),
                    ),
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member yet?',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Register now',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
