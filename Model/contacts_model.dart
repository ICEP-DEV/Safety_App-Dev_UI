// class ContactsModel {
//   final int id;
//   final String name;
//   final String surname;
//   final String user_id;

//   ContactsModel(
//       {required this.id,
//       required this.name,
//       required this.surname,
//       required this.user_id});

//   factory ContactsModel.fromJson(Map<String, dynamic> json) {
//     return ContactsModel(
//         id: json['id'],
//         name: json['name'],
//         surname: json['surname'],
//         user_id: json['user_id']);
//   }
// }

import 'dart:convert';

class ContactsModel {
  ContactsModel({
    required this.user_id,
    required this.id,
    required this.name,
    required this.surname,
  });

  String user_id;
  int id;
  String name;
  String surname;

  factory ContactsModel.fromJson(Map<String, dynamic> json) {
    return ContactsModel(
        user_id: json["userId"],
        id: json["id"],
        name: json["title"],
        surname: json["body"]);
  }
}
