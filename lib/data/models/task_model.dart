import '../../domain/models/task.dart';

class TaskModel extends Task {
  TaskModel({
    required super.id,
    required super.title,
    super.description,
    required super.category,
    super.scheduledTime,
    required super.isCompleted,
    required super.createdAt,
    super.imageUrl,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      scheduledTime: json['scheduled_time'],
      isCompleted: json['is_completed'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'scheduled_time': scheduledTime,
      'is_completed': isCompleted,
      'image_url': imageUrl,
    };
  }
}