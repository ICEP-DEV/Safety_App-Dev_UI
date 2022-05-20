import 'dart:convert';
import 'package:admin/common/app_colors.dart';
import 'package:admin/pages/VEC/vec_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class View_VEC extends StatefulWidget {
  @override
  State<View_VEC> createState() => _View_VECState();
}

class _View_VECState extends State<View_VEC> {
  var _result;

  Future getRegisteredVec() async {
    var response =
        await http.get(Uri.https('gbv-beta.herokuapp.com', '/api/view/'));
    var jsonData = jsonDecode(response.body);
    print(jsonData);

    List<Vec> registered_vec = [];
    for (var u in jsonData) {
      Vec vec_details = Vec(u['vec_id'], u['employee_name'], u['contact_num'],
          u['office_num'], u['Chat_id'], u["email"], u["surname"], u["DOB"]);
      registered_vec.add(vec_details);
    }

    return registered_vec;
  }

  TextEditingController Name = TextEditingController();
  TextEditingController Surname = TextEditingController();
  TextEditingController Contacts = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Office = TextEditingController();
  // Name Dialog---------------------------------------------------------------------------------------------------
  createAlertDialogName(BuildContext context, int vec_id, String phoneNumber,
      String officeNumber, String email, String surname, String date_of_birth) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("New Name"),
            content: TextField(
              controller: Name,
            ),
            actions: [
              MaterialButton(
                  elevation: 5.0,
                  child: Text("Submit"),
                  onPressed: () async {
                    final response = await http.put(
                        Uri.https('gbv-beta.herokuapp.com', '/api/update/'),
                        body: {
                          "vec_id": vec_id.toString(),
                          "employee_name": Name.text,
                          "contact_num": phoneNumber,
                          "office_num": officeNumber,
                          "email": email,
                          "surname": surname,
                          "DOB": date_of_birth,
                        });
                    var data = response.body;
                    print(data);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => View_VEC()));
                    if (response.statusCode == 200) {
                      String responseString = response.body;
                      VECdataModelFromJson(responseString);
                    }
                    Navigator.of(context).pop(Name.text);
                  }),
            ],
          );
        });
  }

  //Surname Dialog-----------------------------------------------------------------------------------------------------

  createAlertDialogSurname(BuildContext context, int vec_id, String phoneNumber,
      String officeNumber, String email, String name, String date_of_birth) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("New Surname"),
            content: TextField(
              controller: Surname,
            ),
            actions: [
              MaterialButton(
                  elevation: 5.0,
                  child: Text("Submit"),
                  onPressed: () async {
                    final response = await http.put(
                        Uri.https('gbv-beta.herokuapp.com', '/api/update/'),
                        body: {
                          "vec_id": vec_id.toString(),
                          "employee_name": name,
                          "contact_num": phoneNumber,
                          "office_num": officeNumber,
                          "email": email,
                          "surname": Surname.text,
                          "DOB": date_of_birth,
                        });
                    var data = response.body;
                    print(data);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => View_VEC()));
                    if (response.statusCode == 200) {
                      String responseString = response.body;
                      VECdataModelFromJson(responseString);
                    }
                  }),
            ],
          );
        });
  }

  //contact details dialog---------------------------------------------------------------------------------------

  createAlertDialogContact(BuildContext context, int vec_id, String surname,
      String officeNumber, String email, String name, String date_of_birth) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("New Contact details"),
            content: TextField(
              controller: Contacts,
            ),
            actions: [
              MaterialButton(
                  elevation: 5.0,
                  child: Text("Submit"),
                  onPressed: () async {
                    final response = await http.put(
                        Uri.https('gbv-beta.herokuapp.com', '/api/update/'),
                        body: {
                          "vec_id": vec_id.toString(),
                          "employee_name": name,
                          "contact_num": Contacts.text,
                          "office_num": officeNumber,
                          "email": email,
                          "surname": surname,
                          "DOB": date_of_birth,
                        });
                    var data = response.body;
                    print(data);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => View_VEC()));
                    if (response.statusCode == 200) {
                      String responseString = response.body;
                      VECdataModelFromJson(responseString);
                    }
                    Navigator.of(context).pop(Name.text);
                  }),
            ],
          );
        });
  }
  //dialog for email-------------------------------------------------------------------------------------------------

  createAlertDialogEmail(BuildContext context, int vec_id, String surname,
      String officeNumber, String contact, String name, String date_of_birth) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("New Email address"),
            content: TextField(
              controller: Email,
            ),
            actions: [
              MaterialButton(
                  elevation: 5.0,
                  child: Text("Submit"),
                  onPressed: () async {
                    final response = await http.put(
                        Uri.https('gbv-beta.herokuapp.com', '/api/update/'),
                        body: {
                          "vec_id": vec_id.toString(),
                          "employee_name": name,
                          "contact_num": contact,
                          "office_num": officeNumber,
                          "email": Email.text,
                          "surname": surname,
                          "DOB": date_of_birth,
                        });
                    var data = response.body;
                    print(data);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => View_VEC()));
                    if (response.statusCode == 200) {
                      String responseString = response.body;
                      VECdataModelFromJson(responseString);
                    }
                    Navigator.of(context).pop(Name.text);
                  }),
            ],
          );
        });
  }

  ///office number Dialog------------------------------------------------------------------------------------------------------------

  createAlertDialogOffice(BuildContext context, int vec_id, String surname,
      String email, String contact, String name, String date_of_birth) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("New Office Number"),
            content: TextField(
              controller: Office,
            ),
            actions: [
              MaterialButton(
                  elevation: 5.0,
                  child: Text("Submit"),
                  onPressed: () async {
                    final response = await http.put(
                        Uri.https('gbv-beta.herokuapp.com', '/api/update/'),
                        body: {
                          "vec_id": vec_id.toString(),
                          "employee_name": name,
                          "contact_num": contact,
                          "office_num": Office.text,
                          "email": email,
                          "surname": surname,
                          "DOB": date_of_birth,
                        });
                    var data = response.body;
                    print(data);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => View_VEC()));
                    if (response.statusCode == 200) {
                      String responseString = response.body;
                      VECdataModelFromJson(responseString);
                    }
                    Navigator.of(context).pop(Name.text);
                  }),
            ],
          );
        });
  }

  DataModel? _dataMOdel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Registered VEC'),
        centerTitle: true,
        backgroundColor: Colors.red[700],
      ),
      body: Container(
        color: Colors.grey.shade300,
        //from here
        child: Card(
          color: Colors.grey.shade300,
          child: FutureBuilder(
            future: getRegisteredVec(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("Loading"),
                  ),
                );
              } else
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, i) {
                      return RefreshIndicator(
                        onRefresh: getRegisteredVec,
                        child: Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Employee Name   :     " +
                                      snapshot.data[i].employee_name,
                                  style: TextStyle(color: AppColor.black),
                                ),
                                SizedBox(width: 40),
                                IconButton(
                                    onPressed: () async {
                                      createAlertDialogName(
                                          context,
                                          snapshot.data[i].vec_id,
                                          snapshot.data[i].contact_num,
                                          snapshot.data[i].office_num,
                                          snapshot.data[i].email,
                                          snapshot.data[i].surname,
                                          snapshot.data[i].DOB);
                                    },
                                    icon:
                                        Icon(Icons.edit, color: AppColor.red)),
                              ]),
                          SizedBox(height: 5),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  " Employee surname :    " +
                                      snapshot.data[i].surname,
                                  style: TextStyle(color: AppColor.black),
                                ),
                                SizedBox(width: 40),
                                IconButton(
                                    onPressed: () async {
                                      createAlertDialogSurname(
                                          context,
                                          snapshot.data[i].vec_id,
                                          snapshot.data[i].contact_num,
                                          snapshot.data[i].office_num,
                                          snapshot.data[i].email,
                                          snapshot.data[i].employee_name,
                                          snapshot.data[i].DOB);
                                    },
                                    icon:
                                        Icon(Icons.edit, color: AppColor.red)),
                              ]),
                          SizedBox(height: 5),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Date Of Bith :    " + snapshot.data[i].DOB,
                                  style: TextStyle(color: AppColor.black),
                                ),
                                SizedBox(width: 40),
                                Text(" "),
                              ]),
                          SizedBox(height: 5),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Contact Details :   " +
                                      snapshot.data[i].contact_num,
                                  style: TextStyle(color: AppColor.black),
                                ),
                                SizedBox(width: 40),
                                IconButton(
                                    onPressed: () async {
                                      createAlertDialogContact(
                                          context,
                                          snapshot.data[i].vec_id,
                                          snapshot.data[i].surname,
                                          snapshot.data[i].office_num,
                                          snapshot.data[i].email,
                                          snapshot.data[i].employee_name,
                                          snapshot.data[i].DOB);
                                    },
                                    icon:
                                        Icon(Icons.edit, color: AppColor.red)),
                              ]),
                          SizedBox(height: 5),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Email :  " + snapshot.data[i].email,
                                  style: TextStyle(color: AppColor.black),
                                ),
                                SizedBox(width: 40),
                                IconButton(
                                    onPressed: () async {
                                      createAlertDialogEmail(
                                          context,
                                          snapshot.data[i].vec_id,
                                          snapshot.data[i].surname,
                                          snapshot.data[i].office_num,
                                          snapshot.data[i].contact_num,
                                          snapshot.data[i].employee_name,
                                          snapshot.data[i].DOB);
                                    },
                                    icon:
                                        Icon(Icons.edit, color: AppColor.red)),
                              ]),
                          SizedBox(height: 5),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Office Number :    " +
                                      snapshot.data[i].office_num,
                                  style: TextStyle(color: AppColor.black),
                                ),
                                SizedBox(width: 40),
                                IconButton(
                                    onPressed: () async {
                                      createAlertDialogOffice(
                                          context,
                                          snapshot.data[i].vec_id,
                                          snapshot.data[i].surname,
                                          snapshot.data[i].email,
                                          snapshot.data[i].contact_num,
                                          snapshot.data[i].employee_name,
                                          snapshot.data[i].DOB);
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: AppColor.red,
                                    )),
                              ]),
                          SizedBox(height: 8),
                          ElevatedButton(
                              onPressed: () async {
                                DataModel? data =
                                    await Delete(snapshot.data[i].vec_id);
                                setState(() {
                                  _dataMOdel = data!;
                                });
                              },
                              child: Text('Delete')),
                          Text(
                            '===================================================',
                            textAlign: TextAlign.left,
                          ),
                        ]),
                      );
                    });
            },
          ),
        ), //To here
      ),
    );
  }

  Future Delete(int vec_id) async {
    final response = await http
        .delete(Uri.https('gbv-beta.herokuapp.com', '/api/delete/$vec_id'));
    var data = response.body;
    print(data);
    Fluttertoast.showToast(
        msg: 'record deleted',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => View_VEC()));

    if (response.statusCode == 200) {
      String responseString = response.body;
      VECdataModelFromJson(responseString);
    }
  }
}

class Vec {
  late final String employee_name, contact_num, office_num, email, surname, DOB;
  late final int vec_id;
  late final int chat_id;
  Vec(
    this.vec_id,
    this.employee_name,
    this.contact_num,
    this.office_num,
    this.chat_id,
    this.email,
    this.surname,
    this.DOB,
  );
}
