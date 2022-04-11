import 'package:completereport/Home/main_home.dart';
import 'package:completereport/Home/usertunnel.dart';
import 'package:flutter/material.dart';

class UserHome extends StatefulWidget {
  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        title: Text(""),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 700,
                height: 300,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('lib/Home/assets/img2.png')),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserTunnel()));
                },
                child: Text('Tunnel'),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 50),
                    primary: Colors.red[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainHome()));
                },
                child: Text('Sign Off'),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 50),
                    primary: Colors.red[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
