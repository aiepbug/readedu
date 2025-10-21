import 'package:camera/camera.dart';

class CameraHelper {
  CameraController? controller;
  Future<void>? initializeControllerFuture;

  // 🔹 Inisialisasi kamera depan
  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
    );
    controller = CameraController(frontCamera, ResolutionPreset.medium);
    initializeControllerFuture = controller!.initialize();
    await initializeControllerFuture;
  }

  // 🔹 Mulai merekam video
  Future<void> startRecording() async {
    if (controller != null && controller!.value.isInitialized && !controller!.value.isRecordingVideo) {
      await controller!.startVideoRecording();
    }
  }

  // 🔹 Hentikan rekaman dan kembalikan file
  Future<XFile?> stopRecording() async {
    if (controller != null && controller!.value.isRecordingVideo) {
      return await controller!.stopVideoRecording();
    }
    return null;
  }

  // 🔹 Lepas resource kamera
  void dispose() {
    controller?.dispose();
  }
}
