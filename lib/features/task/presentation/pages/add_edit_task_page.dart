import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/entities/task_entity.dart';
import 'package:pepper_cloud_task_manager/features/task/presentation/bloc/task_bloc.dart';
import 'package:pepper_cloud_task_manager/features/task/presentation/widgets/task_form.dart';
import 'package:uuid/uuid.dart';

class AddEditTaskPage extends StatefulWidget {
  final bool isEditing;
  final TaskEntity? task;

  const AddEditTaskPage({
    super.key,
    required this.isEditing,
    this.task,
  }) : assert(!isEditing || task != null, 'Task must be provided when editing.');

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.isEditing ? widget.task!.title : '');
    _descriptionController = TextEditingController(text: widget.isEditing ? widget.task!.description : '');
    _selectedDate = widget.isEditing ? widget.task!.dueDate : null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // First, validate the form.
    if (_formKey.currentState!.validate()) {
      // Create the task entity based on form data
      final taskEntity = TaskEntity(
        id: widget.isEditing ? widget.task!.id : const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _selectedDate!,
        isCompleted: widget.isEditing ? widget.task!.isCompleted : false,
      );

      // Dispatch the appropriate event to the BLoC
      if (widget.isEditing) {
        context.read<TaskBloc>().add(UpdateTaskEvent(task: taskEntity));
      } else {
        context.read<TaskBloc>().add(AddTaskEvent(task: taskEntity));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Task' : 'Add Task'),
      ),
      // BlocListener handles navigation and snackbars after an action is completed.
      body: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskActionSuccess) {
            // If the action was successful, pop the screen to return to the list.
            context.pop();
          } else if (state is TaskError) {
            // If there was an error, show a snackbar.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: TaskForm(
            formKey: _formKey,
            titleController: _titleController,
            descriptionController: _descriptionController,
            selectedDate: _selectedDate,
            onDateSelected: (newDate) {
              setState(() {
                _selectedDate = newDate;
              });
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitForm,
        icon: const Icon(Icons.save),
        label: Text(widget.isEditing ? 'Update Task' : 'Save Task'),
      ),
    );
  }
}