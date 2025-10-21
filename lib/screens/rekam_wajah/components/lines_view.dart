import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LinesView extends StatelessWidget {
  final Map<String, dynamic> reading;
  final int currentLineIndex;

  const LinesView({
    super.key,
    required this.reading,
    required this.currentLineIndex,
  });

  @override
  Widget build(BuildContext context) {
    final lines = List<Map<String, dynamic>>.from(reading['lines']);
    final title = reading['title'] ?? '';
    final level = reading['level'] ?? '-';
    final type = reading['type'] ?? 'reading';
    final isExam = type.toLowerCase() == 'exams';

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // 🔹 Judul dan level
                Column(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexendDeca(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Level $level",
                      style: GoogleFonts.lexendDeca(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.teal.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 🔹 Teks baris demi baris
                Expanded(
                  child: ListView.builder(
                    itemCount: lines.length,
                    itemBuilder: (context, index) {
                      final text = lines[index]['text'] ?? '';
                      final isActive = index == currentLineIndex;

                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 400),
                        opacity: isActive ? 1.0 : 0.5, // ✅ redupkan teks tidak aktif
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.white
                                : Colors.grey.shade100.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: Colors.teal.withOpacity(0.4),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : [],
                            border: Border.all(
                              color: isActive
                                  ? Colors.teal.shade400
                                  : Colors.grey.shade300,
                              width: isActive ? 2 : 1,
                            ),
                          ),

                          // 🔹 Blur teks nonaktif agar sulit dibaca
                          child: ImageFiltered(
                            imageFilter: isActive
                                ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
                                : ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Text(
                              text,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lexendDeca(
                                fontSize: 22,
                                height: 1.5,
                                fontWeight: isActive
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isActive
                                    ? Colors.black
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Label mode di pojok kanan atas
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isExam
                    ? Colors.orange.shade400
                    : Colors.teal.shade500, // beda warna tiap mode
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isExam ? Icons.quiz : Icons.menu_book,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isExam ? "Mode: Exam" : "Mode: Reading",
                    style: GoogleFonts.lexendDeca(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
