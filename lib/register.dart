import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gcloud/pubsub.dart';
import 'registerModel.dart';
import 'package:http/http.dart' as http;

class RegisterAccount extends StatefulWidget {
  @override
  State<RegisterAccount> createState() => _RegisterAccountState();
}

class _RegisterAccountState extends State<RegisterAccount> {
  String name = "";
  String surname = "";
  String email = "";
  String confirmPassword = "";
  String password = "";
  String phoneNumber = "";
  String otherPhoneNumber = "";
  String staff_student = "";
  String address = "";
  String select_gender = "Male";
  String databaseUserId = "";
  String message = "aassddd";

  final List<String> gender = ["Male", "Female"];
  bool _obscureText = true;
  DataModel? _dataMOdel;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.add_task),
        labelText: "Name",
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Name is Required";
        }
      },
      onSaved: (String? value) {
        name = value!;
      },
    );
  }

  Widget _buildAddress() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.add_location_alt),
        labelText: "Address",
        fillColor: Colors.grey[300],
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Address is Required";
        }
      },
      onSaved: (String? value) {
        address = value!;
      },
    );
  }

  Widget _buildSurname() {
    return TextFormField(
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.add_task), labelText: "Surname"),
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Surname  is Required";
        }
      },
      onSaved: (String? value) {
        surname = value!;
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(
          // border: const UnderlineInputBorder(),
          filled: true,
          prefixIcon: Icon(Icons.email),
          labelText: "Email Address",
          fillColor: Colors.grey[300]),
      keyboardType: TextInputType.emailAddress,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Email is Required";
        }
        if (!RegExp(
          '@.',
        ).hasMatch(value)) {
          return "Please enter a valid email address";
        }
      },
      onSaved: (String? value) {
        email = value!;
      },
    );
  }

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
        labelText: " Comfirm Password",
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

  Widget _buildPhoneNumber() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.add_call),
        labelText: "Contact Details",
      ),
      keyboardType: TextInputType.phone,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "your contact details is Required";
        }
      },
      onSaved: (String? value) {
        phoneNumber = value!;
      },
    );
  }

  Widget _buildStaffStudent() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.add_task),
        labelText: "Student No / Staff No",
      ),
      keyboardType: TextInputType.number,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Student / Staff Number is Required";
        } else if (value.length != 9 && value.length != 6) {
          return " invalid Student/ staff number";
        }

        staff_student = value;
      },
      onSaved: (String? value) {
        staff_student = value!;
      },
    );
  }

  Widget _buildOtherPhoneNumber() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.add_call),
        labelText: "  Other Contacts (Optional)",
      ),
      keyboardType: TextInputType.phone,
      onSaved: (String? value) {
        otherPhoneNumber = value!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Register Account"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStaffStudent(),
                _buildName(),
                _buildSurname(),
                Row(children: [
                  Text("    "),
                  DropdownButton<String>(
                    isExpanded: false,
                    iconSize: 45,
                    iconEnabledColor: Colors.red[700],
                    value: select_gender,
                    borderRadius: BorderRadius.circular(15),
                    onChanged: (value) {
                      setState(() {
                        select_gender = value!;
                      });
                    },
                    items: gender.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                  ),
                ]), //-------------------
                _buildEmail(),
                _buildPhoneNumber(),
                _buildOtherPhoneNumber(),
                _buildAddress(),
                _buildPassword(),
                _buildConfirmPassword(),

                //Drop down button
                Text(message),
                RaisedButton(
                  color: Colors.red,
                  child: Text("Register"),
                  onPressed: () async {
                    if (!_formkey.currentState!.validate()) {
                      return;
                    }
                    _formkey.currentState!.save();

                    DataModel? data = await submitData(
                        surname,
                        name,
                        otherPhoneNumber,
                        select_gender,
                        staff_student,
                        address,
                        phoneNumber,
                        email,
                        password);
                    setState(() {
                      _dataMOdel = data!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<DataModel?> submitData(
      String surname,
      String name,
      String otherPhoneNumber,
      String select_gender,
      String staff_student,
      String address,
      String phoneNumber,
      String email,
      String password) async {
    var response =
        await http.post(Uri.http('10.0.2.2:5000', 'auth_reg'), body: {
      "surname": surname,
      "name": name,
      "other_contact": otherPhoneNumber,
      "gender": select_gender,
      "user_id": staff_student,
      "address": address,
      "trusted_contact": phoneNumber,
      "email": email,
      "password": password,
    });
    var data = response.body.toString();
    message = data;

    //print(notifyMessage);
    Fluttertoast.showToast(
        msg: 'successfully registered an account',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
    if (response.statusCode == 200) {
      String responseString = response.body;

      dataModelFromJson(responseString);
    }
  }
}
