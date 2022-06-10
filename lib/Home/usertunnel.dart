import 'package:completereport/Home/userhome.dart';
import 'package:completereport/Information%20Center/user_typeof_informaton.dart';
import 'package:completereport/Login/user_login.dart';
import 'package:completereport/addtestimonial.dart';
import 'package:completereport/chat_app/main.dart';
import 'package:completereport/report.dart';

import 'package:flutter/material.dart';

class UserTunnel extends StatefulWidget {
  @override
  State<UserTunnel> createState() => _UserTunnelState();
  String username;
  UserTunnel({required this.username});
}

class _UserTunnelState extends State<UserTunnel> {
  String student_number = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        title: Text(""),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          color: Colors.black87,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Text(
                  "Signout",
                  style: TextStyle(
                      color: Colors.red[700], fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
              SizedBox(height: 10),
              CircleAvatar(
                backgroundImage: AssetImage('lib/Home/assets/img3.png'),
                radius: 130,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TYPEINFORMATION()));
                },
                child: Text('Information Center'),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 50),
                    primary: Colors.red[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (student_number != widget.username) {
                    student_number = widget.username;
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ReportIncidents(student_number: student_number)));
                },
                child: Text('Emegency Report'),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 50),
                    primary: Colors.red[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddTestimonial(student_number: student_number)));
                },
                child: Text('Share Room'),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 50),
                    primary: Colors.red[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp4()));
                },
                child: Text('Request Chat'),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 50),
                    primary: Colors.red[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
