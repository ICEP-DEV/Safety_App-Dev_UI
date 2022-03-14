import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  String password = "";
  String phoneNumber = "";
  String otherPhoneNumber = "0000000000";
  String staff_student = "";
  String address = "";
  String select_gender = "Male";
  final List<String> gender = ["Male", "Female"];
  DataModel? _dataMOdel;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
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
      decoration: InputDecoration(labelText: 'Address'),
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
      decoration: InputDecoration(labelText: 'Surname'),
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
      decoration: InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Email is Required";
        }
        if (!RegExp('@').hasMatch(value)) {
          return "Please enter a valid email address";
        }
        return null;
      },
      onSaved: (String? value) {
        email = value!;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password'),
      keyboardType: TextInputType.visiblePassword,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Password is Required";
        }
      },
      onSaved: (String? value) {
        password = value!;
      },
    );
  }

  Widget _buildPhoneNumber() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'User Phone Number'),
      keyboardType: TextInputType.phone,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "User Phone Number is Required";
        }
      },
      onSaved: (String? value) {
        phoneNumber = value!;
      },
    );
  }

  Widget _buildStaffStudent() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Student Number or Staff Number'),
      keyboardType: TextInputType.number,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Student / Staff Number is Required";
        }
        //if (value.length != 12 || value.length != 9) {
        // return "Invalid Student / Staff Number";
        // }
      },
      onSaved: (String? value) {
        staff_student = value!;
      },
    );
  }

  Widget _buildOtherPhoneNumber() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Other Phone Number (optional)'),
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
                _buildName(),
                _buildSurname(),
                _buildEmail(),
                _buildPhoneNumber(),
                _buildOtherPhoneNumber(),
                _buildAddress(),
                _buildStaffStudent(),
                _buildPassword(),

                //Drop down button
                DropdownButton<String>(
                  isExpanded: true,
                  iconSize: 45,
                  iconEnabledColor: Colors.red[700],
                  value: select_gender,
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
                ), //-------------------

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

                    print(address);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
  var response = await http.post(Uri.http('10.0.2.2:5003', 'register'), body: {
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
  var data = response.body;
  print(data);
  Fluttertoast.showToast(
      msg: 'successfully registered an account',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM);
  if (response.statusCode == 200) {
    String responseString = response.body;
    dataModelFromJson(responseString);
  }
}
