import 'package:hive/hive.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/entities/task_entity.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends TaskEntity {
  @override
  @HiveField(0)
  final String id;

  @override
  @HiveField(1)
  final String title;

  @override
  @HiveField(2)
  final String description;

  @override
  @HiveField(3)
  final DateTime dueDate;

  @override
  @HiveField(4)
  final bool isCompleted;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
  }) : super(
         id: id,
         title: title,
         description: description,
         dueDate: dueDate,
         isCompleted: isCompleted,
       );

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      dueDate: entity.dueDate,
      isCompleted: entity.isCompleted,
    );
  }

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      isCompleted: isCompleted,
    );
  }

  @override
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
