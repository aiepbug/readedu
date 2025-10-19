import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as p;
import 'package:camera/camera.dart';

class StorageService {
  static Future<String> saveVideo(XFile file) async {
    final dir = Directory('/storage/emulated/0/Movies/ReadLexi');
    if (!await dir.exists()) await dir.create(recursive: true);

    final now = DateTime.now();
    final datePart =
        '${now.day.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.year}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
    final randomId = _randomString(5);

    final tempName = '${datePart}_${randomId}_temp.mp4';
    final newPath = p.join(dir.path, tempName);

    await File(file.path).copy(newPath);
    return newPath;
  }

  static Future<void> renameVideo(String path, String label) async {
    final file = File(path);
    if (!await file.exists()) return;

    final dir = file.parent;
    final base = p.basenameWithoutExtension(file.path);
    final newPath = p.join(dir.path, '${base}_$label.mp4');
    await file.rename(newPath);
  }

  static String _randomString(int length) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(rand.nextInt(chars.length))),
    );
  }
}
