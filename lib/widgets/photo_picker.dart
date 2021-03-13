import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPicker extends StatefulWidget {
  static final routeName = 'photoPicker';
  
  @override
  _PhotoPickerState createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(
        child: _image == null ? Text('No image selected.') : Image.file(_image),
      ),
      FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      )
    ]);
  }
}
