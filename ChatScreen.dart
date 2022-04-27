import 'dart:async';
import 'package:flutter/material.dart';
import 'package:user_chat_ui/ChatBubble.dart';
import 'package:user_chat_ui/ChatMessageModel.dart';
import 'package:user_chat_ui/Global.dart';
import 'package:user_chat_ui/socketUtils.dart';
import 'package:user_chat_ui/user.dart';
import 'ChatTitle.dart';
import 'package:intl/intl.dart';
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
  late TextEditingController _chatTextCOntroller;
  late List<ChatMessageModel> _chatMessages;
  late User _chatUser;
  late ScrollController _chatListController;
  late UserOnlineStatus _userOnlineStatus;

  @override
  void initState() {
    super.initState();
    _userOnlineStatus = UserOnlineStatus.connecting;
    _chatListController = ScrollController(initialScrollOffset: 0.0);
    _chatTextCOntroller = TextEditingController();
    _chatUser = G.toChatUser;
    _chatMessages = [];
    _initSocketListeners();
    _checkOnline();
  }

  _initSocketListeners() async {
    G.socketUtils?.setOnUserConnectionStatusListener(onUserConnectionStatus);
    G.socketUtils?.setOnChatMessageReceivedListener(onChatMessageReceived);
    G.socketUtils?.setOnMessageBackFromServer(onMessageBackFromServer);
  }

  DateTime now = DateTime.now();
  _checkOnline() async {
    ChatMessageModel chatMessageModel = ChatMessageModel(
        to: G.toChatUser.id,
        from: G.loggedInUser.id,
        chatId: 0,
        chatType: SocketUtils.SINGLE_CHAT,
        toUserOnlineStatus: false,
        message: _chatTextCOntroller.text,
        dateTime: DateFormat.Hm().format(now));
    G.socketUtils?.checkOnline(chatMessageModel);
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
          controller: _chatListController,
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
            },
          ),
        ],
      ),
    );
  }

  _chatTextArea() {
    return Expanded(
      child: TextField(
        controller: _chatTextCOntroller,
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
    if (_chatTextCOntroller.text.isEmpty) {
      return;
    }
    DateTime now = DateTime.now();
    ChatMessageModel chatMessageModel = ChatMessageModel(
        chatId: 0,
        to: _chatUser.id,
        from: G.loggedInUser.id,
        toUserOnlineStatus: false,
        message: _chatTextCOntroller.text,
        chatType: SocketUtils.SINGLE_CHAT,
        dateTime: DateFormat.Hm().format(now));
    _addMessage(0, chatMessageModel, _isFromMe(G.loggedInUser));
    _clearMessage();
    G.socketUtils?.sendSingleChatMessage(chatMessageModel, _chatUser);
  }

  _clearMessage() {
    _chatTextCOntroller.text = '';
  }

  _isFromMe(User fromUser) {
    return fromUser.id == G.loggedInUser.id;
  }

  _chatBubble(ChatMessageModel chatMessageModel) {
    bool fromMe = chatMessageModel.from == G.loggedInUser.id;
    Alignment alignment = fromMe ? Alignment.topRight : Alignment.topLeft;
    Alignment chatArrowAlignment =
        fromMe ? Alignment.topRight : Alignment.topLeft;
    TextStyle textStyle = TextStyle(
      fontSize: 15.0,
      color: fromMe ? Colors.white : Colors.black54,
    );
    Color chatBgColor = fromMe ? Colors.blue : Colors.black12;
    EdgeInsets edgeInsets = fromMe
        ? EdgeInsets.fromLTRB(5, 5, 15, 15)
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
                    height: 5.0,
                  ),
                  Text(
                    chatMessageModel.message,
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
    print('Adding Message to UI ${chatMessageModel.message}');
    setState(() {
      _chatMessages.add(chatMessageModel);
    });
    print('Total Messages: ${_chatMessages.length}');
    _chatListScrollToBottom();
  }

  /// Scroll the Chat List when it goes to bottom
  _chatListScrollToBottom() {
    Timer(Duration(milliseconds: 100), () {
      if (_chatListController.hasClients) {
        _chatListController.animateTo(
          _chatListController.position.maxScrollExtent,
          duration: Duration(milliseconds: 100),
          curve: Curves.decelerate,
        );
      }
    });
  }
}

enum UserOnlineStatus { connecting, online, not_online }
