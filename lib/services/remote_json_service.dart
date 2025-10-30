import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import '../models/reading_model.dart';

class RemoteJsonService {
  //  URL baru versi v2
  static const String jsonUrl =
      'https://upttipd.uindatokarama.ac.id/arifrachmat/readings_v2.json';

  /// Memuat teks bacaan dari server
  static Future<List<Map<String, dynamic>>> loadReadingsWithTitles() async {
    final response = await http.get(Uri.parse(jsonUrl));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      //  Filter hanya yang active == 1
      final activeItems = data.where((item) {
        return item['active'] == 1 || item['active'] == true;
      }).toList();

      //  Parsing aman dengan default value
      return activeItems.map((e) {
        return {
          'title': e['title'] ?? 'Tanpa Judul',
          'contentid': e['contentid'] ?? 0,
          'active': e['active'] ?? 0,
          'level': e['level'] ?? 1,
          'type': e['type'] ?? 'reading',
          'lines': List<Map<String, dynamic>>.from(e['lines'] ?? []),
        };
      }).toList();
    } else {
      throw Exception('Gagal memuat data (${response.statusCode})');
    }
  }

  
}
