import 'package:chat_app/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/theme_provider.dart';

class UserTile extends StatelessWidget {
  final String text;
  final String subtitle;
  final String profileImage;
  final bool isUser;
  final bool added;
  final bool loading;

  final void Function()? onTap;
  final void Function()? onLongPress;
  final void Function()? add;

  const UserTile(
      {super.key,
      required this.text,
      this.onTap,
      required this.profileImage,
      required this.isUser,
      this.add,
      required this.added,
      required this.loading, required this.subtitle, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    backgroundImage: profileImage.isNotEmpty
                        ? loadImage(profileImage)
                        : AssetImage(
                            isDarkMode
                                ? 'assets/—Pngtree—gallery vector icon_3791336-01.png'
                                : 'assets/—Pngtree—gallery vector icon_37913362-01.png',
                          ),
                    radius: 30,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(text, style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),),
                      SizedBox(height: 10,),
                      Text(subtitle,style: const TextStyle(
                          fontSize: 12
                      ), )
                    ],
                  ),
                ],
              ),
              isUser
                  ? GestureDetector(
                      onTap: add,
                      child: Container(
                        height: 50,
                        width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.green,
                        ),
                        child: loading
                            ? const Center(child: CircularProgressIndicator())
                            : added
                                ? const Center(
                            child: Icon(Icons.check_circle,
                              color: Colors.white,
                              size: 30,

                        ))
                                : const Center(child: Text('Add user',style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),)),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
