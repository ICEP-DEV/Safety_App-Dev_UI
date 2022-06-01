import 'package:flutter/material.dart';
import 'package:flutter_socket_io/model/message.dart';
import 'package:flutter_socket_io/providers/home.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String title = "";

  late IO.Socket _socket;
  final TextEditingController _messageInputController = TextEditingController();
  late String user_id;
  _sendMessage() {
    _socket.emit('description', {
      'description': _messageInputController.text.trim(),
      'sender': widget.username
    });
    //_messageInputController.clear();
  }

  _connectSocket() {
    _socket.onConnect((data) => print('Connection established'));
    _socket.onConnectError((data) => print('Connect Error: $data'));
    _socket.onDisconnect((data) => print('Socket.IO server disconnected'));
    _socket.on(
      'description',
      (data) => Provider.of<HomeProvider>(context, listen: false).addNewMessage(
        Message.fromJson(data),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //Important: If your server is running on localhost and you are testing your app on Android then replace http://localhost:3000 with http://10.0.2.2:3000
    _socket = IO.io(
      'http://10.0.2.2:5001',
      IO.OptionBuilder().setTransports(['websocket']).setQuery(
          {'username': widget.username}).build(),
    );
    _connectSocket();
  }

  @override
  void dispose() {
    _messageInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ChatBox'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<HomeProvider>(
              builder: (_, provider, __) => ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final message = provider.description[index];
                  return Wrap(
                    alignment: message.senderUsername == widget.username
                        ? WrapAlignment.end
                        : WrapAlignment.start,
                    children: [
                      Card(
                        color: message.senderUsername == widget.username
                            ? Theme.of(context).primaryColorLight
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment:
                                message.senderUsername == widget.username
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            children: [
                              Text(message.description),
                              Text(
                                DateFormat('hh:mm a').format(message.sentAt),
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
                separatorBuilder: (_, index) => const SizedBox(
                  height: 5,
                ),
                itemCount: provider.description.length,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageInputController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (_messageInputController.text.trim().isNotEmpty) {
                        _sendMessage();
                      }
                      title = widget.username;
                      DataModel? data =
                          await submitData(_messageInputController, title);
                      setState(() {
                        _dataModel = data;
                      });
                    },
                    icon: const Icon(Icons.send),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

DataModel dataModeFromJson(String str) => DataModel.fromJson(json.decode(str));

DataModel? _dataModel;

class DataModel {
  DataModel({required this.description, required this.title});

  String description;
  String title;

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        description: json["description"],
        title: json["title"],
      );
  Map<String, dynamic> toJson() => {
        "description": description,
        "title": title,
      };
}

Future<DataModel?> submitData(
    TextEditingController _textController, String title) async {
  var response =
      await http.post(Uri.http('10.0.2.2:5001', '/api/post/'), body: {
    "dateTime": DateTime.now().toString(),
    "description": _textController.text,
    "title": title.toString()
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
