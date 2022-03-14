import 'package:chats_s/chat_page.dart';
import 'package:flutter/material.dart';

class ButtonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red, title: const Text("Chat Request")),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red, // background
            onPrimary: Colors.white,
          ), // foreground
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(),
              ),
            );
          },
          child: const Text(
            'Request Chat',
          ),
        ),
      ),
    );
  }
}
