import 'package:dartz/dartz.dart';
import 'package:pepper_cloud_task_manager/core/errors/failures.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getAllTasks();
  Future<Either<Failure, TaskEntity>> getTask(String id);
  Future<Either<Failure, void>> addTask(TaskEntity task);
  Future<Either<Failure, void>> updateTask(TaskEntity task);
  Future<Either<Failure, void>> deleteTask(String id);
  Future<Either<Failure, void>> markTaskCompleted(String id, bool isCompleted);
}