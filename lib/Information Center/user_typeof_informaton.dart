import 'package:completereport/Information%20Center/view_aboutapp.dart';
import 'package:completereport/Information%20Center/view_latest_updates.dart';
import 'package:flutter/material.dart';

class TYPEINFORMATION extends StatefulWidget {
  const TYPEINFORMATION({Key? key}) : super(key: key);

  @override
  State<TYPEINFORMATION> createState() => _TYPEINFORMATIONState();
}

class _TYPEINFORMATIONState extends State<TYPEINFORMATION> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LATESTUPDATES()));
                },
                child: Text('Upcoming Events'),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 50),
                    primary: Colors.red[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ABOUTAPP()));
                },
                child: Text('Tips'),
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
