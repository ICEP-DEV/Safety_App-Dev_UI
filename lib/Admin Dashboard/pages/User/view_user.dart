import 'dart:convert';
import 'package:completereport/Admin Dashboard/common/app_colors.dart';
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
        await http.get(Uri.https('gbv-beta.herokuapp.com', '/user/get/'));
    var jsonData = jsonDecode(response.body);
    print(jsonData);

    List<User> registered_user = [];
    for (var u in jsonData) {
      User user_details =
          User(surname: u['surname'], name: u['name'], user_id: u['user_id']);
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
                                            snapshot.data[index].name +
                                            " " +
                                            snapshot.data[index].surname +
                                            " : " +
                                            snapshot.data[index].user_id
                                                .toString(),
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
    required this.name,
    required this.surname,
  });

  String user_id;
  String name;
  String surname;

  factory User.fromMap(Map<String, dynamic> json) => User(
        user_id: json["user_id"],
        name: json["name"],
        surname: json["surname"],
      );
}
