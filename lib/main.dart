import 'package:flutter/material.dart';
import 'screens/rekam_wajah/rekam_wajah_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    home: RekamWajahScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
