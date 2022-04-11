import 'package:chats_s/userList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:badges/badges.dart';

class ButtonScreen extends StatelessWidget {
  int countContacts = 95;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.red, title: const Text("View Chats")),
        body: Container(
            padding: EdgeInsets.all(32),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Badge(
                    badgeContent: Text('$countContacts'),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // background
                        onPrimary: Colors.white,
                      ), // foreground
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => userList(),
                          ),
                        );
                      },
                      child: Text('View Chats'),
                    ),
                  )
                ]))));
  }
}
