import 'dart:io';
import '../models/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<void> createTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
  Future<void> toggleTaskCompletion(String id, bool isCompleted);
  Future<String?> uploadImage(File imageFile, String taskId);
}