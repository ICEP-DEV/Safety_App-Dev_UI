import 'package:completereport/Vec Chat/ChatScreen.dart';
import 'package:completereport/Vec Chat/ChatUserScreen.dart';
import 'package:completereport/Vec Chat/LoginScreen.dart';

class Routes {
  static routes() {
    return {
      LoginScreen.ROUTE_ID: (context) => LoginScreen(),
      ChatUsersScreen.ROUTE_ID: (context) => ChatUsersScreen(),
      ChatScreen.ROUTE_ID: (context) => ChatScreen(),
    };
  }

  static initScreen() {
    return LoginScreen.ROUTE_ID;
  }
}
