import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:pepper_cloud_task_manager/core/errors/failures.dart';
import 'package:pepper_cloud_task_manager/core/usecases/usecase.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/entities/task_entity.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/repositories/task_repository.dart';

class UpdateTask implements UseCase<void, UpdateTaskParams> {
  final TaskRepository repository;

  UpdateTask(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateTaskParams params) async {
    return await repository.updateTask(params.task);
  }
}

class UpdateTaskParams extends Equatable {
  final TaskEntity task;

  const UpdateTaskParams({required this.task});

  @override
  List<Object?> get props => [task];
}