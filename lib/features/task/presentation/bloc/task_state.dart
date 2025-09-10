part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;
  final TaskFilter currentFilter;
  final TaskSortOption currentSortOption;

  const TaskLoaded({
    required this.tasks,
    this.currentFilter = TaskFilter.all,
    this.currentSortOption = TaskSortOption.dueDateAsc,
  });

  TaskLoaded copyWith({
    List<TaskEntity>? tasks,
    TaskFilter? currentFilter,
    TaskSortOption? currentSortOption,
  }) {
    return TaskLoaded(
      tasks: tasks ?? this.tasks,
      currentFilter: currentFilter ?? this.currentFilter,
      currentSortOption: currentSortOption ?? this.currentSortOption,
    );
  }

  @override
  List<Object> get props => [tasks, currentFilter, currentSortOption];
}

class TaskError extends TaskState {
  final String message;

  const TaskError({required this.message});

  @override
  List<Object> get props => [message];
}

class TaskActionSuccess extends TaskState {
  final String message;

  const TaskActionSuccess({required this.message});

  @override
  List<Object> get props => [message];
}
