import 'package:flutter/material.dart';
import 'package:pepper_cloud_task_manager/core/util/date_formatter.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/entities/task_entity.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final ValueChanged<bool?> onToggleCompleted;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleCompleted,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if the task is overdue
    final bool isOverdue = !task.isCompleted && task.dueDate.isBefore(DateTime.now().subtract(const Duration(days: 1)));

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox for completion status
            Checkbox(
              value: task.isCompleted,
              onChanged: onToggleCompleted,
              activeColor: Colors.green,
            ),
            // Main task content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task Title
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                      color: task.isCompleted ? Colors.grey : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  // Task Description
                  Text(
                    task.description,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: task.isCompleted ? Colors.grey : Colors.black54,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  // Due Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14.0,
                        color: isOverdue ? Colors.red : Colors.grey[600],
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        DateFormatter.formatDueDate(task.dueDate),
                        style: TextStyle(
                          color: isOverdue ? Colors.red : Colors.grey[600],
                          fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Action Buttons
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit,
                  tooltip: 'Edit Task',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                  tooltip: 'Delete Task',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}