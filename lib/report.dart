import 'dart:typed_data';
import 'package:completereport/dataModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'api.dart';
import 'dataModel.dart';

class ReportIncidents extends StatefulWidget {
  @override
  _ReportIncidentsState createState() => _ReportIncidentsState();
  String student_number;

  ReportIncidents({required this.student_number});
}

class _ReportIncidentsState extends State<ReportIncidents> {
  DataModel? _dataMOdel;
  Uint8List? imageBytes;
  File? imageFile;
  late CloudApi api;
  String? _imageName;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('credentials.json').then((json) {
      api = CloudApi(json);
    });
  }

  String Studentno = "";
  String img = "no image";
  String location = 'Null, Press Button';
  var address = 'No address';
  String sent = 'Report not sent !!!';
  final List<String> crime = [
    "Theft",
    "Vandalism",
    "Murder",
    "Bulling",
    "GBV & F",
    "Injury"
  ];

  String selectedCrime = "Theft";
  //access the location

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    // print(placemarks);
    Placemark place = placemarks[0];
    address =
        '${place.street},${place.subLocality},${place.locality},${place.postalCode}, ${place.country}';
    setState(() {});
    address = address;
    return address;
  }

  //Description of incident
  TextEditingController _controller = TextEditingController();
  //Report button

  void _saveImage() async {
//upload to google cloud
    final response = await api.save(_imageName!, imageBytes!);
    print(response.downloadLink);
    img = response.downloadLink.toString();
    Fluttertoast.showToast(
        msg: ' image saved',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        title: Text("Please complete Report Form"),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade300,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red[700],
          child: Text(
            'Report',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            if (Studentno != widget.student_number) {
              Studentno = widget.student_number;
            }
            if (imageFile != null) {
              DataModel? data = await submitData(
                  selectedCrime, location, img, _controller, Studentno);
              setState(() {
                _dataMOdel = data!;
              });
            } else {
              DataModel? data = await submitData2(
                  selectedCrime, location, _controller, Studentno);
              setState(() {
                _dataMOdel = data!;
              });
            }
          }),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "INCIDENT TYPE:",
              style: TextStyle(
                letterSpacing: 2,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 4),
            DropdownButton<String>(
              isExpanded: true,
              iconSize: 36,
              iconEnabledColor: Colors.red[700],
              value: selectedCrime,
              onChanged: (value) {
                setState(() {
                  selectedCrime = value!;
                });
              },
              items: crime.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem(
                  child: Text(value),
                  value: value,
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            //Text Field
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "type here",
                labelText: "Tell your story",
                labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 200,
            ),
            SizedBox(height: 20),

            ElevatedButton(
                onPressed: () async {
                  Position position = await _getGeoLocationPosition();
                  location =
                      'Lat: ${position.latitude} , Long: ${position.longitude}';
                  GetAddressFromLatLong(position);
                  setState(() {});
                },
                child: Text('Get Location')),
            Text('${address}'),
            SizedBox(height: 3),
            if (imageFile != null) //from here

              Container(
                width: 300,
                height: 190,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(image: FileImage(imageFile!)),
                ),
              )
            else
              Container(
                width: 300,
                height: 190,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(width: 8, color: Colors.black54),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Image should appear here',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            SizedBox(height: 3),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () => getImage(source: ImageSource.camera),
                  child: Text('Capture '),
                )),
                SizedBox(width: 5),
                Expanded(
                    child: ElevatedButton(
                  onPressed: () => getImage(source: ImageSource.gallery),
                  child: Text('Gallery'),
                )),
                SizedBox(width: 7),
                ElevatedButton(
                    onPressed: () => _saveImage(), child: Text('save img')),
              ],
            ), //until here
            SizedBox(height: 30),
          ]),
        ),
      ),
    );
  }

  void getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(source: source);
    if (file?.path != null) {
      setState(() {
        imageFile = File(file!.path);
        imageBytes = imageFile!.readAsBytesSync();
        _imageName = imageFile!.path.split('/').last;
      });
    }
  }

  Future<DataModel?> submitData(String selectedCrime, String location,
      String img, TextEditingController controller, String Studentno) async {
    var response = await http
        .post(Uri.https('gbv-beta.herokuapp.com', '/reportincident/'), body: {
      "dateTime": DateTime.now().toString(),
      "incidentType": selectedCrime,
      "incident_desc": _controller.text,
      "location": address,
      "image": img,
      "user_id": Studentno,
    });
    var data = response.body;

    print(data);
    Fluttertoast.showToast(
        msg: 'Report sent',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ReportIncidents(
                  student_number: widget.student_number,
                )));
    if (response.statusCode == 200) {
      String responseString = response.body;
      dataMode_FromJson(responseString);
    }
  }

  Future<DataModel?> submitData2(String selectedCrime, String location,
      TextEditingController controller, String Studentno) async {
    var response = await http
        .post(Uri.https('gbv-beta.herokuapp.com', '/reportincident/'), body: {
      "dateTime": DateTime.now().toString(),
      "incidentType": selectedCrime,
      "incident_desc": _controller.text,
      "location": address,
      "user_id": Studentno,
    });
    var data = response.body;

    print(data);
    Fluttertoast.showToast(
        msg: 'Report sent',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                ReportIncidents(student_number: widget.student_number)));
    if (response.statusCode == 200) {
      String responseString = response.body;
      dataMode_FromJson(responseString);
    }
  }
}
