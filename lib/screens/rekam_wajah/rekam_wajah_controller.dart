import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import '../../../services/remote_json_service.dart';
import '../../../services/storage_service.dart';
import 'helpers/camera_helper.dart';
import 'helpers/reading_timer.dart';

class RekamWajahController extends ChangeNotifier {
  // ==========================================================
  // 🔹 STATE
  // ==========================================================
  bool loading = true;
  bool started = false;
  bool showCountdown = false;
  bool showText = false;
  bool showFeedbackButtons = false;
  bool showEncouragement = false;
  bool finishedAll = false;
  bool recordingActive = false;

  int countdown = 3;
  int currentReadingIndex = 0;
  int currentLineIndex = 0;
  String? errorMessage;
  String userName = "";
  String selectedType = 'reading';

  List<Map<String, dynamic>>? readings;

  final CameraHelper cameraHelper = CameraHelper();
  Timer? _timer;

  // ==========================================================
  // 🔹 INITIALIZATION
  // ==========================================================
Future<void> initialize() async {
  try {
    loading = true;
    notifyListeners();
    await cameraHelper.initializeCamera();

    final allReadings = await RemoteJsonService.loadReadingsWithTitles();

    // ✅ filter berdasarkan type (reading atau exams)
    readings = allReadings
        .where((item) => item['type'] == selectedType)
        .toList();

    loading = false;
    notifyListeners();
  } catch (e) {
    errorMessage = e.toString();
    loading = false;
    notifyListeners();
  }
}


  // ==========================================================
  // 🔹 COUNTDOWN sebelum mulai
  // ==========================================================
  void startCountdown() {
    showCountdown = true;
    countdown = 3;
    notifyListeners();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 1) {
        countdown--;
        notifyListeners();
      } else {
        timer.cancel();
        showCountdown = false;
        showText = true;
        notifyListeners();
        startReading();
      }
    });
  }

  // ==========================================================
  // 🔹 MEMULAI MEMBACA & MEREKAM
  // ==========================================================
  Future<void> startReading() async {
    if (readings == null) return;
    await cameraHelper.startRecording();
    recordingActive = true;
    notifyListeners();

    final lines = List<Map<String, dynamic>>.from(
      readings![currentReadingIndex]['lines'],
    );

    ReadingTimer.start(
      lines: lines,
      index: currentLineIndex,
      onNextLine: () {
        currentLineIndex++;
        notifyListeners();
      },
      onFinish: () {
        showText = false;
        showFeedbackButtons = true;
        notifyListeners();
      },
    );
  }

  // ==========================================================
  // 🔹 HENTIKAN REKAMAN & SIMPAN FILE
  // ==========================================================
  Future<void> stopAndSave(String feedback) async {
    if (!recordingActive) return;
    final file = await cameraHelper.stopRecording();
    if (file != null) {
      final now = DateTime.now();
      final date = DateFormat('yyyyMMddHHmmss').format(now);
      final id = currentReadingIndex;
      final contentId = readings![currentReadingIndex]['contentid'] ?? 0;
      final safeName = userName.replaceAll(' ', '_');
      final filename = '${date}_${safeName}_${contentId}_${feedback.toLowerCase()}.mp4';
      await StorageService.saveVideoWithCustomName(file, filename);
    }
    recordingActive = false;
  }

  // ==========================================================
  // 🔹 FEEDBACK: Lanjut ke soal berikut atau selesai
  // ==========================================================
  Future<void> handleFeedback(String feedback) async {
    await stopAndSave(feedback);
    showFeedbackButtons = false;
    showEncouragement = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 2), () {
      if (currentReadingIndex < (readings?.length ?? 0) - 1) {
        currentReadingIndex++;
        currentLineIndex = 0;
        showEncouragement = false;
        showText = true;
        notifyListeners();
        startReading();
      } else {
        showEncouragement = false;
        finishedAll = true;
        showText = false;
        notifyListeners();
      }
    });
  }

  // ==========================================================
  // 🔹 RETRY jika gagal download
  // ==========================================================
  Future<void> retryLoad() async {
    errorMessage = null;
    notifyListeners();
    await initialize();
  }

  // ==========================================================
  // 🔹 DISPOSE
  // ==========================================================
  @override
  void dispose() {
    _timer?.cancel();
    cameraHelper.dispose();
    super.dispose();
  }
}
