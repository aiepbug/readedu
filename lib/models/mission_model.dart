class Mission {
  final String title;
  final int contentid;
  final int level;
  final String type;
  final bool active;
  final List<LineData> lines;

  Mission({
    required this.title,
    required this.contentid,
    required this.level,
    required this.type,
    required this.active,
    required this.lines,
  });

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      title: json['title'],
      contentid: json['contentid'],
      level: json['level'],
      type: json['type'],
      active: json['active'] == 1,
      lines: (json['lines'] as List)
          .map((e) => LineData.fromJson(e))
          .toList(),
    );
  }
}

class LineData {
  final String text;
  final int duration;

  LineData({required this.text, required this.duration});

  factory LineData.fromJson(Map<String, dynamic> json) {
    return LineData(
      text: json['text'],
      duration: json['duration'],
    );
  }
}
