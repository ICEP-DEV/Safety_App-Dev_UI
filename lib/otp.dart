import 'package:completereport/Login/user_login.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OTP extends StatefulWidget {
  String otp;
  String email;
  OTP({required this.otp, required this.email});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String otp_pin = "";

  Widget _buildOTP() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "OTP Pin",
        labelStyle: TextStyle(fontSize: 18, color: Colors.black),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "OTP is Required";
        } else if (value != widget.otp) {
          return "Incorrect OTP PIn";
        }
      },
      onSaved: (String? value) {
        otp_pin = value!;
      },
    );
  }

  email_otp() async {
    String username = 'molepollefentse121@gmail.com';
    String password = 'fefe@121';

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = Address(username, 'Safety App')
      ..recipients.add(widget.email)
      // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      // ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'OTP PIN ::  ${DateTime.now()}'
      // ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html =
          "<h4>OTP PIN FOR SAFETY APP</h4>\n<p>your OTP pin is  ${widget.otp}</p>"; // body of email

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
      body: Center(
        child: (Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Check your emails for the OTP Pin",
                    style: TextStyle(
                      letterSpacing: 2,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 15),
                  _buildOTP(),
                  SizedBox(height: 20),
                  ElevatedButton(
                      child: Text("Submit"),
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
                        Fluttertoast.showToast(
                            msg: 'OTP Submitted',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      }),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "didn't receive the OTP? click ",
                      ),
                      GestureDetector(
                          child: Text(
                            "Here",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            email_otp();
                          }),
                      Text(
                        ' to resend',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
