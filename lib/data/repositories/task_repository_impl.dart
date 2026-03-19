import 'dart:io';
import '../../domain/models/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Task>> getTasks() async {
    return await remoteDataSource.getTasks();
  }

  @override
  Future<void> createTask(Task task) async {
    final model = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      category: task.category,
      scheduledTime: task.scheduledTime,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
      imageUrl: task.imageUrl,
    );
    await remoteDataSource.createTask(model);
  }

  @override
  Future<void> updateTask(Task task) async {
    final model = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      category: task.category,
      scheduledTime: task.scheduledTime,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
      imageUrl: task.imageUrl,
    );
    await remoteDataSource.updateTask(model);
  }

  @override
  Future<void> deleteTask(String id) async {
    await remoteDataSource.deleteTask(id);
  }

  @override
  Future<void> toggleTaskCompletion(String id, bool isCompleted) async {
    await remoteDataSource.toggleTaskCompletion(id, isCompleted);
  }

  Future<String?> uploadImage(File imageFile, String taskId) async {
    return await remoteDataSource.uploadImage(imageFile, taskId);
  }
}