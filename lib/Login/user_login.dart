import 'package:completereport/Admin/admin.dart';
import 'package:completereport/Home/usertunnel.dart';
import 'package:completereport/Home/vectunnel.dart';
import 'package:completereport/Login/LoginModel.dart';
import 'package:completereport/Login/reset_password.dart';
import 'package:completereport/register.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = "";
  String password = "";
  DataModel? _dataMOdel;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Widget _buildUserName() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: "Username",
        labelStyle: TextStyle(fontSize: 18, color: Colors.black),
      ),
      keyboardType: TextInputType.number,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Username is Required";
        }
      },
      onSaved: (String? value) {
        username = value!;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: "Password",
        labelStyle: TextStyle(fontSize: 18, color: Colors.black),
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          return "password is Required";
        }
      },
      onSaved: (String? value) {
        password = value!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 600,
                    height: 270,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('lib/Home/assets/END JBV.jpg')),
                    ),
                  ),
                  SizedBox(height: 30),
                  //userName Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.only(left: 20),
                      child: _buildUserName(),
                    ),
                  ),
                  SizedBox(height: 10),
                  //Password Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.only(left: 20),
                      child: _buildPassword(),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 19),
                      decoration: BoxDecoration(
                          color: Colors.red[700],
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12)),
                      child: GestureDetector(
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        onTap: () async {
                          if (!_formkey.currentState!.validate()) {
                            return;
                          }
                          _formkey.currentState!.save();
                          if (username == "2022" && password == "Admin2022") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminSite()));
                          } else if (username == "102022" &&
                              password == "vec102022") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VECTunnel()));
                          } else {
                            //
                            // DataModel? data = await submitData(
                            // password,
                            //username,
                            // );
                            //setState(() {
                            // _dataMOdel = data!;
                            // });

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UserTunnel(username: username)));
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Donot have an account? ",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        child: Text(
                          " Register Now",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterAccount()));
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Forgot Password?  ",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        child: Text(
                          "  Reset Now",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResetPassword()));
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<DataModel?> submitData(
    String password,
    String username,
  ) async {
    var response =
        await http.post(Uri.https('gbv-beta.herokuapp.com', '/auth'), body: {
      "password": password,
      "user_id": username,
    });
    var data = response.body.toString();
    if (RegExp('successful').hasMatch(data)) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => UserTunnel(username: username)));
    }

    if (response.statusCode == 200) {
      String responseString = response.body;
      LogindataModelFromJson(responseString);
    }
  }
}
