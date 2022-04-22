import 'package:chat_ui/SocketIOChat/ChatScreen.dart';
import 'package:chat_ui/SocketIOChat/ChatUserScreen.dart';
import 'package:chat_ui/SocketIOChat/LoginScreen.dart';

class Routes {
  static routes() {
    return {
      LoginScreen.ROUTE_ID: (context) => LoginScreen(),
      ChatUserScreen.ROUTE_ID: (context) => ChatUserScreen(),
      ChatScreen.ROUTE_ID: (context) => ChatScreen(),
    };
  }

  static initScreen() {
    return LoginScreen.ROUTE_ID;
  }
}
