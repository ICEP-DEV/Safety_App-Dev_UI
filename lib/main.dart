import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'view_model.dart';
import 'package:testim_view/feedback.dart';
import 'package:testim_view/view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.red),
      home: DataFromAPI(),
    );
  }
}

class DataFromAPI extends StatefulWidget {
  @override
  _DataFromAPIState createState() => _DataFromAPIState();
}

final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
final TextEditingController _selectedStatus = TextEditingController();

String declineStatus = 'Decline';
DataModel? _dataModel;

class _DataFromAPIState extends State<DataFromAPI> {
  Future getTestimonialData() async {
    var response = await http.get(Uri.https('gbv-beta.herokuapp.com', '/get/'));
    var jsonData = jsonDecode(response.body);
    List<testimonial> users = [];

    for (var u in jsonData) {
      testimonial user = testimonial(u["user"], u["testimonial_descr"],
          u["testimonial_id"], u["testimonial_date"], u["status"]);
      users.add(user);
    }
    print(users.length);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('View Testimonial'),
          backgroundColor: Colors.red,
        ),
        body: Container(
            child: Card(
                child: FutureBuilder(
                    future: getTestimonialData(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.data == null) {
                        return Container(
                          child: const Center(child: Text('loading...')),
                        );
                      } else
                        // ignore: curly_braces_in_flow_control_structures
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(snapshot.data[index].user,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                subtitle: Text(
                                    " \n" +
                                        snapshot.data[index].testimonial_descr +
                                        "\n" +
                                        snapshot.data[index].testimonial_date +
                                        "\n",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500)),
                                trailing: SizedBox(
                                  height: 168,
                                  width: 168,
                                  child: myLayoutWidget(
                                      snapshot.data[index].testimonial_id),
                                ),
                              );
                            });
                    }))));
  }

  Widget myLayoutWidget(int testimonial_id) {
    return Container(
      child: Row(
        children: <Widget>[
          ButtonTheme(
            minWidth: 4,
            child: RaisedButton(
              onPressed: () async {
                showToastAccept();
                String status = 'approve';
                DataModel? data = await submitData(status, testimonial_id);
                setState(() {
                  _dataModel = data;
                });
              },
              child: const Text(
                "Approve",
              ),
            ),
          ),
          Text(" "),
          ButtonTheme(
            minWidth: 5,
            child: RaisedButton(
              child: const Text("Decline"),
              color: Colors.red,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FeedbackDialog(
                              testimId: testimonial_id.toString(),
                            )));
              },
            ),
          ),
        ],
      ),
    );
  }

  void showToastAccept() => Fluttertoast.showToast(
        msg: "Testimonial Approved",
        fontSize: 15,
        gravity: ToastGravity.BOTTOM,
      );
}

Future<DataModel> submitData(String status, int testimonial_id) async {
  final response = await http.put(
      Uri.https('gbv-beta.herokuapp.com', '/update/testimony/$testimonial_id'),
      body: {
        "status": status,
      });
  if (response.statusCode == 200) {
    String responseString = response.body;

    return dataModelFromJson(responseString);
  } else {
    throw Exception('Failed to load info');
  }
}

class testimonial {
  final String user, testimonial_descr, testimonial_date, status;
  final int testimonial_id;
  testimonial(this.user, this.testimonial_descr, this.testimonial_id,
      this.testimonial_date, this.status);
}
