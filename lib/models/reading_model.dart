class Reading {
  final String title;
  final List<String> lines;

  Reading({required this.title, required this.lines});

  factory Reading.fromJson(Map<String, dynamic> json) {
    return Reading(
      title: json['title'] ?? '',
      lines: List<String>.from(json['lines'] ?? []),
    );
  }
}
