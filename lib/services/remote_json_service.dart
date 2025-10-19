import 'dart:convert';
import 'package:http/http.dart' as http;

class RemoteJsonService {
  static const String jsonUrl =
      'https://arsipweb.uindatokarama.ac.id/readings.json';

  static Future<List<Map<String, dynamic>>> loadReadingsWithTitles() async {
    final response = await http.get(Uri.parse(jsonUrl));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      throw Exception('Gagal memuat data (${response.statusCode})');
    }
  }
}
