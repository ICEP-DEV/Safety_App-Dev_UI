import 'package:chats_s/Model/chat_model.dart';
import 'package:chats_s/individualPage.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({Key? key, required this.chatModel, required this.sourchat})
      : super(key: key);
  final ChatModel chatModel;
  final ChatModel sourchat;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => IndividualPage(
                        chatModel: chatModel,
                        sourchat: sourchat,
                      )));
        },
        child: Column(children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
            ),
            title: Text(
              chatModel.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              children: [
                Icon(Icons.done_all),
                SizedBox(
                  width: 3,
                ),
                Text(
                  chatModel.currentMessage,
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            trailing: Text(chatModel.time),
          ),
        ]));
  }
}
