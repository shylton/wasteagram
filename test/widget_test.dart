import 'package:flutter_test/flutter_test.dart';
import 'package:wasteagram/models/post_dto.dart';

void main() {
  test('DTO created fromMap', () {
    final Map<String, dynamic> sampler = {
      'date': DateTime.parse('2021-01-01'),
      'url': 'www.nosite.com',
      'qty': 13,
      'lat': '19',
      'long': '21'
    };

    final testDTO = PostDTO.fromMap(sampler);
    expect(testDTO.date, sampler['date']);
    expect(testDTO.url, sampler['url']);
    expect(testDTO.qty, sampler['qty']);
    expect(testDTO.latitude, sampler['lat']);
    expect(testDTO.longitude, sampler['long']);
  }); // end of test
}
