import 'package:completereport/Vec Chat/ChatScreen.dart';
import 'package:completereport/Vec Chat/LoginScreen.dart';
import 'package:completereport/Vec Chat/user.dart';
import 'package:flutter/material.dart';
import 'Global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<List<User>> _getUsers() async {
    var data =
        await http.get(Uri.https('gbv-beta.herokuapp.com', '/api/contacts'));
    var jsonData = json.decode(data.body);

    List<User> contacts = [];
    for (var item in jsonData) {
      User contact = User(
          user_id: item['user_id'].toString(),
          id: item['id'],
          name: item['name'],
          surname: item['surname'],
          title: item['title']);
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
    );
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
