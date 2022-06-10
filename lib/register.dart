import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'otp.dart';
import 'registerModel.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

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
  String message = "";
  String randomNumber1 = 'x';
  String randomNumber2 = 'y';
  String randomNumber3 = 'z';
  String randomNumber4 = 'j';
  String otp = "";

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
          return "contact details Required";
        } else if (value.length != 10) {
          return "Incorrect contact details , Enter valid South African contacts";
        } else if (value[0] != "0" || value[1] == "0") {
          return "Incorrect contact details , Enter valid South African contacts";
        }
      },
      onSaved: (String? value) {
        phoneNumber = value!;
      },
    );
  }

  Widget _buildStaffStudent() {
    randomNumber1 = (Random().nextInt(9) + 1).toString();
    randomNumber2 = (Random().nextInt(9) + 1).toString();
    randomNumber3 = (Random().nextInt(9) + 1).toString();
    randomNumber4 = (Random().nextInt(9) + 1).toString();
    otp = randomNumber1 + randomNumber2 + randomNumber3 + randomNumber4;
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.add_task),
        labelText: "Student No / Staff No",
      ),
      keyboardType: TextInputType.number,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Student / Staff Number Required";
        } else if (value.length != 9 && value.length != 6) {
          return " Invalid Student/ Staff number";
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

  //email otp code
  email_otp() async {
    String username = 'molepollefentse121@gmail.com';
    String password = 'mszuslkqotjmgkpl';

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = Address(username, 'Safety App')
      ..recipients.add(email)
      // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      // ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'OTP PIN ::  ${DateTime.now()}'
      // ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html =
          "<h4>OTP PIN FOR SAFETY APP</h4>\n<p>your OTP pin is  ${otp}</p>"; // body of email

    try {
      final sendReport = await send(message, smtpServer);

      print(
          'email sent: ' + sendReport.toString()); //print if the email is sent
      Fluttertoast.showToast(
          msg: 'email sent',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
    } on MailerException catch (e) {
      print('email not sent. \n' + e.toString());
      Fluttertoast.showToast(
          msg: 'email not sent',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.red[700],
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

                    DataModel? data = await submitData(
                        surname,
                        name,
                        otherPhoneNumber,
                        select_gender,
                        staff_student,
                        address,
                        phoneNumber,
                        email,
                        otp,
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
      String otp,
      String password) async {
    var response = await http
        .post(Uri.https('gbv-beta.herokuapp.com', 'user/auth_reg'), body: {
      "surname": surname,
      "name": name,
      "other_contact": otherPhoneNumber,
      "gender": select_gender,
      "user_id": staff_student,
      "address": address,
      "trusted_contact": phoneNumber,
      "email": email,
      "otp": otp,
      "password": password,
    });
    var data = response.body.toString();
    message = data;
    print("OTP is " + otp);
    print(data);
    print(response.statusCode);

    if (RegExp('User already registered').hasMatch(data)) {
      final text = 'User already registered';
      final snackBar = SnackBar(
        duration: Duration(minutes: 3),
        content: Text(text),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (RegExp('User is not registered for 2022 ').hasMatch(data)) {
      final text = 'User is not registered with TUT for 2022';
      final snackBar = SnackBar(
        duration: Duration(minutes: 3),
        content: Text(text),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final text = 'Account registered';
      final snackBar = SnackBar(content: Text(text));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      email_otp();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTP(
                    otp: otp,
                    email: email,
                  )));
    }

    if (response.statusCode == 200) {
      String responseString = response.body;
      message = responseString;
      dataModelFromJson(message);
    }
  }
}
