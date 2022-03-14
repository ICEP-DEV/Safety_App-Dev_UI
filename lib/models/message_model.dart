import 'package:completereport/models/user_model.dart';
import 'package:intl/intl.dart';

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

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        description: json["description"],
        dateTime: json["dateTimme"],
        sender: json["sender"],
        unread: json["unread"]);
  }
}

//YOU - current user

final User currentUser = User(
  id: 0,
  name: 'currentUser',
  imageUrl: '',
);

final User admin = User(
  id: 1,
  name: 'admin',
  imageUrl: '',
);

//Favorite Admin

List<User> favorites = [admin];

//Example chats on homescreen
DateTime now = DateTime.now();
String formattedTime = DateFormat.Hm().format(now);

List<Message> chats = [
  Message(
    sender: admin,
    dateTime: formattedTime,
    description: 'Hey how are you doing?',
    unread: true,
  ),
  Message(
    sender: admin,
    dateTime: formattedTime,
    description: 'Hey how are you doing?',
    unread: false,
  )
];
