import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class LATESTUPDATES extends StatefulWidget {
  const LATESTUPDATES({Key? key}) : super(key: key);

  @override
  State<LATESTUPDATES> createState() => _LATESTUPDATESState();
}

class _LATESTUPDATESState extends State<LATESTUPDATES> {
  Future getReportedData() async {
    var response =
        await http.get(Uri.https('gbv-beta.herokuapp.com', '/viewevent'));
    var jsonData = jsonDecode(response.body);
    List<Updates> latest_updates = [];
    for (var u in jsonData) {
      Updates update = Updates(u['title'], u['description'], u['date']);
      latest_updates.add(update);
    }
    return latest_updates;
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
                    child: Text("No Updates"),
                  ),
                );
              } else
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, i) {
                      return RefreshIndicator(
                        onRefresh: getReportedData,
                        child: Column(children: [
                          Text(
                            "Date Updated :   " + snapshot.data[i].date,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
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

class Updates {
  late final String title, description, date;
  Updates(this.title, this.description, this.date);
}
