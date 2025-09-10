import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/entities/task_entity.dart';

import 'package:pepper_cloud_task_manager/core/usecases/usecase.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/usecases/add_task.dart';

import 'package:pepper_cloud_task_manager/features/task/domain/usecases/delete_task.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/usecases/get_all_tasks.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/usecases/mark_task_completed.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/usecases/update_task.dart';

part 'task_event.dart';

part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final AddTask addTask;
  final GetAllTasks getAllTasks;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final MarkTaskCompleted markTaskCompleted;

  List<TaskEntity> _cachedAllTasks = [];

  TaskBloc({
    required this.addTask,
    required this.getAllTasks,
    required this.updateTask,
    required this.deleteTask,
    required this.markTaskCompleted,
  }) : super(TaskInitial()) {
    on<TaskEvent>((event, emit) {});

    on<GetTasksEvent>(_onGetTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskCompletionEvent>(_onToggleTaskCompletion);
  }

  Future<void> _onGetTasks(GetTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final result = await getAllTasks(NoParams());
    result.fold(
      (failure) =>
          emit(TaskError(message: failure.properties.first.toString())),
      (tasks) {
        _cachedAllTasks = tasks; // Update the cached list
        _emitFilteredAndSortedTasks(emit, event.filter, event.sortOption);
      },
    );
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    final result = await addTask(AddTaskParams(task: event.task));
    result.fold(
      (failure) =>
          emit(TaskError(message: failure.properties.first.toString())),
      (_) {
        emit(const TaskActionSuccess(message: 'Task added successfully!'));
        // Refresh with current filter/sort settings
        final TaskLoaded? currentState =
            state is TaskLoaded ? (state as TaskLoaded) : null;
        add(
          GetTasksEvent(
            filter: currentState?.currentFilter,
            sortOption: currentState?.currentSortOption,
          ),
        );
      },
    );
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final result = await updateTask(UpdateTaskParams(task: event.task));
    result.fold(
      (failure) =>
          emit(TaskError(message: failure.properties.first.toString())),
      (_) {
        emit(const TaskActionSuccess(message: 'Task updated successfully!'));
        // Refresh with current filter/sort settings
        final TaskLoaded? currentState =
            state is TaskLoaded ? (state as TaskLoaded) : null;
        add(
          GetTasksEvent(
            filter: currentState?.currentFilter,
            sortOption: currentState?.currentSortOption,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final result = await deleteTask(DeleteTaskParams(id: event.id));
    result.fold(
      (failure) =>
          emit(TaskError(message: failure.properties.first.toString())),
      (_) {
        emit(const TaskActionSuccess(message: 'Task deleted successfully!'));
        // Refresh with current filter/sort settings
        final TaskLoaded? currentState =
            state is TaskLoaded ? (state as TaskLoaded) : null;
        add(
          GetTasksEvent(
            filter: currentState?.currentFilter,
            sortOption: currentState?.currentSortOption,
          ),
        );
      },
    );
  }

  Future<void> _onToggleTaskCompletion(
    ToggleTaskCompletionEvent event,
    Emitter<TaskState> emit,
  ) async {
    final result = await markTaskCompleted(
      MarkTaskCompletedParams(id: event.id, isCompleted: event.isCompleted),
    );
    result.fold(
      (failure) =>
          emit(TaskError(message: failure.properties.first.toString())),
      (_) {
        emit(const TaskActionSuccess(message: 'Task status updated!'));
        // Refresh with current filter/sort settings
        final TaskLoaded? currentState =
            state is TaskLoaded ? (state as TaskLoaded) : null;
        add(
          GetTasksEvent(
            filter: currentState?.currentFilter,
            sortOption: currentState?.currentSortOption,
          ),
        );
      },
    );
  }

  void _emitFilteredAndSortedTasks(
    Emitter<TaskState> emit,
    TaskFilter? eventFilter,
    TaskSortOption? eventSortOption,
  ) {
    List<TaskEntity> processedTasks = List.from(_cachedAllTasks);

    // Determine current filter/sort from event or existing state
    TaskFilter currentFilter = eventFilter ?? TaskFilter.all;
    TaskSortOption currentSortOption =
        eventSortOption ?? TaskSortOption.dueDateAsc;

    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      currentFilter = eventFilter ?? currentState.currentFilter;
      currentSortOption = eventSortOption ?? currentState.currentSortOption;
    }

    // Apply filtering
    if (currentFilter == TaskFilter.completed) {
      processedTasks =
          processedTasks.where((task) => task.isCompleted).toList();
    } else if (currentFilter == TaskFilter.pending) {
      processedTasks =
          processedTasks.where((task) => !task.isCompleted).toList();
    }

    // Apply sorting
    switch (currentSortOption) {
      case TaskSortOption.dueDateAsc:
        processedTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case TaskSortOption.dueDateDesc:
        processedTasks.sort((a, b) => b.dueDate.compareTo(a.dueDate));
        break;
      case TaskSortOption.titleAsc:
        processedTasks.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
      case TaskSortOption.titleDesc:
        processedTasks.sort(
          (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()),
        );
        break;
    }

    emit(
      TaskLoaded(
        tasks: processedTasks,
        currentFilter: currentFilter,
        currentSortOption: currentSortOption,
      ),
    );
  }
}
