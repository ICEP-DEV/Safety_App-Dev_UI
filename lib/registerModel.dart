import 'dart:convert';
import 'dart:io';

DataModel dataModelFromJson(String str) => DataModel.fromJson(json.decode(str));

class DataModel {
  DataModel({
    required this.surname,
    required this.name,
    required this.other_contact,
    required this.gender,
    required this.user_id,
    required this.address,
    required this.trusted_contact,
    required this.email,
    required this.password,
  });

  String surname;
  String name;
  String other_contact;
  String gender;
  String user_id;
  String address;
  String trusted_contact;
  String email;
  String password;

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        surname: json["surname"],
        name: json["name"],
        other_contact: json["other_contact"],
        gender: json["gender"],
        user_id: json["user_id"],
        address: json["address"],
        trusted_contact: json["trusted_contact"],
        email: json["email"],
        password: json["password"],
      );
  Map<String, dynamic> toJson() => {
        "surname": surname,
        "name": name,
        "other_contact": other_contact,
        "gender": gender,
        "user_id": user_id,
        "address": address,
        "trusted_contact": trusted_contact,
        "email": email,
        "password": password,
      };
}
