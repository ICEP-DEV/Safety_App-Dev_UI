
//  import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// DataModel dataModeFromJson(String str) => DataModel.fromJson(json.decode(str));

//  DataModel _dataModel;

//  class DataModel {
//    DataModel({required this.text});

//       String text;

//    factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
//          text: json["text"],
         
//        );
//    Map<String, dynamic> toJson() => {
//          "text": text,
//        };
//  }

//  Future<DataModel> submitData(
//    TextEditingController _text,

//  ) async {
//    var response = await http.post(Uri.http('10.0.2.2', '/r'), body: {
//      "time": DateTime.now().toString(),
//      "text": _text.text,
  
//    });

//    var data = response.body;
//    print(data);
//    if (response.statusCode == 200) {
//      String responseString = response.body;
//      dataModeFromJson(responseString);
//    }
//  }




