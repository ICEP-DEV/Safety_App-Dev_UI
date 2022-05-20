import 'dart:convert';
import 'dart:io';

DataModel VECdataModelFromJson(String str) =>
    DataModel.fromJson(json.decode(str));

class DataModel {
  DataModel({
    required this.employee_name,
    required this.contact_num,
    required this.office_num,
    required this.email,
    required this.surname,
    required this.DOB,
  });

  String employee_name;
  String contact_num;
  String office_num;
  String email;
  String surname;
  String DOB;

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        employee_name: json["employee_name"],
        contact_num: json["contact_num"],
        office_num: json["office_num"],
        email: json["email"],
        surname: json["surname"],
        DOB: json["DOB"],
      );
  Map<String, dynamic> toJson() => {
        "employee_name": employee_name,
        "contact_num": contact_num,
        "office_num": office_num,
        "email": email,
        "surname": surname,
        "DOB": DOB,
      };
}
