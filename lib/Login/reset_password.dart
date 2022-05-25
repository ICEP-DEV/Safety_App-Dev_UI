import 'package:completereport/Login/LoginModel.dart';
import 'package:completereport/Login/user_login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _obscureText = true;
  String password = "";
  String confirmPassword = "";
  String username = "";
  DataModel? _dataMOdel;

  Widget _buildPassword() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
        labelText: "Password",
      ),
      keyboardType: TextInputType.visiblePassword,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Password is Required";
        } else if (value.length < 4) {
          return "Password is too short !! have atleast 4 characters";
        }
        password = value;
      },
      onSaved: (String? value) {
        password = value!;
      },
      obscureText: _obscureText,
    );
  }

  // confirm password
  Widget _buildConfirmPassword() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
        labelText: " Confirm Password",
      ),
      keyboardType: TextInputType.visiblePassword,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "confirm password";
        }
        confirmPassword = value;
        if (confirmPassword != password) {
          return "password dont match";
        }
      },
      onSaved: (String? value) {
        confirmPassword = value!;
      },
      obscureText: _obscureText,
    );
  }

  // build username

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
                  //confirm password
                  SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.only(left: 20),
                      child: _buildConfirmPassword(),
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
                          'Reset',
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
                          DataModel? data = await submitData(
                            password,
                            username,
                          );
                          setState(() {
                            _dataMOdel = data!;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
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
    var response = await http.put(
        Uri.https('gbv-beta.herokuapp.com', '/update/password/$username'),
        body: {
          "password": password,
          "user_id": username,
        });
    var data = response.body.toString();

    if (RegExp('successfully').hasMatch(data)) {
      Fluttertoast.showToast(
          msg: ' password successfully updated',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      Fluttertoast.showToast(
          msg: "user don't exists",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
    }

    if (response.statusCode == 200) {
      String responseString = response.body;
      LogindataModelFromJson(responseString);
    }
  }
}
