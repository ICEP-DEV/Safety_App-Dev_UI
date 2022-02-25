import 'package:flutter/material.dart';
import 'package:v_chat2/screens.dart/home_screen.dart';

class ButtonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red, title: Text("Chat Request")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          child: Text(
            'Request Chat',
          ),
        ),
      ),
    );
  }
}
