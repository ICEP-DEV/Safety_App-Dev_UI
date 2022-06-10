import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:completereport/view_testinony/view_model.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class FeedbackDialog extends StatefulWidget {
  String testimId;
  //String selectedStatus;
  FeedbackDialog({required this.testimId});

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController viewController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool isAdd = false;
  DataModel? _dataModel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: viewController,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            hintText: 'Enter your feedback here',
            filled: true,
          ),
          maxLines: 10,
          maxLength: 5000,
          textInputAction: TextInputAction.done,
          validator: (String? text) {
            if (text == null || text.isEmpty) {
              return 'Please enter a value';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('Send'),
          onPressed: () async {
            showToastDecline();
            DataModel? data = await _submitData(
                viewController, declineStatus, widget.testimId);
            if (mounted) {
              setState(() {
                _dataModel = data;
                if (_formKey.currentState!.validate()) {
                  return;
                }
              });
            }
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => TestimDataFromAPI()));
          },
        ),
      ],
    );
  }

  void showToastDecline() => Fluttertoast.showToast(
        msg: "Testimonial Declined",
        fontSize: 15,
        gravity: ToastGravity.BOTTOM,
      );

  Future<DataModel?> _submitData(TextEditingController viewController,
      declineStatus, String testimonial_id) async {
    var response = await http.put(
        Uri.https(
            'gbv-beta.herokuapp.com', '/update/testimony/$testimonial_id'),
        body: {
          "feedback": viewController.text,
          "status": declineStatus,
          "testimonial_id": testimonial_id,
        });
    var data = response.body;
    print(data);
    print(declineStatus);
    print(testimonial_id);
    if (response.statusCode == 200) {
      String responseString = response.body;
      dataModelFromJson(responseString);
    } else
      return null;
  }
}
