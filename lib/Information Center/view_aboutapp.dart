import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ABOUTAPP extends StatefulWidget {
  const ABOUTAPP({Key? key}) : super(key: key);

  @override
  State<ABOUTAPP> createState() => _ABOUTAPPState();
}

class _ABOUTAPPState extends State<ABOUTAPP> {
  Future getReportedData() async {
    var response =
        await http.get(Uri.https('gbv-beta.herokuapp.com', '/viewsafetyinfo'));
    var jsonData = jsonDecode(response.body);
    List<ABOUT> about_app = [];
    for (var u in jsonData) {
      ABOUT about = ABOUT(
        u['title'],
        u['description'],
      );
      about_app.add(about);
    }
    return about_app;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information'),
        centerTitle: true,
        backgroundColor: Colors.red[700],
      ),
      body: Container(
        color: Colors.grey.shade300,
        //from here
        child: Card(
          color: Colors.grey.shade300,
          child: FutureBuilder(
            future: getReportedData(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("No Information"),
                  ),
                );
              } else
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, i) {
                      return RefreshIndicator(
                        onRefresh: getReportedData,
                        child: Column(children: [
                          SizedBox(height: 5),
                          Text(
                            snapshot.data[i].title,
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 15),
                          Text(
                            snapshot.data[i].description,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '-------------------------------------------------------------------------------------------',
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 15),
                        ]),
                      );
                    });
            },
          ),
        ), //To here
      ),
    );
  }
}

class ABOUT {
  late final String title, description;
  ABOUT(
    this.title,
    this.description,
  );
}
