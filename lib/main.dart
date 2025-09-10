import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pepper_cloud_task_manager/app/app.dart';
import 'package:pepper_cloud_task_manager/di/injector.dart' as di;
import 'package:pepper_cloud_task_manager/features/task/data/models/task_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter()); // Register generated adapter
  await Hive.openBox<TaskModel>('tasks'); // Open our task box

  // Initialize dependency injection
  await di.init();

  runApp(const MyApp());
}