import 'package:flutter/material.dart';
import 'screens/rekam_wajah_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ReadLexiApp());
}

class ReadLexiApp extends StatelessWidget {
  const ReadLexiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReadLexi',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const RekamWajahScreen(), // langsung ke layar rekaman
      debugShowCheckedModeBanner: false,
    );
  }
}
