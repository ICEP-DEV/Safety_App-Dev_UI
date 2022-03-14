import 'package:chats_s/Model/chat_model.dart';
import 'package:chats_s/custom_card.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatModel> chats = [
    ChatModel(
        name: 'Admin',
        icon: 'Person.svg',
        isGroup: false,
        time: '4:00 pm',
        currentMessage: 'Hi Lerato, Can i help you?',
        status: 'online',
        id: 0)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) =>
          CustomCard(chatModel: chats[index], sourchat: chats[index]),
    ));
  }
}
