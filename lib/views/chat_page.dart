import 'dart:developer';

import 'package:chat_app/components/message.dart';
import 'package:chat_app/components/my_alerts.dart';
import 'package:chat_app/components/text_field.dart';
import 'package:chat_app/theme/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/auth/auth.dart';
import '../service/chats/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiversEmail;
  final String receiverId;
  const ChatPage(
      {super.key, required this.receiversEmail, required this.receiverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FocusNode focusNode = FocusNode();

  final authService = AuthService();
  final chatServices = ChatService();
  final messageController = TextEditingController();

  void sendMessage({required String blockedUserId}) async {
    final blocked =
        await chatServices.getBlockedUsers(blockedUserId: blockedUserId).first;
    if (blocked == true) {}
    if (messageController.text.isNotEmpty) {
      await chatServices.sendMessage(
          receiverId: widget.receiverId, message: messageController.text);

      messageController.clear();
      scrollDown();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
    focusNode.dispose();
  }

  // focus controller
  final ScrollController scrollController = ScrollController();

  void scrollDown() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  void onBlock() async {
    try {
      await chatServices.blockUser(blockedUserId: widget.receiverId);
    } catch (e) {
      log(e.toString());
    }
  }

  void onUnBlock() async {
    try {
      await chatServices.unBlockUser(blockedUserId: widget.receiverId);
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.receiversEmail),
            GestureDetector(
                onTap: () {
                  showActionDialog(
                      context: context, onBlock: onBlock, onUnBlock: onUnBlock);
                },
                child: Icon(Icons.more_vert_rounded))
          ],
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _buildInputText(
                onTap: () => sendMessage(blockedUserId: widget.receiverId))
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
        stream: chatServices.getMessages(
            receiverId: widget.receiverId,
            currentUid: chatServices.firebaseAuth.currentUser!.uid),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Show a loading spinner while waiting
          } else if (snapshots.hasError) {
            return const Text("Error");
          }

          return ListView(
            controller: scrollController,
            children:
                snapshots.data!.docs.map((doc) => _builditemData(doc)).toList(),
          );
        });
  }

  Widget _builditemData(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser =
        FirebaseAuth.instance.currentUser!.uid == data['senderId'];
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final reportController = TextEditingController();

    return Row(
      mainAxisAlignment:
          isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: GestureDetector(
            onLongPress: () => showReportForm(
                context: context,
                reportController: reportController,
                onPressed: () {
                 try {
                    chatServices.report(
                        messageId: data['messageId'],
                        userId: data['receiverId']);
                    showMessage(message: "Message reported successfully", context: context);
                  }catch(e){
                   error(message: e.toString(), context: context);

                 }
                }),
            child: IntrinsicWidth(
              child: Container(
                  constraints: const BoxConstraints(maxWidth: 230),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      color: isCurrentUser
                          ? isDarkMode
                              ? Colors.green
                              : Colors.grey[400]
                          : Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    data['message'],
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black),
                  )),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputText({required void Function()? onTap}) {
    return Row(
      children: [
        Expanded(
            child: MyTextField(
          focusNode: focusNode,
          obscureText: false,
          controller: messageController,
          hintText: '',
        )),
        const SizedBox(
          width: 15,
        ),
        GestureDetector(
            onTap: onTap,
            child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Colors.green, shape: BoxShape.circle),
                child: const Center(
                    child: Icon(
                  Icons.send,
                  color: Colors.white,
                ))))
      ],
    );
  }
}
