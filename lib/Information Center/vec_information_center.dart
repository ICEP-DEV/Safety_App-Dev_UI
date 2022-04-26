import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'information_model.dart';
import 'package:http/http.dart' as http;

class VEC_Information_Center extends StatefulWidget {
  @override
  State<VEC_Information_Center> createState() => _VEC_Information_CenterState();
}

class _VEC_Information_CenterState extends State<VEC_Information_Center> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  DataModel? _dataMOdel;
  String information = "";
  String title = "";
  String selectedValue = "EVENTS UPDATES";
  final List<String> typeUpdates = ["EVENTS UPDATES", "APP INFORMATION"];

  Widget _buildInformation() {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(bottom: 200),
        labelText: "                     New Information",
        labelStyle: TextStyle(fontSize: 18, color: Colors.black),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.multiline,
      minLines: 2,
      maxLines: 200,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Cannot update a blank page";
        }
      },
      onSaved: (String? value) {
        information = value!;
      },
    );
  }

  Widget _buildTitle() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Title",
        labelStyle: TextStyle(fontSize: 18, color: Colors.black),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.multiline,
      minLines: 2,
      maxLines: 200,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Title is needed";
        }
      },
      onSaved: (String? value) {
        title = value!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        title: Text("Update Information"),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButton<String>(
                    isExpanded: true,
                    iconSize: 36,
                    iconEnabledColor: Colors.red[700],
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                    items: typeUpdates.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  _buildTitle(),
                  SizedBox(height: 10),
                  _buildInformation(),
                  SizedBox(height: 40),
                  ElevatedButton(
                      child: Text("Update"),
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(200, 50),
                          primary: Colors.red[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      onPressed: () async {
                        if (!_formkey.currentState!.validate()) {
                          return;
                        }
                        _formkey.currentState!.save();

                        if (selectedValue == "EVENTS UPDATES") {
                          DataModel? data =
                              await submitData(information, title);
                          setState(() {
                            _dataMOdel = data!;
                          });
                        } else if (selectedValue == "APP INFORMATION") {
                          DataModel? data =
                              await submitData2(information, title);
                          setState(() {
                            _dataMOdel = data!;
                          });
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // first submit data
  Future<DataModel?> submitData(String information, String title) async {
    var response =
        await http.post(Uri.http('10.0.2.2:5001', '/createevent/'), body: {
      "title": title,
      "type": "event",
      "description": information,
      "date": DateTime.now().toString(),
    });
    var data = response.body;

    print(data);
    Fluttertoast.showToast(
        msg: 'updates sent',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
    if (response.statusCode == 200) {
      String responseString = response.body;
      InformationDataModelFromJson(responseString);
    }
  }

  // second submit data
  Future<DataModel?> submitData2(String information, String title) async {
    var response =
        await http.post(Uri.http('10.0.2.2:5001', '/createsafetyinfo/'), body: {
      "title": title,
      "type": "safety",
      "description": information,
    });
    var data = response.body;

    print(data);
    Fluttertoast.showToast(
        msg: 'updates sent',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
    if (response.statusCode == 200) {
      String responseString = response.body;
      InformationDataModelFromJson(responseString);
    }
  }
}
