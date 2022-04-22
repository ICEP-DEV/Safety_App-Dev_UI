import 'dart:ffi';

import 'package:badges/badges.dart';
import 'package:chat_ui/SocketIOChat/ChatUserScreen.dart';
import 'package:chat_ui/SocketIOChat/Global.dart';
import 'package:chat_ui/SocketIOChat/User.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String ROUTE_ID = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _usernameController;

  int countContacts = 95;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usernameController = TextEditingController();
    G.initDummyUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Chat"),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6.0))),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(20.0),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Badge(
                badgeContent: Text('$countContacts'),
                child: OutlinedButton(
                  child: Text('View Chats'),
                  onPressed: () {
                    _LoginBtnTap();
                  },
                ))
          ],
        ),
      ),
    );
  }

  _LoginBtnTap() {
    if (_usernameController.text.isEmpty) {
      return;
    } else {
      User me = G.dummyUsers[0];
      if (_usernameController.text != 'vec') {
        me = G.dummyUsers[1];
      }
      G.loggedInUser = me;
      _openChatUserListScreen(context);
    }
  }

  _openChatUserListScreen(context) async {
    await Navigator.pushReplacementNamed(context, ChatUserScreen.ROUTE_ID);
  }
}
