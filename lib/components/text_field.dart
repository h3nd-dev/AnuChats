import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/theme_provider.dart';

class MyTextField extends StatelessWidget {
  final bool obscureText;
  final TextEditingController controller;
  final String hintText;
  final FocusNode? focusNode;
  const MyTextField({super.key, required this.obscureText, required this.controller, required this.hintText, this.focusNode});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return TextField(
      focusNode: focusNode,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
          ),


        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),


        ),
        fillColor: Theme.of(context).colorScheme.secondary,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: isDarkMode?Colors.grey[400]:Theme.of(context).colorScheme.primary, fontSize: 12)
      ),


    );
  }
}
