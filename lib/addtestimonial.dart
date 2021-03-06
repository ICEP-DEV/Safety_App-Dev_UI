import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: unnecessary_import
import 'dart:ui';
import 'testimonialModel.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTestimonial extends StatefulWidget {
  @override
  createState() => _AddTestimonial();
  String student_number;
  AddTestimonial({required this.student_number});
}

class _AddTestimonial extends State<AddTestimonial> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController testimonialController = TextEditingController();
  String Studentno = "";
  bool isAdd = false;
  final List<String> testimonial = [
    "Anonymous",
    "User",
  ];
  DataModel? _dataModel;

  // ignore: avoid_returning_null_for_void
  String? selectedName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testimonial'),
        backgroundColor: Colors.red[700],
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey.shade300,
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButton<String>(
              hint: const Text('Please Select'),
              value: selectedName,
              onChanged: (value) {
                setState(() {
                  selectedName = value!;
                });
              },
              items: testimonial.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem(
                  child: Text(value),
                  value: value,
                );
              }).toList(),
            ),

            Form(
              key: _formkey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                    ),
                    child: TextFormField(
                      controller: testimonialController,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.normal),
                      keyboardType: TextInputType.multiline,
                      minLines: 2,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 0.0),
                        ),
                        border: OutlineInputBorder(),
                        labelText: "Add Testimonial",
                        labelStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Testimonial field can't be empty.";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.center,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 1.0, color: Colors.red),
                        primary: Colors.black,
                        backgroundColor: Colors.red,
                        minimumSize: const Size(120, 40),
                        shape: const StadiumBorder()),
                    child: !isAdd
                        ? const Text('Save Testimonial')
                        : const CircularProgressIndicator(
                            strokeWidth: 2.5,
                            backgroundColor: Colors.black,
                          ),
                    onPressed: () async {
                      if (Studentno != widget.student_number) {
                        Studentno = widget.student_number;
                      }
                      DataModel? data = await submitData(
                          testimonialController, selectedName, Studentno);
                      Fluttertoast.showToast(
                          msg: ' Testimony saved',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM);

                      setState(() {
                        _dataModel = data;

                        if (!_formkey.currentState!.validate()) {
                          return;
                        }
                        setState(() {
                          isAdd = true;
                        });
                      });
                    }),
              ),
            ),
            //Code for navigation button added by ofentse on falicia code
            SizedBox(height: 10),

            //Until here
          ],
        ),
      ),
    );
  }
}

String? selectedName;

Future<DataModel?> submitData(
    TextEditingController controller, selectedName, String Studentno) async {
  var response =
      await http.post(Uri.https('gbv-beta.herokuapp.com', '/post/'), body: {
    "testimonial_descr": controller.text,
    "testimonial_date": DateTime.now().toString(),
    "user": selectedName.toString(),
    "user_id": Studentno,
  });
  var data = response.body;

  print(data);
  print(selectedName);
  if (response.statusCode == 200) {
    String responseString = response.body;
    dataModeFromJson(responseString);
  } else
    return null;
}

void dataModeFromJson(String responseString) {}
