import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pepper_cloud_task_manager/core/util/date_formatter.dart';
import 'package:pepper_cloud_task_manager/features/task/presentation/bloc/task_bloc.dart';
import 'package:pepper_cloud_task_manager/features/task/presentation/router/task_router.dart';
import 'package:pepper_cloud_task_manager/features/task/presentation/widgets/task_card.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  TaskFilter _selectedFilter = TaskFilter.all;
  TaskSortOption _selectedSortOption = TaskSortOption.dueDateAsc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
/*        actions: [
          _buildFilterDropdown(),
          _buildSortDropdown(),
        ],*/
      ),
      body: Column(
        children: [

          Container(
            width: double.infinity,
            color: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: _buildFilterDropdown()),

                Container(
                  width: 1,
                  height: 30,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                ),

                Expanded(child: _buildSortDropdown()),
              ],
            ),
          ),

          const SizedBox(height: 16.0),

          Expanded(
            child: BlocConsumer<TaskBloc, TaskState>(
              listener: (context, state) {
                if (state is TaskActionSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is TaskError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.message}')),
                  );
                }
              },
              builder: (context, state) {
                if (state is TaskLoading || state is TaskInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TaskLoaded) {
                  if (state.tasks.isEmpty) {
                    return const Center(
                      child: Text('No tasks found. Add a new task to get started!'),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: state.tasks.length,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];
                      return TaskCard(
                        task: task,
                        onToggleCompleted: (bool? isCompleted) {
                          if (isCompleted != null) {
                            context.read<TaskBloc>().add(
                                ToggleTaskCompletionEvent(id: task.id, isCompleted: isCompleted));
                          }
                        },
                        onEdit: () {
                          context.push(TaskRoutes.editTask, extra: task);
                        },
                        onDelete: () {
                          _confirmDelete(context, task.id, task.title);
                        },
                      );
                    },
                  );
                } else if (state is TaskError) {
                  return Center(
                    child: Text(
                      'Failed to load tasks: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const Center(child: Text('Unknown state'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(TaskRoutes.addTask);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<TaskFilter>(
        value: _selectedFilter,
        icon: const Icon(Icons.filter_list, color: Colors.white),
        items: const [
          DropdownMenuItem(
            value: TaskFilter.all,
            child: Text('All'),
          ),
          DropdownMenuItem(
            value: TaskFilter.completed,
            child: Text('Completed'),
          ),
          DropdownMenuItem(
            value: TaskFilter.pending,
            child: Text('Pending'),
          ),
        ],
        onChanged: (TaskFilter? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedFilter = newValue;
            });
            context.read<TaskBloc>().add(GetTasksEvent(
              filter: _selectedFilter,
              sortOption: _selectedSortOption,
            ));
          }
        },
        hint: const Text('Filter'),
        style: const TextStyle(color: Colors.white),
        dropdownColor: Colors.blue[700],
      ),
    );
  }

  Widget _buildSortDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<TaskSortOption>(
        value: _selectedSortOption,
        icon: const Icon(Icons.sort, color: Colors.white),
        items: const [
          DropdownMenuItem(
            value: TaskSortOption.dueDateAsc,
            child: Text('Due Date (Asc)'),
          ),
          DropdownMenuItem(
            value: TaskSortOption.dueDateDesc,
            child: Text('Due Date (Desc)'),
          ),
          DropdownMenuItem(
            value: TaskSortOption.titleAsc,
            child: Text('Title (A-Z)'),
          ),
          DropdownMenuItem(
            value: TaskSortOption.titleDesc,
            child: Text('Title (Z-A)'),
          ),
        ],
        onChanged: (TaskSortOption? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedSortOption = newValue;
            });
            context.read<TaskBloc>().add(GetTasksEvent(
              filter: _selectedFilter,
              sortOption: _selectedSortOption,
            ));
          }
        },
        hint: const Text('Sort'),
        style: const TextStyle(color: Colors.white),
        dropdownColor: Colors.blue[700],
      ),
    );
  }



  void _confirmDelete(BuildContext context, String taskId, String taskTitle) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete "$taskTitle"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                context.read<TaskBloc>().add(DeleteTaskEvent(id: taskId));
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}