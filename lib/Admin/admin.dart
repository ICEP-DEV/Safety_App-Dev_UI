import 'package:completereport/Admin/view_vec.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'vec_model.dart';

class AdminSite extends StatefulWidget {
  @override
  State<AdminSite> createState() => _AdminSiteState();
}

class _AdminSiteState extends State<AdminSite> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String name = "";
  String surname = "";
  String email = "";
  String phoneNumber = "";
  String date_of_birth = "";
  String officeNumber = "";
  DataModel? _dataMOdel;

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.add_task),
        labelText: " Enter Name",
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

  Widget _buildSurname() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.add_task),
        labelText: " Enter Surname",
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Surname is Required";
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
          labelText: " Enter Email Address",
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

  Widget _buildPhoneNumber() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.add_call),
        labelText: "Enter Contact Details",
      ),
      keyboardType: TextInputType.phone,
      validator: (String? value) {
        if (value!.isEmpty) {
          return " Contact details is Required";
        } else if (value.length != 10) {
          return "Incorrect contact details , Enter valid south african contacts";
        } else if (value[0] != "0" || value[1] == "0") {
          return "Incorrect contact details , Enter valid South African contacts";
        }
      },
      onSaved: (String? value) {
        phoneNumber = value!;
      },
    );
  }

  Widget _buildDateOfBirth() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.add_task),
        labelText: "Enter Date of birth (numeric format)",
      ),
      keyboardType: TextInputType.phone,
      validator: (String? value) {
        if (value!.isEmpty) {
          return " Date of birth is Required";
        }
      },
      onSaved: (String? value) {
        date_of_birth = value!;
      },
    );
  }

  Widget _buildOfficeNumber() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.add_task),
        labelText: "Enter Office Number",
      ),
      keyboardType: TextInputType.phone,
      validator: (String? value) {
        if (value!.isEmpty) {
          return " Office Number is Required";
        }
      },
      onSaved: (String? value) {
        officeNumber = value!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        title: Text("Register VEC"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red[700],
          child: Text(
            'view',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => View_VEC()));
          }),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildName(),
                SizedBox(height: 5),
                _buildSurname(),
                SizedBox(height: 5),
                _buildDateOfBirth(),
                SizedBox(height: 5),
                _buildPhoneNumber(),
                SizedBox(height: 5),
                _buildEmail(),
                SizedBox(height: 5),
                _buildOfficeNumber(),
                SizedBox(height: 40),
                ElevatedButton(
                  child: Text("Register"),
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 50),
                      primary: Colors.red[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                  onPressed: () async {
                    if (!_formkey.currentState!.validate()) {
                      return;
                    }
                    _formkey.currentState!.save();
                    DataModel? data = await submitData(name, surname,
                        date_of_birth, phoneNumber, email, officeNumber);
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

  Future<DataModel?> submitData(String name, surname, String date_of_birth,
      String phoneNumber, String email, String officeNumber) async {
    var response = await http
        .post(Uri.https('gbv-beta.herokuapp.com', '/api/post/'), body: {
      "employee_name": name,
      "contact_num": phoneNumber,
      "office_num": officeNumber,
      "email": email,
      "surname": surname,
      "DOB": date_of_birth,
    });
    var data = response.body;

    print(data);
    Fluttertoast.showToast(
        msg: 'VEC Registered',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => AdminSite()));
    if (response.statusCode == 200) {
      String responseString = response.body;
      VECdataModelFromJson(responseString);
    }
  }
}
