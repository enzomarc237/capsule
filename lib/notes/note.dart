class Note {
  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  int? id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;

  Note copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static Note fromJson(Map<dynamic, dynamic> json) {
    return Note(
      id: json['id'] as int?,
      title: (json['title'] ?? '') as String,
      content: (json['content'] ?? '') as String,
      createdAt: DateTime.parse((json['createdAt'] ?? DateTime.now().toIso8601String()) as String),
      updatedAt: DateTime.parse((json['updatedAt'] ?? DateTime.now().toIso8601String()) as String),
    );
  }
}
