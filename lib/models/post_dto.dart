import 'package:intl/intl.dart';

class PostDTO {
  DateTime _date;
  String _url;
  int _qty;
  String _latitude;
  String _longitude;
  final DateFormat dtFrmt = DateFormat('EEEE, MMM. d');

  PostDTO.fromMap(Map<String, dynamic> data)
      : _date = DateTime.parse(data['date'].toDate().toString()),
        _url = data['picUrl'],
        _qty = data['qty'],
        _latitude = data['Latitude'],
        _longitude = data['Longitude'];

  String get url => _url;
  DateTime get date => _date;
  String get dateStr => dtFrmt.format(_date);
  int get qty => _qty;
  String get latitude => _latitude;
  String get longitude => _longitude;
}