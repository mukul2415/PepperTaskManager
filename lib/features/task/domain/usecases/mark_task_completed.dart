import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:pepper_cloud_task_manager/core/errors/failures.dart';
import 'package:pepper_cloud_task_manager/core/usecases/usecase.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/repositories/task_repository.dart';

class MarkTaskCompleted implements UseCase<void, MarkTaskCompletedParams> {
  final TaskRepository repository;

  MarkTaskCompleted(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkTaskCompletedParams params) async {
    return await repository.markTaskCompleted(params.id, params.isCompleted);
  }
}

class MarkTaskCompletedParams extends Equatable {
  final String id;
  final bool isCompleted;

  const MarkTaskCompletedParams({required this.id, required this.isCompleted});

  @override
  List<Object?> get props => [id, isCompleted];
}