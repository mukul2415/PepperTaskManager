import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pepper_cloud_task_manager/features/task/presentation/router/task_router.dart';

final GoRouter appRouter = GoRouter(
  routes: [...taskRoutes],
  errorBuilder:
      (context, state) => Center(child: Text('Error: ${state.error}')),
);
