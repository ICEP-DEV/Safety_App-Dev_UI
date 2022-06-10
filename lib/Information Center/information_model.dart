import 'dart:convert';
import 'dart:io';

DataModel InformationDataModelFromJson(String str) =>
    DataModel.fromJson(json.decode(str));

class DataModel {
  DataModel({
    required this.description,
    required this.date,
    required this.title,
    required this.type,
  });

  String description;
  String date;
  String title;
  String type;

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
      description: json["description"],
      date: json["date"],
      title: json["title"],
      type: json["type"]);
  Map<String, dynamic> toJson() =>
      {"description": description, "date": date, "title": title, "type": type};
}
