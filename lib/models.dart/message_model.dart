import 'package:flutter/cupertino.dart';
import 'package:v_chat2/models.dart/user_model.dart';

class Message {
  final User sender;
  final String dateTime; //Usually is of type datetime
  final String description;
  final bool unread;

  Message({
    required this.sender,
    required this.dateTime,
    required this.description,
    required this.unread,
  });
}

//YOU - current user

final User admin = User(
  id: 0,
  name: 'Admin',
  imageUrl: '',
);

final User currentUser = User(
  id: 1,
  name: 'Us',
  imageUrl: '',
);

//Favorite Admin
List<User> favorites = [admin];

//Example chats on homescreen

List<Message> chats = [
  Message(
    sender: admin,
    dateTime: '5:30 PM',
    description: 'Hi , how are you doing today?',
    unread: true,
  ),
  // Message(
  //   sender: admin,
  //   time: '5:30 PM',
  //   text: 'Hi , how are you doing today?',
  //   unread: false,
  // )
];

//Example messages in chat screen
// List<Message> messages = [
//   Message(
//     sender: admin,
//     dateTime: '8:30 AM',
//     description: 'Great Pleasure !',
//     unread: true,
//   ),
//   Message(
//     sender: currentUser,
//     dateTime: '8:20 AM',
//     description: 'Thank you for assiting !',
//     unread: true,
//   ),
//   Message(
//     sender: admin,
//     dateTime: '8:15 AM',
//     description: 'Awesome !',
//     unread: true,
//   ),
//   Message(
//     sender: currentUser,
//     dateTime: '8:10 AM',
//     description: 'Yes thank you !',
//     unread: true,
//   ),
//   Message(
//     sender: admin,
//     dateTime: '8:00 AM',
//     description: 'Hey, Are you sorted?',
//     unread: true,
//   ),
// ];



