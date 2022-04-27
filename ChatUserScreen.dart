import 'package:flutter/material.dart';
import 'package:user_chat_ui/ChatScreen.dart';
import 'package:user_chat_ui/loginScreen.dart';
import 'package:user_chat_ui/user.dart';
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
  late String _connectMessage;

  @override
  void initState() {
    super.initState();
    _chatUsers = G.getUsersFor(G.loggedInUser);
    _connectedToSocket = false;
    _connectMessage = 'Connecting...';
    _connectSocket();
  }

  _connectSocket() {
    Future.delayed(Duration(seconds: 2), () async {
      print(
          "Connecting Logged In User: ${G.loggedInUser.name}, ID: ${G.loggedInUser.id}");
      G.initSocket();
      await G.socketUtils?.initSocket(G.loggedInUser);
      G.socketUtils?.connectToSocket();
      G.socketUtils?.setConnectListener(onConnect);
      G.socketUtils?.setOnDisconnectListener(onDisconnect);
      G.socketUtils?.setOnErrorListener(onError);
      G.socketUtils?.setOnConnectionErrorListener(onConnectError);
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
                G.socketUtils!.closeConnection();
                _openLoginScreen(
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
              _openChatScreen(context);
            },
            title: Text(user.name),
            subtitle: Text('ID ${user.id},    user_id:${user.user_id}'),
            trailing: Text(_connectedToSocket ? 'Connected' : _connectMessage),
          );
        });
  }

  _openLoginScreen(context) async {
    await Navigator.pushReplacementNamed(
        context, LoginScreen.ROUTE_ID); // redirects to login screen
  }

  _openChatScreen(BuildContext context) async {
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
      _connectMessage = 'Failed to Connect';
    });
  }

  onConnectTimeout(data) {
    print('onConnectTimeout $data');
    setState(() {
      _connectedToSocket = false;
      _connectMessage = 'Connection timedout';
    });
  }

  onError(data) {
    print('onError $data');
    setState(() {
      _connectedToSocket = false;
      _connectMessage = 'Connection Failed';
    });
  }

  onDisconnect(data) {
    print('onDisconnect $data');
    setState(() {
      _connectedToSocket = false;
      _connectMessage = 'Disconnected';
    });
  }
}
