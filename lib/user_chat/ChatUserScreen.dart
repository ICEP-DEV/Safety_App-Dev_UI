import 'package:completereport/user_chat/ChatScreen.dart';
import 'package:completereport/user_chat/LoginScreen.dart';
import 'package:completereport/user_chat/user.dart';
import 'package:flutter/material.dart';
import 'Global.dart';

class ChatUsersScreen extends StatefulWidget {
  //
  ChatUsersScreen() : super();

  static const String ROUTE_ID = 'chat_users_list_screen';

  @override
  _ChatUsersScreenState createState() => _ChatUsersScreenState();
}

class _ChatUsersScreenState extends State<ChatUsersScreen> {
  //
  late List<User> _chatUsers;
  late bool _connectedToSocket;
  late String _errorConnectMessage;

  @override
  void initState() {
    super.initState();
    _chatUsers = G.getUsersFor(G.loggedInUser);
    _connectedToSocket = false;
    _errorConnectMessage = 'Connecting...';
    _connectSocket();
  }

  _connectSocket() {
    Future.delayed(Duration(seconds: 2), () async {
      print(
          "Connecting Logged In User: ${G.loggedInUser.name}, ID: ${G.loggedInUser.id}");
    });
  }

  static openLoginScreen(BuildContext context) async {
    await Navigator.pushReplacementNamed(
      context,
      LoginScreen.ROUTE_ID,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Users"),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                openLoginScreen(
                    context); // ChatScreen Close button redirects to login screen
              },
              icon: const Icon(Icons.close))
        ],
      ),
      body: _buildListView(),
    );
  }

  ListView _buildListView() {
    return ListView.builder(
        itemCount: _chatUsers.length,
        itemBuilder: (context, index) {
          User user = _chatUsers[index];
          return ListTile(
            onTap: () {
              G.toChatUser = user;
              openChatScreen(context);
            },
            title: Text(user.name),
            subtitle: Text('ID ${user.id},    user_id:${user.user_id}'),
            trailing:
                Text(_connectedToSocket ? 'Connected' : _errorConnectMessage),
          );
        });
  }

  static openChatScreen(BuildContext context) async {
    await Navigator.pushNamed(
      context,
      ChatScreen.ROUTE_ID,
    );
  }

  onConnect(data) {
    print('Connected $data');
    setState(() {
      _connectedToSocket = true;
    });
  }

  onConnectError(data) {
    print('onConnectError $data');
    setState(() {
      _connectedToSocket = false;
      _errorConnectMessage = 'Failed to Connect';
    });
  }

  onConnectTimeout(data) {
    print('onConnectTimeout $data');
    setState(() {
      _connectedToSocket = false;
      _errorConnectMessage = 'Connection timedout';
    });
  }

  onError(data) {
    print('onError $data');
    setState(() {
      _connectedToSocket = false;
      _errorConnectMessage = 'Connection Failed';
    });
  }

  onDisconnect(data) {
    print('onDisconnect $data');
    setState(() {
      _connectedToSocket = false;
      _errorConnectMessage = 'Disconnected';
    });
  }
}
