import 'package:completereport/Home/vechome.dart';
import 'package:completereport/viewreport.dart';
import 'package:flutter/material.dart';

class VECTunnel extends StatefulWidget {
  @override
  State<VECTunnel> createState() => _VECTunnelState();
}

class _VECTunnelState extends State<VECTunnel> {
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
              CircleAvatar(
                backgroundImage: AssetImage('lib/Home/assets/img3.png'),
                radius: 130,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => VECHome()));
                },
                child: Text('Home'),
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
                      MaterialPageRoute(builder: (context) => DataFromAPI()));
                },
                child: Text('Reported Cases'),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 50),
                    primary: Colors.red[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
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
                onPressed: () {},
                child: Text('Share Room'),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 50),
                    primary: Colors.red[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
