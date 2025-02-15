class Memo {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;

  Memo({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  Memo copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? createdAt,
  }) {
    return Memo(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Memo.fromMap(Map<String, dynamic> map, String id) {
    return Memo(
      id: id,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}
