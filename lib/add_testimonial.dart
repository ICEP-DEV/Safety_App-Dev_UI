import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testim/user_model.dart';
import 'dart:ui';

class AddTestimonial extends StatefulWidget {
  const AddTestimonial({Key? key}) : super(key: key);

  @override
  createState() => _AddTestimonial();
}

class _AddTestimonial extends State<AddTestimonial> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController testimonialController = TextEditingController();

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
      appBar:
          AppBar(title: const Text('Testimonial'), backgroundColor: Colors.red),
      body: Container(
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
            //],
            // ),
            // ),

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
                      DataModel? data =
                          await submitData(testimonialController, selectedName);

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
          ],
        ),
      ),
    );
  }
}

// });
String? selectedName;
//print(selectedName);

Future<DataModel?> submitData(
    TextEditingController controller, selectedName) async {
  var response = await http.post(Uri.http('10.0.2.2:5001', '/post/'), body: {
    "testimonial_descr": controller.text,
    "testimonial_date": DateTime.now().toString(),
    "user": selectedName.toString(),
  });
  var data = response.body;
  print(data);
  if (response.statusCode == 200) {
    String responseString = response.body;
    dataModeFromJson(responseString);
  } else
    return null;
}
