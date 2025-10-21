import 'dart:async';

class ReadingTimer {
  // Timer untuk mengatur pergantian teks baris demi baris
  static void start({
    required List<Map<String, dynamic>> lines,
    required int index,
    required Function onNextLine,
    required Function onFinish,
  }) {
    if (index >= lines.length) {
      onFinish();
      return;
    }

    final duration = Duration(milliseconds: lines[index]['duration'] ?? 2500);
    Timer(duration, () {
      onNextLine();
      start(
        lines: lines,
        index: index + 1,
        onNextLine: onNextLine,
        onFinish: onFinish,
      );
    });
  }
}
