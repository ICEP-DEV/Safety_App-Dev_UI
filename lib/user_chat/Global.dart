import 'package:completereport/user_chat/user.dart';
import 'SocketUtils.dart';

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
    User userA = User(
        id: 3,
        name: 'VECName',
        user_id: "216257183",
        surname: '',
        title: 'VEC');
    User userB = User(
        id: 20,
        name: 'UserName',
        user_id: "215676222",
        surname: '',
        title: 'User');
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
