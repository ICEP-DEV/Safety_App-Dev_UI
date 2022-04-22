import 'dart:convert';
import 'dart:ffi';
import 'package:chat_ui/SocketIOChat/SocketUtils.dart';
import 'package:chat_ui/SocketIOChat/User.dart';
import 'package:http/http.dart' as http;

class G {
  static late List<User> dummyUsers;

  static late User loggedInUser;

  static late User toChatUser;

  static SocketUtils? socketUtils;

  static void initDummyUsers() {
    User VEC = User(
        id: 100, user_id: "216257138", name: "vec", surname: "user_surname");

    dummyUsers = [];
    dummyUsers.add(VEC);
  }

  static List<User> getUsersFor(User user) {
    List<User> filteredUser = dummyUsers
        .where(
          (u) => (!u.name.toLowerCase().contains(user.name.toLowerCase())),
        )
        .toList();
    return filteredUser;
  }

  static initSocket() {
    if (null == socketUtils) {
      socketUtils = SocketUtils();
    }
  }
}
