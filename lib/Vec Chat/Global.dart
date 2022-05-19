import 'package:completereport/Vec Chat/user.dart';

class G {
  // Socket
  static late List<User> dummyUsers;

  // Logged In User
  static late User loggedInUser;

  // Single Chat - To Chat User
  static late User toChatUser;

  static void initDummyUsers() {
    User userA = new User(
        id: 0,
        name: 'VECName',
        user_id: "216257183",
        surname: '',
        title: 'VEC');
    User userB = new User(
        id: 20, name: 'UserName', user_id: "215676222", surname: '', title: '');
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