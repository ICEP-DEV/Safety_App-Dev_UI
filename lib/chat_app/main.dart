import 'package:flutter/material.dart';
import 'package:completereport/chat_app/providers/login.dart';
import 'package:completereport/chat_app/screens/login.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp4());
}

class MyApp4 extends StatelessWidget {
  const MyApp4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Socket.IO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: ChangeNotifierProvider(
        create: (context) => LoginProvider(),
        child: const LoginScreen(),
      ),
    );
  }
}
