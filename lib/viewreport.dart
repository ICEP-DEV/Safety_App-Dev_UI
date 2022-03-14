import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:url_launcher/link.dart';

class DataFromAPI extends StatefulWidget {
  @override
  _DataFromAPIState createState() => _DataFromAPIState();
}

class _DataFromAPIState extends State<DataFromAPI> {
  Future getReportedData() async {
    var response = await http.get(Uri.http('10.0.2.2:5001', '/viewreport/'));
    var jsonData = jsonDecode(response.body);
    List<Incident> reported_incident = [];
    for (var u in jsonData) {
      Incident incident = Incident(u['report_num'], u['dateTime'],
          u['incidentType'], u['incident_desc'], u['location'], u['image']);
      reported_incident.add(incident);
    }
    return reported_incident;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reported Data'),
        centerTitle: true,
        backgroundColor: Colors.red,
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
                    child: Text("No data"),
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
                            snapshot.data[i].report_num.toString() +
                                ':   ' +
                                "Incident Type: " +
                                snapshot.data[i].incidentType,
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "[incident_desc] :  " +
                                snapshot.data[i].incident_desc,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '[Address] : ' + snapshot.data[i].location,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(snapshot.data[i].dateTime + "\n"),
                          Link(
                            uri: Uri.parse(snapshot.data[i].image),
                            builder: (context, followLink) => GestureDetector(
                              onTap: followLink,
                              child: Text(
                                'Click this link to check for downloads',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '-----------------------------------------------------------------------------------------------',
                            textAlign: TextAlign.left,
                          ),
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

class Incident {
  late final String dateTime, incidentType, incident_desc, location, image;
  late final int report_num;
  Incident(this.report_num, this.dateTime, this.incidentType,
      this.incident_desc, this.location, this.image);
}
