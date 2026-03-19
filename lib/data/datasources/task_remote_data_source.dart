import 'dart:io';
import '../../core/supabase/supabase_client_provider.dart';
import '../models/task_model.dart';

class TaskRemoteDataSource {
  final _client = SupabaseClientProvider.client;

  Future<List<TaskModel>> getTasks() async {
    final response = await _client
        .from('tasks')
        .select()
        .order('created_at', ascending: false);
    return (response as List).map((e) => TaskModel.fromJson(e)).toList();
  }

  Future<void> createTask(TaskModel task) async {
    await _client.from('tasks').insert(task.toJson());
  }

  Future<void> updateTask(TaskModel task) async {
    await _client
        .from('tasks')
        .update(task.toJson())
        .eq('id', task.id);
  }

  Future<void> deleteTask(String id) async {
    await _client.from('tasks').delete().eq('id', id);
  }

  Future<void> toggleTaskCompletion(String id, bool isCompleted) async {
    await _client
        .from('tasks')
        .update({'is_completed': isCompleted})
        .eq('id', id);
  }

  Future<String?> uploadImage(File imageFile, String taskId) async {
    try {
      final fileName = 'task_$taskId\_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await _client.storage
          .from('task-images')
          .upload(fileName, imageFile);
      final url = _client.storage
          .from('task-images')
          .getPublicUrl(fileName);
      return url;
    } catch (e) {
      return null;
    }
  }
}