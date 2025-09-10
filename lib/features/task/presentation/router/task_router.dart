import 'package:go_router/go_router.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/entities/task_entity.dart';
import 'package:pepper_cloud_task_manager/features/task/presentation/pages/add_edit_task_page.dart';
import 'package:pepper_cloud_task_manager/features/task/presentation/pages/task_list_page.dart';

class TaskRoutes {
  static const String taskList = '/';
  static const String addTask = '/add-task';
  static const String editTask = '/edit-task';
}

final List<GoRoute> taskRoutes = [
  GoRoute(
    path: TaskRoutes.taskList,
    builder: (context, state) => const TaskListPage(),
  ),
  GoRoute(
    path: TaskRoutes.addTask,
    builder: (context, state) => const AddEditTaskPage(isEditing: false),
  ),
  GoRoute(
    path: TaskRoutes.editTask,
    builder: (context, state) {
      final TaskEntity? task = state.extra as TaskEntity?;
      if (task == null) {
        // Handle error: navigate back or show a message
        return const TaskListPage();
      }
      return AddEditTaskPage(isEditing: true, task: task);
    },
  ),
];