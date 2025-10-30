import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

// Import layar mission map
import '../../mission_map/mission_map_screen.dart';

class StartScreen extends StatefulWidget {
  final Function(String name, String mode)? onStart; // optional agar backward-compatible
  const StartScreen({super.key, this.onStart});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final TextEditingController _controller = TextEditingController();
  String _selectedMode = 'reading';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchDisclaimer() async {
    const url = '#';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  void _handleStartPressed() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;

    // Jika ada callback lama, tetap jalankan
    if (widget.onStart != null) {
      widget.onStart!(name, _selectedMode);
    }

    // Setelah nama diisi dan tombol diklik → buka Mission Map
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MissionMapScreen(username: name, mode: _selectedMode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nameFilled = _controller.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFDAEFEA),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.emoji_emotions, size: 100, color: Color(0xFFF5A97F)),
              const SizedBox(height: 20),
              Text(
                "Game Baca",
                style: GoogleFonts.lexendDeca(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF236D64),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Pilih mode permainan dan masukkan nama kamu!",
                textAlign: TextAlign.center,
                style: GoogleFonts.lexendDeca(
                  fontSize: 18,
                  color: Colors.teal.shade900.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 30),

              // Pilihan mode
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: Text(
                      'Reading',
                      style: GoogleFonts.lexendDeca(
                        fontWeight: FontWeight.bold,
                        color: _selectedMode == 'reading'
                            ? Colors.white
                            : Colors.teal.shade900,
                      ),
                    ),
                    selected: _selectedMode == 'reading',
                    selectedColor: Colors.teal.shade600,
                    backgroundColor: Colors.teal.shade100,
                    onSelected: (_) => setState(() => _selectedMode = 'reading'),
                  ),
                  const SizedBox(width: 20),
                  ChoiceChip(
                    label: Text(
                      'Exam',
                      style: GoogleFonts.lexendDeca(
                        fontWeight: FontWeight.bold,
                        color: _selectedMode == 'exams'
                            ? Colors.white
                            : Colors.teal.shade900,
                      ),
                    ),
                    selected: _selectedMode == 'exams',
                    selectedColor: Colors.orange.shade400,
                    backgroundColor: Colors.orange.shade100,
                    onSelected: (_) => setState(() => _selectedMode = 'exams'),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Input nama
              TextField(
                controller: _controller,
                onChanged: (_) => setState(() {}),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Masukkan Nama Kamu',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Tombol Mulai → Navigasi Mission Map
              ElevatedButton.icon(
                onPressed: nameFilled ? _handleStartPressed : null,
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                label: Text(
                  "Mulai Bermain",
                  style: GoogleFonts.lexendDeca(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade600,
                  disabledBackgroundColor: Colors.teal.shade100,
                  shadowColor: Colors.teal.shade700.withOpacity(0.3),
                  elevation: 6,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 30),
              Divider(color: Colors.teal.shade200, thickness: 1),
              const SizedBox(height: 10),

              Text(
                "Versi prototipe, hanya untuk penggunaan penelitian.",
                textAlign: TextAlign.center,
                style: GoogleFonts.lexendDeca(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: _launchDisclaimer,
                child: Text(
                  "Disclaimer",
                  style: GoogleFonts.lexendDeca(
                    color: Colors.blue.shade700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
