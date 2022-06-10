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
    var response =
        await http.get(Uri.https('gbv-beta.herokuapp.com', '/viewreport/'));
    var jsonData = jsonDecode(response.body);
    List<Incident> reported_incident = [];
    for (var u in jsonData) {
      Incident incident = Incident(
        u['report_num'],
        u['dateTime'],
        u['incidentType'],
        u['incident_desc'],
        u['location'],
        u["image"],
        u["user_id"],
      );
      reported_incident.add(incident);
    }
    return reported_incident;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Reported Information'),
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
                    child: Text("Loading"),
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
                            "Username :   ",
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            snapshot.data[i].user_id.toString(),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Incident Type :  ",
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            snapshot.data[i].incidentType,
                          ),
                          SizedBox(height: 10),
                          Text("Incident Description:  ",
                              style: TextStyle(
                                color: Colors.black,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                              textAlign: TextAlign.center),
                          Text(
                            snapshot.data[i].incident_desc,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Location:  ",
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            snapshot.data[i].location,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Date Time :   ",
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            snapshot.data[i].dateTime + "\n",
                            textAlign: TextAlign.center,
                          ),
                          if (snapshot.data[i].image != "") //from here
                            Container(
                              width: 400,
                              height: 200,
                              alignment: Alignment.center,
                              child: Image.network(snapshot.data[i].image),
                            ),
                          if (snapshot.data[i].image != "")
                            Link(
                              uri: Uri.parse(snapshot.data[i].image),
                              builder: (context, followLink) => GestureDetector(
                                onTap: followLink,
                                child: Text(
                                  'Click this link to download image',
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
  late final int user_id;
  Incident(
    this.report_num,
    this.dateTime,
    this.incidentType,
    this.incident_desc,
    this.location,
    this.image,
    this.user_id,
  );
}
