import 'dart:convert';
import 'dart:ffi';

import 'package:chat_ui/SocketIOChat/ChatScreen.dart';
import 'package:chat_ui/SocketIOChat/Global.dart';
import 'package:chat_ui/SocketIOChat/LoginScreen.dart';
import 'package:chat_ui/SocketIOChat/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatUserScreen extends StatefulWidget {
  const ChatUserScreen({Key? key}) : super(key: key);

  static const String ROUTE_ID = 'chat_users_screen';

  @override
  State<ChatUserScreen> createState() => _ChatUserScreenState();
}

class _ChatUserScreenState extends State<ChatUserScreen> {
  late List<User> _chatUsers;
  late bool _connectedToSocket;
  late String _connectMessage;

  @override
  void initState() {
    super.initState();
    _connectedToSocket = false;
    _connectMessage = 'Connecting...';
    _chatUsers = G.getUsersFor(G.loggedInUser);
    _connectToSocket();
    _getUsers();
  }

  _connectToSocket() async {
    print(
        'Connecting Logged In User ${G.loggedInUser.name} , ${G.loggedInUser.id}');
    G.initSocket();
    await G.socketUtils?.initSocket(G.loggedInUser);
    G.socketUtils?.connectToSocket();
    G.socketUtils?.setOnConnectListener(onConnect);
    G.socketUtils?.setOnConnectErrorListener(onConnectionError);
    G.socketUtils?.setOnConnectionTimedOutListener(onConnectTimeOut);
    G.socketUtils?.setOnDisconnectListner(onDisconnect);
    G.socketUtils?.setOnErrorListener(onError);
  }

  onConnect(data) {
    print('Connected $data');
    setState(() {
      _connectedToSocket = true;
      _connectMessage = "Connected";
    });
  }

  onConnectionError(data) {
    print('onConnectionError $data');
    setState(() {
      _connectedToSocket = false;
      _connectMessage = "Connection Error";
    });
  }

  onConnectTimeOut(data) {
    print('onConnectTimeOut $data');
    setState(() {
      _connectedToSocket = false;
      _connectMessage = "Connection TimedOut";
    });
  }

  onDisconnect(data) {
    print('onDisconnect $data');
    setState(() {
      _connectedToSocket = false;
      _connectMessage = "Diconnected";
    });
  }

  onError(data) {
    print('onError $data');
    setState(() {
      _connectedToSocket = false;
      _connectMessage = "Connection Error";
    });
  }

  _openChatScreen(context) async {
    await Navigator.pushNamed(context, ChatScreen.ROUTE_ID);
  }

  _openLoginScreen(context) async {
    await Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_ID);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    G.socketUtils?.closeConnection();
  }

  Future<List<User>> _getUsers() async {
    var data = await http.get(Uri.http('10.0.2.2:5001', '/api/contacts'));
    var jsonData = json.decode(data.body);

    List<User> contacts = [];
    for (var item in jsonData) {
      User contact = User(
          user_id: item['user_id'].toString(),
          id: item['id'],
          name: item['name'],
          surname: item['surname']);
      contacts.add(contact);
    }
    print(contacts.length);
    return contacts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Users"),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                _openLoginScreen(context);
              },
              icon: const Icon(Icons.close))
        ],
      ),
      body: FutureBuilder(
        future: _getUsers(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: Text("Please wait Loading..."),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  User user = snapshot.data[index];
                  return ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://images.pexels.com/photos/2659177/pexels-photo-2659177.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                      ),
                      title: Text(snapshot.data[index].name +
                          "" +
                          snapshot.data[index].surname +
                          "    " +
                          snapshot.data[index].user_id),
                      subtitle: Text(
                        snapshot.data[index].id.toString(),
                      ),
                      onTap: () {
                        G.toChatUser = user;
                        _openChatScreen(context);
                      });
                });
          }
        },
      ),

      // body: Container(
      //   alignment: Alignment.center,
      //   padding: EdgeInsets.all(30.0),
      //   child: Column(
      //     children: <Widget>[
      //       Text(_connectedToSocket ? 'Connected' : _connectMessage),
      //       Expanded(
      //         child: ListView.builder(
      //           itemCount: _chatUsers.length,
      //           itemBuilder: (context, index) {
      //             User user = _chatUsers[index];
      //             return ListTile(
      //               onTap: () {
      //                 G.toChatUser = user;
      //                 _openChatScreen(context);
      //               },
      //               title: Text(user.name),
      //               subtitle: Text('ID ${user.id}, user_id:${user.user_id}'),
      //             );
      //           },
      //         ),
      //       ),
      //     ],
      //   ),
      // )
    );
  }
}
