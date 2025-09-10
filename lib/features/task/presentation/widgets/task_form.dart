import 'package:flutter/material.dart';
import 'package:pepper_cloud_task_manager/core/common/validators.dart';
import 'package:pepper_cloud_task_manager/core/util/date_formatter.dart';

class TaskForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const TaskForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {

    final dateController = TextEditingController(
      text: selectedDate != null ? DateFormatter.formatDueDate(selectedDate!) : '',
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                hintText: 'e.g., Buy groceries',
                border: OutlineInputBorder(),
              ),
              validator: Validators.validateTitle,
            ),
            const SizedBox(height: 16.0),

            // Description
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'e.g., Milk, bread, eggs...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              validator: Validators.validateDescription,
            ),
            const SizedBox(height: 16.0),

            // Due Date
            TextFormField(
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Due Date',
                hintText: 'Select a date',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              onTap: () => _selectDate(context),
              validator: (value) => Validators.validateDueDate(selectedDate),
            ),
          ],
        ),
      ),
    );
  }

  // show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
  }
}