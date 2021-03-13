import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

class NewEntryPage extends StatefulWidget {
  static final routeName = 'newEntry';
  final File _img;

  NewEntryPage(this._img);

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

  void initFormData() async {
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

    // update the formData
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              imageHolder(),
              const SizedBox(height: 18.0),
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                    labelText: 'Number of Items', border: OutlineInputBorder()),
                validator: (value) => nonEmptyField(value),
                onSaved: (String value) => formData['qty'] = int.parse(value),
              ),
              const SizedBox(height: 18.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                OutlineButton.icon(
                  textColor: Colors.red,
                  icon: Icon(Icons.cancel),
                  label: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Builder(
                    builder: (context) => OutlineButton.icon(
                          icon: Icon(Icons.send),
                          label: Text('Send'),
                          onPressed: () {
                            validateAndSave(context);
                          },
                        ))
              ])
            ],
          ),
        ),
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

      await postImgToFirestore();
      await postToFirestore();
      Navigator.pop(context);
    }
  }

  Future postImgToFirestore() async {
    // Reference ref =
    //     FirebaseStorage.instance.ref().child('img' + DateTime.now().toString());
    // UploadTask upTask = ref.putFile(widget._img);


    // String rtn;
    // upload file then save url into formData
    // if (widget._img != null) {
    // FirebaseStorage.instance
    //     .ref()
    //     .child('img' + DateTime.now().toString())
    //     .putFile(widget._img)
    //     .then((res) async {
    //   formData['picUrl'] = await res.ref.getDownloadURL();
    // });
    // PUT img into firestore
    // ref.putFile(widget._img).then((res) async {
    // pass url string to formData
    // rtn = await res.ref.getDownloadURL();
    // });
    // } else {
    //   // missing image placeholder
    //   formData['picUrl'] =
    //       'https://firebasestorage.googleapis.com/v0/b/wasteagram-ec660.appspot.com/o/imgMissing.png?alt=media&token=30435d01-c2ca-47f6-a984-c8be28b3e9e4';
    // }
  }

  Future<String> getUrl(TaskSnapshot res) =>
      Future(() => res.ref.getDownloadURL());

  // async {
  //   // pass url string to formData
  //   formData['picUrl'] = await res.ref.getDownloadURL();
  // }

  Future<void> postToFirestore() {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');

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
    return widget._img == null
        ? Expanded(child: Placeholder())
        : Expanded(child: Image.file(widget._img));
  }
}
