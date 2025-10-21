import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../rekam_wajah_controller.dart';
import 'package:provider/provider.dart';

class FinishScreen extends StatelessWidget {
  final String userName;
  const FinishScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<RekamWajahController>();

    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
              const SizedBox(height: 20),
              Text(
                "🌟 Luar biasa, $userName!",
                textAlign: TextAlign.center,
                style: GoogleFonts.lexendDeca(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Kamu telah menyelesaikan semua bacaan!\nTerus semangat belajar ya!",
                textAlign: TextAlign.center,
                style: GoogleFonts.lexendDeca(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  // ✅ Reset logic tanpa reload soal
                  controller.currentReadingIndex = 0;
                  controller.currentLineIndex = 0;
                  controller.finishedAll = false;
                  controller.showText = false;
                  controller.showCountdown = false;
                  controller.showEncouragement = false;
                  controller.showFeedbackButtons = false;
                  controller.started = false;
                  controller.notifyListeners();
                },
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: Text(
                  "Kembali ke Depan",
                  style: GoogleFonts.lexendDeca(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
