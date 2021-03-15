import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

const String COLLECTION_NAME = 'posts';

/// Stores the image to cloud storage and data to firestore
class NewEntryPage extends StatefulWidget {
  static final routeName = 'newEntry';
  final String _imgPath;

  NewEntryPage(this._imgPath);

  @override
  _NewEntryPageState createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = Map(); // will be used to build the DTO
  LocationData locationData;
  var locationService = Location();

  @override
  void initState() {
    super.initState();
    initFormData();
  }

  /// will auto set the date and location info
  void initFormData() async {
    // set the date
    formData['date'] = DateTime.now();

    // set location based on device's location
    try {
      var _serviceEnabled = await locationService.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await locationService.requestService();
        if (!_serviceEnabled) {
          print('Failed to enable service. Returning.');
          return;
        }
      }

      var _permissionGranted = await locationService.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await locationService.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          print('Location service permission not granted. Returning.');
          return;
        }
      }
      locationData = await locationService.getLocation();
    } on PlatformException catch (e) {
      print('Error: ${e.toString()}, code: ${e.code}');
      locationData = null;
    }

    // update the formData's location data
    if (locationData == null) {
      formData['Latitude'] = formData['Longitude'] = '0';
    } else {
      formData['Latitude'] = locationData.latitude.toString();
      formData['Longitude'] = locationData.longitude.toString();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wasteagram'), centerTitle: true),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: ListView(
            children: [
              imageHolder(),
              const SizedBox(height: 12.0),
              inputField(),
              const SizedBox(height: 12.0),
              Builder(
                  builder: (context) => Semantics(
                        hint: 'upload image, location and quantity',
                        label: 'upload button',
                        button: true,
                        child: OutlineButton.icon(
                            padding: EdgeInsets.all(12.0),
                            icon: Icon(Icons.cloud_upload),
                            label: Text('Upload',
                                style: Theme.of(context).textTheme.headline4),
                            onPressed: () {
                              validateAndSave(context);
                            }),
                      ))
            ],
          ),
        ),
      ),
    );
  }

  Semantics inputField() {
    return Semantics(
      label: 'number input',
      onTapHint: 'enter the quantity of items',
      child: TextFormField(
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: 'Number of Items', border: OutlineInputBorder()),
        validator: (value) => nonEmptyField(value),
        onSaved: (String value) => formData['qty'] = int.parse(value),
      ),
    );
  }

  String nonEmptyField(String input) {
    if (input == null) {
      return 'This field can not be blank';
    }
    try {
      final int qty = int.parse(input);
      formData['qty'] = qty;
    } catch (FormatException) {
      return 'Please enter a valid number.';
    }
    return null;
  }

  void validateAndSave(BuildContext context) async {
    final curState = formKey.currentState;

    if (curState.validate()) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Saving entry...')));
      curState.save(); // saves form field to the formData object

      formData['picUrl'] = await postImgToFirestore();
      await postToFirestore();
      Navigator.pop(context);
    }
  }

  /// Post the image taken on prev step and return the firebase url to the
  /// saved image location
  Future<String> postImgToFirestore() async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('img${DateTime.now().toString()}.jpg');
    UploadTask upTask = ref.putFile(File(widget._imgPath));
    await upTask.whenComplete(() {});

    return await ref.getDownloadURL();
  }

  /// Posts the data collected on this page to the firestore database
  Future postToFirestore() async {
    CollectionReference posts =
        FirebaseFirestore.instance.collection(COLLECTION_NAME);

    posts
        .add({
          'date': formData['date'],
          'picUrl': formData['picUrl'],
          'qty': formData['qty'],
          'Latitude': formData['Latitude'],
          'Longitude': formData['Longitude']
        })
        .then((value) => print('form posted to firestore'))
        .catchError((err) => print('Failed to post: $err'));
  }

  Widget imageHolder() {
    return widget._imgPath == null
        ? Expanded(child: Placeholder())
        : Expanded(child: Image.file(File(widget._imgPath)));
  }
}
