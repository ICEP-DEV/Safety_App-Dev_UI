import 'dart:async';
import 'dart:convert';
import 'package:completereport/user_chat/ChatBubble.dart';
import 'package:completereport/user_chat/Global.dart';
import 'package:completereport/user_chat/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ChatMessageModel.dart';
import 'ChatTitle.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  //
  ChatScreen() : super();

  final String title = "Chat Screen";

  static const String ROUTE_ID = 'chat_screen';

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  //
  late TextEditingController _textController;
  late List<ChatMessageModel> _chatMessages;
  late User _chatUser;
  late ScrollController _chatLVController;
  late UserOnlineStatus _userOnlineStatus;

  String title = G.loggedInUser.name;

  @override
  void initState() {
    super.initState();
    _userOnlineStatus = UserOnlineStatus.connecting;
    _chatLVController = ScrollController(initialScrollOffset: 0.0);
    _textController = TextEditingController();
    _chatUser = G.toChatUser;
    _chatMessages = [];
    _initSocketListeners();
    _checkOnline();
  }

  _initSocketListeners() async {}

  _checkOnline() async {
    DateTime now = DateTime.now();
    ChatMessageModel chatMessageModel = ChatMessageModel(
        to: G.toChatUser.id,
        from: G.loggedInUser.id,
        chatId: G.loggedInUser.id,
        description: _textController.text,
        toUserOnlineStatus: false,
        dateTime: DateFormat.Hm().format(now));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: ChatTitle(
          chatUser: G.toChatUser,
          userOnlineStatus: _userOnlineStatus,
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _chatList(),
              _bottomChatArea(),
            ],
          ),
        ),
      ),
    );
  }

  _chatList() {
    return Expanded(
      child: Container(
        child: ListView.builder(
          cacheExtent: 100,
          controller: _chatLVController,
          reverse: false,
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          itemCount: null == _chatMessages ? 0 : _chatMessages.length,
          itemBuilder: (context, index) {
            ChatMessageModel chatMessage = _chatMessages[index];
            return _chatBubble(
              chatMessage,
            );
          },
        ),
      ),
    );
  }

  _bottomChatArea() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          _chatTextArea(),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              _sendButtonTap();
              DataModel? data = await submitData(_textController, title);
              setState(() {
                _dataModel = data;
              });
            },
          ),
        ],
      ),
    );
  }

  _chatTextArea() {
    return Expanded(
      child: TextField(
        controller: _textController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 0.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Colors.white,
              width: 0.0,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(10.0),
          hintText: 'Type message...',
        ),
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _sendButtonTap() async {
    if (_textController.text.isEmpty) {
      return;
    }
    DateTime now = DateTime.now();
    ChatMessageModel chatMessageModel = ChatMessageModel(
        chatId: G.loggedInUser.id,
        to: _chatUser.id,
        from: G.loggedInUser.id,
        toUserOnlineStatus: false,
        description: _textController.text,
        dateTime: DateFormat.Hm().format(now));
    _addMessage(0, chatMessageModel, _isFromMe(G.loggedInUser));
  }

  _clearMessage() {
    _textController.text = '';
  }

  _isFromMe(User fromUser) {
    return fromUser.id == G.loggedInUser.id;
  }

  _chatBubble(ChatMessageModel chatMessageModel) {
    print(chatMessageModel.description);
    bool fromMe = chatMessageModel.from == G.loggedInUser.id;
    Alignment alignment = fromMe ? Alignment.topRight : Alignment.topLeft;
    Alignment chatArrowAlignment =
        fromMe ? Alignment.topRight : Alignment.topLeft;
    TextStyle textStyle = TextStyle(
      fontSize: 15.0,
      color: fromMe ? Colors.white : Colors.black,
    );
    Color chatBgColor = fromMe ? Colors.red : Colors.black;
    EdgeInsets edgeInsets = fromMe
        ? EdgeInsets.fromLTRB(5, 5, 15, 5)
        : EdgeInsets.fromLTRB(15, 5, 5, 5);
    EdgeInsets margins = fromMe
        ? EdgeInsets.fromLTRB(80, 5, 10, 5)
        : EdgeInsets.fromLTRB(10, 5, 80, 5);

    return Container(
      color: Colors.white,
      margin: margins,
      child: Align(
        alignment: alignment,
        child: Column(
          children: <Widget>[
            CustomPaint(
              painter: ChatBubble(
                color: chatBgColor,
                alignment: chatArrowAlignment,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    chatMessageModel.dateTime,
                    //message.dateTime, // CHATSCREEN TIME
                  ),
                  // ignore: prefer_const_constructors
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    chatMessageModel.description,
                    // CHATSCREEN TEXT
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  onChatMessageReceived(data) {
    print('onChatMessageReceived $data');
    if (null == data || data.toString().isEmpty) {
      return;
    }
    ChatMessageModel chatMessageModel = ChatMessageModel.fromJson(data);
    bool online = chatMessageModel.toUserOnlineStatus;
    _updateToUserOnlineStatusInUI(online);
    processMessage(chatMessageModel);
  }

  onMessageBackFromServer(data) {
    ChatMessageModel chatMessageModel = ChatMessageModel.fromJson(data);
    bool online = chatMessageModel.toUserOnlineStatus;
    print('onMessageBackFromServer $data');
    if (!online) {
      print('User not connected');
    }
  }

  onUserConnectionStatus(data) {
    ChatMessageModel chatMessageModel = ChatMessageModel.fromJson(data);
    bool online = chatMessageModel.toUserOnlineStatus;
    _updateToUserOnlineStatusInUI(online);
  }

  _updateToUserOnlineStatusInUI(online) {
    setState(() {
      _userOnlineStatus =
          online ? UserOnlineStatus.online : UserOnlineStatus.not_online;
    });
  }

  processMessage(ChatMessageModel chatMessageModel) {
    _addMessage(0, chatMessageModel, false);
  }

  _addMessage(id, ChatMessageModel chatMessageModel, fromMe) async {
    print('Adding Message to UI ${chatMessageModel.description}');
    setState(() {
      _chatMessages.add(chatMessageModel);
    });
    print('Total Messages: ${_chatMessages.length}');
    _chatListScrollToBottom();
  }

  /// Scroll the Chat List when it goes to bottom
  _chatListScrollToBottom() {
    Timer(Duration(milliseconds: 100), () {
      if (_chatLVController.hasClients) {
        _chatLVController.animateTo(
          _chatLVController.position.maxScrollExtent,
          duration: Duration(milliseconds: 100),
          curve: Curves.decelerate,
        );
      }
    });
  }
}

enum UserOnlineStatus { connecting, online, not_online }

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
