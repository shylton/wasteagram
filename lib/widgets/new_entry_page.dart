import 'dart:io';
import 'package:flutter/material.dart';

class NewEntryPage extends StatefulWidget {
  static final routeName = 'newEntry';
  final File _img;

  NewEntryPage(this._img);

  @override
  _NewEntryPageState createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  final formKey = GlobalKey<FormState>();
  var formData = Map();

  @override
  Widget build(BuildContext context) {
    // on click, validate form data
    // upload img, get url => one func
    // then populate DTO
    // put DTO into db
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
                validator: (value) => validateAndSave(value),
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
                OutlineButton.icon(
                  icon: Icon(Icons.send),
                  label: Text('Send'),
                  onPressed: () {},
                )
              ])
            ],
          ),
        ),
      ),
    );
  }

  String validateAndSave(String input) {
    return 'invalid';
  }

  Widget imageHolder() {
    return widget._img == null ? Placeholder() : Image.file(widget._img);
  }
}
