// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';

// class View_User extends StatefulWidget {
//   @override
//   State<View_User> createState() => _View_UserState();
// }

// class _View_UserState extends State<View_User> {
//   Future getRegisteredUser() async {
//     var response =
//         await http.get(Uri.https('gbv-beta.herokuapp.com', '/contacts/'));
//     var jsonData = jsonDecode(response.body);
//     List<User> registered_user = [];
//     for (var u in jsonData) {
//       User user_details = User(u['user_id'], u['name'], u['trusted_contact'],
//           u['id'], u["email"], u["surname"]);
//       registered_user.add(user_details);
//     }

//     return registered_user;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('View Users'),
//         centerTitle: true,
//         backgroundColor: Colors.red[700],
//       ),
//       body: Container(
//         color: Colors.grey.shade300,
//         //from here
//         child: Card(
//           color: Colors.grey.shade300,
//           child: FutureBuilder(
//             future: getRegisteredUser(),
//             builder: (context, AsyncSnapshot snapshot) {
//               if (snapshot.data == null) {
//                 return Container(
//                   child: const Center(
//                     child: Text("Loading"),
//                   ),
//                 );
//               } else {
//                 return ListView.builder(
//                     itemCount: snapshot.data!.length,
//                     itemBuilder: (context, i) {
//                       return RefreshIndicator(
//                         onRefresh: getRegisteredUser,
//                         child: Column(children: [
//                           Text(
//                             snapshot.data[i].id.toString() +
//                                 ':   ' +
//                                 "Id: " +
//                                 snapshot.data[i].id.toString(),
//                             style: const TextStyle(
//                               color: Colors.black,
//                               letterSpacing: 2,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           Text(
//                             "Name :  " + snapshot.data[i].name,
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontSize: 15,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           Text(
//                             'Surname : ' + snapshot.data[i].surname,
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontSize: 15,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           Text(
//                             'Contact : ' + snapshot.data[i].trusted_contact,
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontSize: 15,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           Text(
//                             'Email : ' + snapshot.data[i].email,
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontSize: 15,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ]),
//                       );
//                     });
//               }
//             },
//           ),
//         ), //To here
//       ),
//     );
//   }
// }

// class User {
//   late final String name, trusted_contact, email, surname;
//   late final int user_id;
//   late final int id;
//   User(
//     this.id,
//     this.user_id,
//     this.name,
//     this.trusted_contact,
//     this.email,
//     this.surname,
//   );
// }

import 'dart:convert';
import 'package:admin/common/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class View_User extends StatefulWidget {
  const View_User({Key? key}) : super(key: key);

  @override
  State<View_User> createState() => _View_UserState();
}

class _View_UserState extends State<View_User> {
  Future getUserData() async {
    var response =
        await http.get(Uri.https('gbv-beta.herokuapp.com', '/api/contacts/'));
    var jsonData = jsonDecode(response.body);
    print(jsonData);

    List<User> registered_user = [];
    for (var u in jsonData) {
      User user_details = User(
          id: u['id'],
          surname: u['surname'],
          name: u['name'],
          user_id: u['user_id']);
      registered_user.add(user_details);
    }

    return registered_user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Information'),
          centerTitle: true,
          backgroundColor: Colors.red[700],
        ),
        body: Container(
            color: Color.fromARGB(255, 248, 245, 245),
            //from here
            child: Card(
                color: Color.fromARGB(255, 192, 182, 182),
                child: FutureBuilder(
                    future: getUserData(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return const Center(
                          child: Text("Loading.."),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Center(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Card(
                                    child: Container(
                                      child: Text(
                                        "User Details " +
                                            " "[index] +
                                            " :  " +
                                            snapshot.data[index].name +
                                            " " +
                                            snapshot.data[index].surname,
                                        style: TextStyle(
                                          color: AppColor.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(20),
                                    ),
                                  )
                                ],
                              ));
                            });
                      }
                    }))));
  }
}

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromMap(x)));

class User {
  User({
    required this.user_id,
    required this.id,
    required this.name,
    required this.surname,
  });

  String user_id;
  int id;
  String name;
  String surname;

  factory User.fromMap(Map<String, dynamic> json) => User(
        user_id: json["user_id"],
        id: json["id"],
        name: json["name"],
        surname: json["surname"],
      );
}
