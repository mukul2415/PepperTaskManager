import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:pepper_cloud_task_manager/core/errors/failures.dart';
import 'package:pepper_cloud_task_manager/core/usecases/usecase.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/entities/task_entity.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/repositories/task_repository.dart';

class AddTask implements UseCase<void, AddTaskParams> {
  final TaskRepository repository;

  AddTask(this.repository);

  @override
  Future<Either<Failure, void>> call(AddTaskParams params) async {
    return await repository.addTask(params.task);
  }
}

class AddTaskParams extends Equatable {
  final TaskEntity task;

  const AddTaskParams({required this.task});

  @override
  List<Object?> get props => [task];
}