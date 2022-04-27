import 'package:user_chat_ui/socketUtils.dart';
import 'package:user_chat_ui/user.dart';

class G {
  // Socket
  static SocketUtils? socketUtils;
  static late List<User> dummyUsers;

  // Logged In User
  static late User loggedInUser;

  // Single Chat - To Chat User
  static late User toChatUser;

  static initSocket() {
    if (null == socketUtils) {
      socketUtils = SocketUtils();
    }
  }

  static void initDummyUsers() {
    User userA =
        User(id: 0, name: 'VEC', user_id: 'vec215267234', surname: 'Manha');
    User userB =
        User(id: 1, name: 'User', user_id: 'user215267234', surname: 'Bless');
    dummyUsers = <User>[];
    dummyUsers.add(userA);
    dummyUsers.add(userB);
  }

  static List<User> getUsersFor(User user) {
    List<User> filteredUsers = dummyUsers
        .where((u) => (!u.name.toLowerCase().contains(user.name.toLowerCase())))
        .toList();
    return filteredUsers;
  }
}
