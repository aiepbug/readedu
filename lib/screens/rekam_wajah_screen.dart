import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as p;
import 'package:google_fonts/google_fonts.dart';
import '../services/storage_service.dart';
import '../services/remote_json_service.dart';

class RekamWajahScreen extends StatefulWidget {
  const RekamWajahScreen({super.key});

  @override
  State<RekamWajahScreen> createState() => _RekamWajahScreenState();
}

class _RekamWajahScreenState extends State<RekamWajahScreen>
    with TickerProviderStateMixin {
  late CameraController _cameraController;
  bool _cameraReady = false;
  bool _isRecording = false;
  bool _started = false;
  bool _showCountdown = false;
  bool _showEncouragement = false;
  bool _showText = false;
  bool _showFeedbackButtons = false;
  int _countdown = 3;
  int _currentIndex = 0;
  int _highlightLine = 0;

  String _userName = '';
  final _nameController = TextEditingController();

  List<Map<String, dynamic>> _readings = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
    _initCamera();
  }

  Future<void> _loadData() async {
    try {
      final readings = await RemoteJsonService.loadReadingsWithTitles();
      setState(() {
        _readings = readings;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(front, ResolutionPreset.medium);
    await _cameraController.initialize();
    setState(() => _cameraReady = true);
  }

  Future<void> _startCountdown() async {
    setState(() {
      _showCountdown = true;
      _countdown = 3;
      _showText = false;
      _showFeedbackButtons = false;
    });

    for (var i = 3; i > 0; i--) {
      setState(() => _countdown = i);
      await Future.delayed(const Duration(seconds: 1));
    }

    setState(() => _showCountdown = false);
    _startRecording();
    setState(() => _showText = true);
    _startHighlightSequence();
  }

  Future<void> _startRecording() async {
    if (!_cameraController.value.isInitialized || _isRecording) return;
    await _cameraController.startVideoRecording();
    setState(() => _isRecording = true);
  }

  Future<void> _stopRecording(String label) async {
    if (!_isRecording) return;
    final video = await _cameraController.stopVideoRecording();
    setState(() => _isRecording = false);

    final title = _readings[_currentIndex]['title']
        .toString()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '')
        .substring(0, min(10, _readings[_currentIndex]['title'].length));

    final user = _userName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');
    final savedPath = await StorageService.saveVideo(video);
    await StorageService.renameVideo(savedPath, '${user}_${title}_$label');
  }

  /// 🔹 Menyorot tiap baris teks berdasarkan durasi dari JSON
  Future<void> _startHighlightSequence() async {
    final lines = _readings[_currentIndex]['lines'] as List<dynamic>;

    for (int i = 0; i < lines.length; i++) {
      setState(() => _highlightLine = i);

      final durationMs = (lines[i]['duration'] ?? 2000) as int;
      await Future.delayed(Duration(milliseconds: durationMs));
    }

    // 🔹 Setelah semua selesai dibaca:
    setState(() {
      _showText = false;
      _showFeedbackButtons = true;
    });
  }

  Future<void> _handleFeedback(String label) async {
    await _stopRecording(label);

    setState(() {
      _showEncouragement = true;
      _showFeedbackButtons = false;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() => _showEncouragement = false);

    if (_currentIndex < _readings.length - 1) {
      setState(() {
        _currentIndex++;
        _highlightLine = 0;
      });
      await _startCountdown();
    } else {
      _showFinishScreen();
    }
  }

  void _showFinishScreen() {
    setState(() => _showEncouragement = true);
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(child: Text('Error: $_error')),
      );
    }

    if (!_cameraReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: !_started
            ? _buildStartScreen()
            : Stack(
                alignment: Alignment.center,
                children: [
                  if (_showCountdown)
                    Center(
                      child: Text(
                        "$_countdown",
                        style: GoogleFonts.lexendDeca(
                          fontSize: 96,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),

                  if (_showText && !_showEncouragement)
                    _buildLinesView(),

                  if (_showFeedbackButtons)
                    _buildFeedbackButtons(),

                  if (_showEncouragement)
                    Container(
                      color: Colors.white.withOpacity(0.9),
                      child: Center(
                        child: Text(
                          "Kamu hebat! 🎉",
                          style: GoogleFonts.lexendDeca(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  /// 🔹 Layar awal dengan input nama
  Widget _buildStartScreen() {
    final isNameEmpty = _nameController.text.trim().isEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sudah siap bermain?",
              style: GoogleFonts.lexendDeca(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              textAlign: TextAlign.center,
              style: GoogleFonts.lexendDeca(fontSize: 20),
              decoration: InputDecoration(
                hintText: "Masukkan namamu di sini",
                hintStyle: GoogleFonts.lexendDeca(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isNameEmpty ? Colors.grey : Colors.teal,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              icon: const Icon(Icons.play_arrow),
              label: Text(
                "Mulai",
                style: GoogleFonts.lexendDeca(fontSize: 20),
              ),
              onPressed: isNameEmpty
                  ? null
                  : () async {
                      setState(() {
                        _userName = _nameController.text.trim();
                        _started = true;
                      });
                      await _startCountdown();
                    },
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Teks bacaan di bagian atas
  Widget _buildLinesView() {
    final lines = _readings[_currentIndex]['lines'] as List<dynamic>;

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_readings[_currentIndex]['title'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _readings[_currentIndex]['title'],
                  style: GoogleFonts.lexendDeca(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            for (int i = 0; i < lines.length; i++)
              AnimatedOpacity(
                opacity: _highlightLine == i ? 1.0 : 0.3,
                duration: const Duration(milliseconds: 300),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    lines[i]['text'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lexendDeca(
                      fontSize: 24,
                      fontWeight: _highlightLine == i
                          ? FontWeight.bold
                          : FontWeight.w400,
                      color: _highlightLine == i
                          ? Colors.teal[900]
                          : Colors.black54,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Tombol feedback di tengah layar
  Widget _buildFeedbackButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Bagaimana perasaanmu?",
          style: GoogleFonts.lexendDeca(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: () => _handleFeedback('suka'),
              child: Text(
                "Suka 💖",
                style: GoogleFonts.lexendDeca(fontSize: 22),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[200],
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: () => _handleFeedback('sedih'),
              child: Text(
                "Sedih 😞",
                style: GoogleFonts.lexendDeca(fontSize: 22),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
