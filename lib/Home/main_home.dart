import 'package:completereport/Home/userhome.dart';
import 'package:completereport/Home/vechome.dart';
import 'package:completereport/register.dart';
import 'package:flutter/material.dart';

class MainHome extends StatefulWidget {
  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
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
                      image: AssetImage('lib/Home/assets/img1.jpg')),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserHome()));
                },
                child: Text('User Login'),
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
                      MaterialPageRoute(builder: (context) => VECHome()));
                },
                child: Text('VEC Login'),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterAccount()));
                },
                child: Text('Sign Up'),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 50),
                    primary: Colors.red[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
