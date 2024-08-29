import 'package:chat_app/components/message.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/text_field.dart';
import 'package:flutter/material.dart';

import '../service/auth/auth.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final authService = AuthService();
  bool isLoading = false;

  void register({required BuildContext context}) async {
    if (passwordController.text != confirmPasswordController.text) {
      error(message: "Password don\'t match", context: context);
      return;
    }
    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        emailController.text.isEmpty) {
      error(message: "All fields are required", context: context);
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });
      final userCredential = await authService.signUpWithEmailPassword(
          email: emailController.text, password: passwordController.text);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (context.mounted) {
        error(message: e.toString(), context: context);
      }
    }
  }

  FocusNode focusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  ScrollController scrollController =ScrollController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    focusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  void scrollToFocusedTextField(FocusNode focusNode) {
    // Use Future.delayed to ensure that the scroll happens after the keyboard is fully open
    Future.delayed(const Duration(milliseconds: 300), () {
      scrollController.animateTo(
        scrollController.position.pixels + 50, // Adjust this value as needed
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Visibility(
          visible: !isLoading,
          replacement: const Center(child: CircularProgressIndicator()),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: SingleChildScrollView(
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
                        'Let\'s create an account',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16),
                      ),
                    ),

                    //  Email TextField

                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: MyTextField(
                          obscureText: false,
                          focusNode: emailFocusNode,
                          controller: emailController,
                          onTap: ()=> scrollToFocusedTextField(emailFocusNode),
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            // Move focus to the next TextField
                            FocusScope.of(context).requestFocus(passwordFocusNode);
                          },
                          hintText: 'Enter your email'),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: MyTextField(
                          obscureText: true,
                          focusNode: passwordFocusNode,
                          controller: passwordController,
                          textInputAction: TextInputAction.next,
                          onTap: ()=> scrollToFocusedTextField(passwordFocusNode),
                          onEditingComplete: () {
                            // Move focus to the next TextField
                            FocusScope.of(context).requestFocus(passwordFocusNode);
                          },
                          hintText: 'Enter your password'),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: MyTextField(
                        focusNode: focusNode,
                          obscureText: true,
                          controller: confirmPasswordController,
                          textInputAction: TextInputAction.next,
                          onTap: ()=> scrollToFocusedTextField(focusNode),
                          onEditingComplete: () {
                            // Move focus to the next TextField
                            FocusScope.of(context).requestFocus(focusNode);
                          },
                          hintText: 'Confirm your password'),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: MyButton(
                        text: "Register",
                        onTap: () => register(context: context),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
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
                            'Login now',
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
      ),
    );
  }
}
