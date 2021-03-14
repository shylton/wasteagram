import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:wasteagram/models/post_dto.dart';

class DetailPage extends StatelessWidget {
  static final routeName = 'details';
  final PostDTO data;

  DetailPage({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wasteagram'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          Center(child: dateField(context)),
          const SizedBox(height: 12.0),
          imgField(),
          const SizedBox(height: 12.0),
          Center(child: qtyField(context)),
          const SizedBox(height: 12.0),
          Center(child: locationField(context))
        ],
      ),
    );
  }

  Semantics dateField(BuildContext context) {
    return Semantics.fromProperties(
      properties: SemanticsProperties(label: 'date', value: data.dateStr),
      child: Text(data.dateStr, style: Theme.of(context).textTheme.headline4),
    );
  }

  Semantics imgField() {
    return Semantics.fromProperties(
      properties: SemanticsProperties(label: 'image'),
      child: Container(
        decoration: BoxDecoration(border: Border.all(width: 2.0)),
        child: Image.network(data.url),
      ),
    );
  }

  Semantics qtyField(BuildContext context) {
    return Semantics.fromProperties(
      properties:
          SemanticsProperties(label: 'quantity', value: data.qty.toString()),
      child: Text('Items: ${data.qty.toString()}',
          style: Theme.of(context).textTheme.headline6),
    );
  }

  Semantics locationField(BuildContext context) {
    return Semantics.fromProperties(
      properties: SemanticsProperties(
          label: 'location', value: '${data.latitude}, ${data.longitude}'),
      child: Text('(${data.latitude}, ${data.longitude})',
          style: Theme.of(context).textTheme.headline6),
    );
  }
}
