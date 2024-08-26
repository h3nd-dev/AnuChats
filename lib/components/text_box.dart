import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/theme_provider.dart';
class TextBox extends StatelessWidget {
  final void Function()? onTap;
  final String memberName;
  final String userDetails;
  const TextBox({super.key, required this.memberName, required this.userDetails, required this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Container(
      decoration: BoxDecoration(
          color: isDarkMode? Colors.grey[500]:Colors.grey[200],
          borderRadius: BorderRadius.circular(8)
      ),
      padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15, top: 15),
      margin: const EdgeInsets.only(left: 20, right: 20,top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(memberName, style: TextStyle(color: isDarkMode? Colors.grey[200]:Colors.grey[500]),),
              GestureDetector(
                onTap: onTap,
                child: Icon(Icons.settings, color: isDarkMode? Colors.grey[200]:Colors.grey[500],),
              )
            ],
          ),
          Text(userDetails, style: TextStyle(color: isDarkMode? Colors.grey[200]:Colors.grey[900]),)
        ],
      ),
    );
  }
}