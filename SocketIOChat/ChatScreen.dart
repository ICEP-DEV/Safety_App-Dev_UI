import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:chat_ui/SocketIOChat/ChatMessageModel.dart';
import 'package:chat_ui/SocketIOChat/ChatTitle.dart';
import 'package:chat_ui/SocketIOChat/Global.dart';
import 'package:chat_ui/SocketIOChat/LoginScreen.dart';
import 'package:chat_ui/SocketIOChat/SocketUtils.dart';
import 'package:chat_ui/SocketIOChat/User.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static const String ROUTE_ID = 'chat_screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<ChatMessageModel> _chatMessages;
  late User _toChatUser;
  late UserOnlineStatus _userOnlineStatus;

  late TextEditingController _chatTextCOntroller;
  late ScrollController _chatListController;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _removeListers();
  }

  @override
  void initState() {
    super.initState();
    _chatMessages = [];
    _toChatUser = G.toChatUser;
    _chatTextCOntroller = TextEditingController();
    _userOnlineStatus = UserOnlineStatus.connecting;
    _iniSocketListener();
    checkOnline();
    _chatListController = ScrollController(initialScrollOffset: 0);
  }

  checkOnline() {
    DateTime now = DateTime.now();
    ChatMessageModel chatMessageModel = ChatMessageModel(
        chatId: 0,
        to: _toChatUser.id,
        message: '',
        chatType: SocketUtils.SINGLE_CHAT,
        toUserOnlineStatus: false,
        from: G.loggedInUser.id,
        isFromMe: true,
        dateTime: DateFormat.Hm().format(now));
    G.socketUtils?.checkOnLine(chatMessageModel);
  }

  _iniSocketListener() async {
    G.socketUtils?.setOnChatMessageReceiveListener(onChatMessageReceive);
    G.socketUtils?.setOnlineUserStatusListener(onUserStatus);
  }

  _removeListers() async {
    G.socketUtils?.setOnChatMessageReceiveListener(onChatMessageReceive);
    G.socketUtils?.setOnlineUserStatusListener(onUserStatus);
  }

  onUserStatus(data) {
    print('onUserStatus $data');
    ChatMessageModel chatMessageModel = ChatMessageModel.fromJson(data);
    setState(() {
      _userOnlineStatus = chatMessageModel.toUserOnlineStatus
          ? UserOnlineStatus.online
          : UserOnlineStatus.not_online;
    });
  }

  onChatMessageReceive(data) {
    print('onChatMessageReceived $data');
    ChatMessageModel chatMessageModel = ChatMessageModel.fromJson(data);
    chatMessageModel.isFromMe = false;
    processMessage(chatMessageModel);
    _chatListScrollToBottom();
  }

  processMessage(chatMessageModel) {
    setState(() {
      _chatMessages.add(chatMessageModel);
    });
  }

  _chatListScrollToBottom() {
    Timer(Duration(milliseconds: 100), () {
      if (_chatListController.hasClients) {
        _chatListController.animateTo(
            _chatListController.position.maxScrollExtent,
            duration: Duration(milliseconds: 100),
            curve: Curves.decelerate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: ChatTitle(
              toChatUser: _toChatUser, userOnlineStatus: _userOnlineStatus),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  controller: _chatListController,
                  itemCount: _chatMessages.length,
                  itemBuilder: (context, index) {
                    ChatMessageModel chatMessageModel = _chatMessages[index];
                    bool fromMe = chatMessageModel.isFromMe;
                    return Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(10.0),
                      alignment:
                          fromMe ? Alignment.centerRight : Alignment.centerLeft,
                      color: fromMe ? Colors.green : Colors.grey,
                      child: Text(chatMessageModel.message +
                          "  " +
                          chatMessageModel.dateTime),
                    );
                  },
                ),
              ),
              _bottomChatArea(),
            ],
          ),
        ));
  }

  _bottomChatArea() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          _chatTextArea(),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _sendMessageBtnTap();
            },
          )
        ],
      ),
    );
  }

  _sendMessageBtnTap() async {
    print('Sending message to ${_toChatUser.name}  , id ${_toChatUser.id}');
    DataModel? data = await submitData(_chatTextCOntroller);
    _dataModel = data;

    if (_chatTextCOntroller.text.isEmpty) {
      return;
    }

    DateTime now = DateTime.now();
    ChatMessageModel chatMessageModel = ChatMessageModel(
      chatId: 0,
      to: _toChatUser.id,
      message: _chatTextCOntroller.text,
      chatType: SocketUtils.SINGLE_CHAT,
      toUserOnlineStatus: false,
      from: G.loggedInUser.id,
      isFromMe: true,
      dateTime: DateFormat.Hm().format(now),
    );
    processMessage(chatMessageModel);
    G.socketUtils?.sendSingleChatMessage(chatMessageModel);
    _chatListScrollToBottom();
  }

  _chatTextArea() {
    return Expanded(
        child: TextField(
      controller: _chatTextCOntroller,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(10.0),
          hintText: 'Type message...'),
    ));
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
      await http.post(Uri.http('10.0.2.2:5001', '/api/post/'), body: {
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
