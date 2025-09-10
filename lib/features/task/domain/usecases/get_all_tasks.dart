import 'package:dartz/dartz.dart';
import 'package:pepper_cloud_task_manager/core/errors/failures.dart';
import 'package:pepper_cloud_task_manager/core/usecases/usecase.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/entities/task_entity.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/repositories/task_repository.dart';

class GetAllTasks implements UseCase<List<TaskEntity>, NoParams> {
  final TaskRepository repository;

  GetAllTasks(this.repository);

  @override
  Future<Either<Failure, List<TaskEntity>>> call(NoParams params) async {
    return await repository.getAllTasks();
  }
}