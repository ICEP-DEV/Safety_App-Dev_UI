import 'package:chats_s/Model/button.dart';
import 'package:chats_s/userList.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:chats_s/Model/contacts_model.dart';
import 'package:chats_s/ownMessageCard.dart';
import 'package:chats_s/replyCard.dart';
import 'package:chats_s/Model/message_model.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ButtonScreen());
  }
}
