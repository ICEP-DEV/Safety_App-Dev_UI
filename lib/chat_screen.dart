import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
// ignore: unused_import
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'controller.dart/chat_controller.dart';
import 'models/message_model.dart';
import 'models/user_model.dart';

class ChatScreen extends StatefulWidget {
  final User
      user; // Usually parse in the chatroomId and based on the chatroomId , populate the messages

  ChatScreen({required this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller =
      TextEditingController(); //Message text controller

  ChatController chatController = ChatController();

  List<User> user = [];

  late Socket socket; //initalize the Socket.IO Client Object

  @override
  void initState() {
    super.initState();
    initializeSocket(); //--> call the initializeSocket method in the initState of our app.
  }

  @override
  void dispose() {
    socket
        .disconnect(); // --> disconnects the Socket.IO client once the screen is disposed
    super.dispose();
  }

  //STEP 1 IO SOCKET

  void initializeSocket() {
    socket = io("http://192.168.56.1:5001/", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect(); //connect the Socket.IO Client to the Server

    //SOCKET EVENTS
    // --> listening for connection
    socket.on('connect', (data) {
      print(socket.connected);
    });

    //listen for incoming messages from the Server.
    socket.on('message', (data) {
      print(data); //
    });

    //listens when the client is disconnected from the Server
    socket.on('disconnect', (data) {
      print('disconnect');
    });
  }

//STEP 2 IO SOCKET

  sendMessage(String message) {
    socket.emit(
      "message",
      {
        "id": socket.id,
        "message": message, //--> message to be sent    =  message
        "username": widget.user.name,
        "sentAt": DateTime.now().toLocal().toString().substring(0, 16),
      },
    );
  }

  _buildMessage(Message message, bool isMe) {
    return Container(
      margin: isMe
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              right: 80.0,
            ),
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: isMe ? Theme.of(context).accentColor : Color(0xFFFFEFEE),
        borderRadius: isMe
            ? const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : const BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.dateTime,
            //message.dateTime, // CHATSCREEN TIME
            style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),
          // ignore: prefer_const_constructors
          SizedBox(
            height: 5.0,
          ),
          Text(
            message.description,
            // CHATSCREEN TEXT
            style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.photo),
          //   iconSize: 25.0,
          //   color: Theme.of(context).primaryColor,  // Picture Atarchment
          //   onPressed: () {},
          // ),
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},

              /// setState message=value
              decoration: const InputDecoration(hintText: 'Send a message...'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              DataModel? data = await submitData(_controller);
              _dataModel = data;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          widget.user.name,
          style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: GestureDetector(
        ///
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          //
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.only(top: 15.0),
                    itemCount: chatController.chatMessages.length,
                    //itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      //final Message message = messages[index];
                      var message = chatController.chatMessages[index];
                      final bool isMe = message.sender.id == currentUser.id;
                      return _buildMessage(message, isMe);
                    },
                  ),
                ),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}

DataModel dataModeFromJson(String str) => DataModel.fromJson(json.decode(str));

DataModel? _dataModel;

class DataModel {
  DataModel({required this.description});

  String description;

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        description: json["description"],
      );
  Map<String, dynamic> toJson() => {
        "description": description,
      };
}

Future<DataModel?> submitData(
  TextEditingController _controller,
) async {
  var response =
      await http.post(Uri.http('10.0.2.2:5001', '/api/postchat/'), body: {
    "dateTime": DateTime.now().toString(),
    "description": _controller.text,
  });

  var data = response.body;
  print(data);
  if (response.statusCode == 200) {
    String responseString = response.body;
    dataModeFromJson(responseString);
  } else
    return null;
}

http.Client getClient() {
  return http.Client();
}
