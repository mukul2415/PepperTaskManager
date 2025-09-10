
import '../../../../core/errors/exceptions.dart';
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getAllTasks();

  Future<TaskModel> getTask(String id);

  Future<void> addTask(TaskModel task);

  Future<void> updateTask(TaskModel task);

  Future<void> deleteTask(String id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {


  // Mock network delay
  Future<T> _simulateNetworkDelay<T>(T Function() callback) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return callback();
  }

  // Mock API data
  static final List<TaskModel> _mockRemoteTasks = [
    TaskModel(
      id: 'remote-task-1',
      title: 'Buy Groceries (Remote)',
      description: 'Milk, Eggs, Bread, Cheese, Vegetables, Fruits',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      isCompleted: false,
    ),
    TaskModel(
      id: 'remote-task-2',
      title: 'Plan Weekend Trip (Remote)',
      description:
          'Research destinations, book accommodation, create itinerary',
      dueDate: DateTime.now().add(const Duration(days: 7)),
      isCompleted: false,
    ),
    TaskModel(
      id: 'remote-task-3',
      title: 'Finish Flutter Project (Remote)',
      description: 'Implement all features and test thoroughly',
      dueDate: DateTime.now().add(const Duration(days: 14)),
      isCompleted: false,
    ),
    TaskModel(
      id: 'remote-task-4',
      title: 'Call Mom (Remote)',
      description: 'Catch up and say hello',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      isCompleted: true,
    ),
  ];

  @override
  Future<List<TaskModel>> getAllTasks() async {
    return _simulateNetworkDelay(() {
      return List<TaskModel>.from(_mockRemoteTasks);
    });
  }

  @override
  Future<TaskModel> getTask(String id) async {
    return _simulateNetworkDelay(() {
      final task = _mockRemoteTasks.firstWhere(
        (t) => t.id == id,
        orElse:
            () =>
                throw ServerException('Task with ID $id not found on remote.'),
      );
      return task;
    });
  }

  @override
  Future<void> addTask(TaskModel task) async {
    return _simulateNetworkDelay(() {
      if (_mockRemoteTasks.any((t) => t.id == task.id)) {
        throw ServerException(
          'Task with ID ${task.id} already exists on remote.',
        );
      }
      _mockRemoteTasks.add(task);
      return;
    });
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    return _simulateNetworkDelay(() {
      final index = _mockRemoteTasks.indexWhere((t) => t.id == task.id);
      if (index == -1) {
        throw ServerException(
          'Task with ID ${task.id} not found on remote for update.',
        );
      }
      _mockRemoteTasks[index] = task;
      return;
    });
  }

  @override
  Future<void> deleteTask(String id) async {
    return _simulateNetworkDelay(() {
      final initialLength = _mockRemoteTasks.length;
      _mockRemoteTasks.removeWhere((t) => t.id == id);
      if (_mockRemoteTasks.length == initialLength) {
        throw ServerException(
          'Task with ID $id not found on remote for deletion.',
        );
      }
      return;
    });
  }
}
