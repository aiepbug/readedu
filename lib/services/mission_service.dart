import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mission_model.dart';

class MissionService {
  static const String apiUrl =
      'https://raw.githubusercontent.com/aiepbug/readedu/main/assets/data/missions.json'; 
      // Ganti dengan endpoint API Anda nanti

  static Future<List<Mission>> loadMissions() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResult = json.decode(response.body);
        return jsonResult
            .map((e) => Mission.fromJson(e))
            .where((m) => m.active)
            .toList();
      } else {
        throw Exception('Gagal memuat data misi. Status: ${response.statusCode}');
      }
    } catch (e) {
      print("Error loading missions: $e");
      return [];
    }
  }
}
