import 'package:dartz/dartz.dart';
import 'package:pepper_cloud_task_manager/core/errors/exceptions.dart';
import 'package:pepper_cloud_task_manager/core/errors/failures.dart';
import 'package:pepper_cloud_task_manager/features/task/data/datasources/task_local_datasource.dart';
import 'package:pepper_cloud_task_manager/features/task/data/datasources/task_remote_datasource.dart'; // Import remote
import 'package:pepper_cloud_task_manager/features/task/data/models/task_model.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/entities/task_entity.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  // Helper to handle exceptions and return Either<Failure, T>
  Future<Either<Failure, T>> _safeCall<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Right(result);
    } on LocalDatabaseException catch (e) {
      return Left(LocalDatabaseFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addTask(TaskEntity task) async {
    return _safeCall(() async {
      final taskModel = TaskModel.fromEntity(task);
      await localDataSource.addTask(taskModel);
      await remoteDataSource.addTask(taskModel);
      return Future.value(null);
    });
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    return _safeCall(() async {
      await localDataSource.deleteTask(id);
      await remoteDataSource.deleteTask(id);
      return Future.value(null);
    });
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getAllTasks() async {
    return _safeCall(() async {
      final remoteTasks = await remoteDataSource.getAllTasks();

      final localTasks = await localDataSource.getAllTasks();
      for (var localTask in localTasks) {
        if (localTask.id.startsWith('remote-task-')) {
          await localDataSource.deleteTask(localTask.id);
        }
      }

      for (var remoteTask in remoteTasks) {
        await localDataSource.addTask(remoteTask);
      }

      final allLocalTasks = await localDataSource.getAllTasks();
      return allLocalTasks.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, TaskEntity>> getTask(String id) async {
    return _safeCall(() async {
      try {
        return await localDataSource.getTask(id);
      } on LocalDatabaseException {
        final remoteTask = await remoteDataSource.getTask(id);
        await localDataSource.addTask(remoteTask);
        return remoteTask;
      }
    });
  }

  @override
  Future<Either<Failure, void>> updateTask(TaskEntity task) async {
    return _safeCall(() async {
      final taskModel = TaskModel.fromEntity(task);
      await localDataSource.updateTask(taskModel);
      await remoteDataSource.updateTask(taskModel);
      return Future.value(null);
    });
  }

  @override
  Future<Either<Failure, void>> markTaskCompleted(String id, bool isCompleted) async {
    return _safeCall(() async {
      final existingTask = await getTask(id);
      await existingTask.fold(
            (failure) => throw LocalDatabaseException(failure.properties.first.toString()),
            (task) async {
          final updatedTask = task.copyWith(isCompleted: isCompleted);
          final updatedTaskModel = TaskModel.fromEntity(updatedTask);
          await localDataSource.updateTask(updatedTaskModel);
          await remoteDataSource.updateTask(updatedTaskModel);
        },
      );
      return Future.value(null);
    });
  }
}