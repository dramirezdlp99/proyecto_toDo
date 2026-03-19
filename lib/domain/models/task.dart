class Task {
  final String id;
  final String title;
  final String? description;
  final String category;
  final String? scheduledTime;
  final bool isCompleted;
  final DateTime createdAt;
  final String? imageUrl;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    this.scheduledTime,
    required this.isCompleted,
    required this.createdAt,
    this.imageUrl,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? scheduledTime,
    bool? isCompleted,
    DateTime? createdAt,
    String? imageUrl,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}