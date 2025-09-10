import 'package:pepper_cloud_task_manager/core/errors/exceptions.dart';
import 'package:pepper_cloud_task_manager/features/task/data/models/task_model.dart';
import 'package:hive/hive.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getAllTasks();

  Future<TaskModel> getTask(String id);

  Future<void> addTask(TaskModel task);

  Future<void> updateTask(TaskModel task);

  Future<void> deleteTask(String id);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  static const String _taskBoxName = 'tasks';

  Box<TaskModel> get _taskBox => Hive.box<TaskModel>(_taskBoxName);

  @override
  Future<List<TaskModel>> getAllTasks() {
    try {
      return Future.value(_taskBox.values.toList());
    } catch (e) {
      throw LocalDatabaseException('Failed to get all tasks: $e');
    }
  }

  @override
  Future<TaskModel> getTask(String id) {
    try {
      final task = _taskBox.get(id);
      if (task == null) {
        throw LocalDatabaseException('Task with ID $id not found');
      }
      return Future.value(task);
    } catch (e) {
      throw LocalDatabaseException('Failed to get task $id: $e');
    }
  }

  @override
  Future<void> addTask(TaskModel task) {
    try {
      return _taskBox.put(task.id, task);
    } catch (e) {
      throw LocalDatabaseException('Failed to add task: $e');
    }
  }

  @override
  Future<void> updateTask(TaskModel task) {
    try {
      return _taskBox.put(task.id, task);
    } catch (e) {
      throw LocalDatabaseException('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String id) {
    try {
      return _taskBox.delete(id);
    } catch (e) {
      throw LocalDatabaseException('Failed to delete task: $e');
    }
  }
}
