part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class GetTasksEvent extends TaskEvent {
  final TaskFilter? filter;
  final TaskSortOption? sortOption;

  const GetTasksEvent({this.filter, this.sortOption});

  @override
  List<Object> get props => [filter ?? TaskFilter.all, sortOption ?? TaskSortOption.dueDateAsc];
}

class AddTaskEvent extends TaskEvent {
  final TaskEntity task;

  const AddTaskEvent({required this.task});

  @override
  List<Object> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final TaskEntity task;

  const UpdateTaskEvent({required this.task});

  @override
  List<Object> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final String id;

  const DeleteTaskEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class ToggleTaskCompletionEvent extends TaskEvent {
  final String id;
  final bool isCompleted;

  const ToggleTaskCompletionEvent({required this.id, required this.isCompleted});

  @override
  List<Object> get props => [id, isCompleted];
}

enum TaskFilter { all, completed, pending }
enum TaskSortOption { dueDateAsc, dueDateDesc, titleAsc, titleDesc }