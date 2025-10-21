import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackButtons extends StatelessWidget {
  final Function(String feedback) onFeedback;
  const FeedbackButtons({super.key, required this.onFeedback});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.95),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // ✅ tengah vertikal
          children: [
            Text(
              "Bagaimana perasaanmu setelah membaca?",
              textAlign: TextAlign.center,
              style: GoogleFonts.lexendDeca(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade800,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => onFeedback("Senang"),
                  icon: const Icon(Icons.sentiment_satisfied_alt, color: Colors.white),
                  label: Text(
                    "Senang",
                    style: GoogleFonts.lexendDeca(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                ElevatedButton.icon(
                  onPressed: () => onFeedback("Sedih"),
                  icon:
                      const Icon(Icons.sentiment_dissatisfied, color: Colors.white),
                  label: Text(
                    "Sedih",
                    style: GoogleFonts.lexendDeca(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade400,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
