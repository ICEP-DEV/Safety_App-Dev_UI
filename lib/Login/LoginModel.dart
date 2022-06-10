import 'dart:convert';
import 'dart:io';

DataModel LogindataModelFromJson(String str) =>
    DataModel.fromJson(json.decode(str));

class DataModel {
  DataModel({
    required this.password,
    required this.user_id,
  });

  String password;
  String user_id;

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        password: json["password"],
        user_id: json["user_id"],
      );
  Map<String, dynamic> toJson() => {
        "password": password,
        "user_id": user_id,
      };
}
